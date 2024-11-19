# MIP-60: crosschain bridges architectures
- **Description**: This MIP provides some background on crosschain bridges designs and trade-offs related to security, decentralization, and performance.
- **Authors**: [Franck Cassez](mailto:franck.cassez@movementlabs.xyz)
- **Desiderata**: [MIP-\<number\>](../MIP/mip-\<number\>)


## Abstract

Crosschain bridges allow assets to be transferred between different blockchains. This MIP provides some background on crosschain bridges designs and the trade-offs related to security, decentralization, and performance.

## Motivation

To bridge from Ethereum to Move Rollup, we have to build a bridge. Ideally we would re-use an existing bridge, but there is no bridge from Ethereum to Move-based Rollups. So we have to build one.
Designing a bridge between two blockchains is a complex task. As pointed out in [Bridges – Ethereum Foundation](https://ethereum.org/en/developers/docs/bridges/#integrating-bridges):

> 1. **Building your own bridge** – Building a secure and reliable bridge is not easy, especially if you take a more trust-minimized route. Moreover, it requires years of experience and technical expertise related to scalability and interoperability studies. Additionally, it would require a hands-on team to maintain a bridge and attract sufficient liquidity to make it feasible.

To design our bridge, it may be useful to understand the main types of architectures, their strengths and weaknesses.
It can also enable us to reflect on the different discussions and proposals (MIPs, MDs) and how they relate to the different architectures.


## Specification

### Different types of bridges

There are three types of crosschain bridges. They differ in the way they handle the native assets (source chain) and the representation of the assets (wrapped asset) on the target chain.
1. **lock/mint**: the native asset is locked on the source chain and a wrapped asset is minted on the target chain.
2. **burn/mint**: the native asset is burned on the source chain and a wrapped asset is minted on the target chain.
3. **swap (atomic)**: assets are swapped on the source chain and the target chain.

Our initial bridge design [RFC-40](https://github.com/movementlabsxyz/rfcs/blob/main/0040-atomic-bridge/rfc-0040-atomic-bridge.md) is based on an _atomic swap_ (3. above).  The current architecture of our bridge is further detailed in [MIP-39](https://github.com/movementlabsxyz/MIP/blob/mip-move-bridge-architecture/MIP/mip-39/README.md) and mixes ingredients from _lock/mint_ and _swap_ (HTLC).

A swap is very generic mechanism and allows to swap any asset for any other asset. As a result it can be used to implement a bridge.  A swap involves two parties, Alice on chain A and Bob on chain B. Both Alice and Bob can withdraw from the swap deals at any time and have a time window to accept the swap deal [1, 2]. A swap mechanism usually requires an _escrow_ and a _time lock_ mechanism. 

> [!WARNING] 
>  As both parties can decide to withdraw or accept the swap, a swap requires each party to independently issue a transaction on their chain. 

In our context, 
- if a user wants to bridge from Ethereum to Move Rollup, they have to submit two transactions: one on Ethereum and one on Move Rollup. This is not user friendly and may be a barrier to adoption.
- the first transfer of Move tokens requires a user to have some _gas tokens_ (the token used to pay execution fees on the Move chain). If the gas token is the Move token, we have to implement a mechanism to sponsor the first transfer of Move tokens.


> [!TIP] 
> A _lock/mint_ or _burn/mint_ mechanism requires only one transaction from the user and is probably more user friendly.

[MIP-58](https://github.com/movementlabsxyz/MIP/pull/58/files) is a  _lock/mint_ bridge.

### Crosschain communication 

The transfer of assets between two chains requires a mechanism to communicate between the two chains. 
This mechanism is necessarily off-chain: a chain can emit events/messages to a channel but cannot receive event from a channel (they need to be converted to transactions).

> [!TIP]
> Crosschain communications can be implemented using different strategies. For a bridge the most common
is to use a _relayer_ or _messenger_ that listens to events on one chain and emits corresponding transactions on the other chain.

The _relayer_ can be _trusted_ or _untrusted_. 
Trusted relayers are usually run by the bridge operator and users must trust the operator.
Untrusted relayers (trustless bridges) rely on the trust assumptions on the source chain (e.g., Ethereum) and the target chain (e.g., Move Rollup) and the bridge operator is not required to be trusted.

> [!TIP] 
> Trusted relayers are usually faster and more cost-effective, but not decentralized so not censorship resistant. Unstrusted relayers (trustless bridges) offer greater security and decentralization but are usually slower and more expensive. 

Theer are several MIPs and MDs that discuss the relayer mechanism: [MD-21](https://github.com/movementlabsxyz/MIP/tree/primata/bridge-attestors/MD/md-21), [MIP-46](https://github.com/movementlabsxyz/MIP/pull/46), [MIP-56](https://github.com/movementlabsxyz/MIP/pull/56), [MIP-57](https://github.com/movementlabsxyz/MIP/pull/57), [MIP-58](https://github.com/movementlabsxyz/MIP/pull/58).


### Relaying information

The relayer mechanism is used to relay information about the _state_ of one chain to the other chain. 
The relayer monitors the logs of of chain and relays event emitted to the logs. The logs are part of the state of the chain.

> [!WARNING] 
> The information relayed by the relayer should be reliable and ideally immutable. 

If the relayer relays incorrect information, the bridge can be _hacked_ and assets _duplicated_ or _stolen_ (see [MIP-39](https://github.com/movementlabsxyz/MIP/blob/mip-move-bridge-architecture/MIP/mip-39/README.md).)
This problem is addressed in [issue-838](https://github.com/movementlabsxyz/movement/issues/838).

On Ethereum, a block is immutable when it is declared final.
Other criteria can be used to accept a block as almost-final (with a risk that it is not final), e.g. k-confirmations, where k is the number of blocks that have been added to the chain since the block was added. 

> [!IMPORTANT] 
> What is known is that for k=1, after the introduction on blobs on Ethereum, the probability of a block being reverted is approximately 1 every hour.
If a block is final, the probability of it being reverted is negligible.

## Trade-offs

### Type of bridge 
A simple design that is adopted by many L2 chains is the _lock/mint_ design. 
In this design, the trust assumptions are that the contracts on the source chain and the target chain are _correct_ and implement the lock and mint operations correctly.

### Relayer

Using a trusted relayer is also a popular choice.  The trust assumption on the relayer are:
- **[safety]** it relays  only final states of the chain (source or target).
- **[liveness]** it relays the states in a timely manner.

In a lock/mint with a trusted relayer, the relayer can mint assets on the target chain. 
If the relayer is compromised, the assets can be duplicated or stolen.
Special care should be taken to ensure that the relayer is not compromised (multisig?).

Even if the relayer is not compromised, it is hard to guarantee that the relayer will relay each event within a fixed time bound. 
- First, the relayer uses a network to relay the information. The network can be slow or congested.
- Second, the relayer submits a transaction (to mint the assets on the target chain) to the mempool of the target chain. The target chain may be congested or slow, or the relayer's transaction may be low priority.
- Third, the relayer must cover the cost of submitting transactions on the target chain. If the relayer's funds are low (or gas price is high), the relayer may not be able to submit the transaction.

## Security 

Assuming we have a _correct_ implementation of the lock/mint contracts on the source and target chains, and a trusted relayer, we may still have to deal with the following issues:

- relayer down (or network slow): how do we detect that the relayer is down?
- How long does it take to complete a transfer? After what time can we consider the transfer as unsuccessful?
- how do we cancel transfers? Is it a manual process or do we have a mechanism to automatically cancel transfers and refund users?

The bridging mechanisms on Arbitrum and Optimism use a [generic message passing framework](https://docs.arbitrum.io/build-decentralized-apps/cross-chain-messaging) to communicate between chains. This relies on _retryable transactions_ up to a certain number of retries or deadline.


> [!TIP] 
The [crosschain risk framework](https://crosschainriskframework.github.io/framework/01intro/introduction/) provides some guidelines and criteria for evaluating crosschain protocols security. 
Risk mitigation strategies are also discussed in [XChainWatcher](https://arxiv.org/abs/2410.02029) [3] and [SoK](https://doi.org/10.48550/arXiv.2403.00405) [4].

<!--
  The Specification section should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations.

  It is recommended to follow RFC 2119 and RFC 8170. Do not remove the key word definitions if RFC 2119 and RFC 8170 are followed.

  TODO: Remove this comment before finalizing
-->

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.


## Reference Implementation

<!--
  The Reference Implementation section should include links to and an overview of a minimal implementation that assists in understanding or implementing this specification. The reference implementation is not a replacement for the Specification section, and the proposal should still be understandable without it.

  TODO: Remove this comment before submitting
-->

## Verification

<!--

  All proposals must contain a section that discusses the various aspects of verification pertinent to the introduced changes. This section should address:

  1. **Correctness**: Ensure that the proposed changes behave as expected in all scenarios. Highlight any tests, simulations, or proofs done to validate the correctness of the changes.

  2. **Security Implications**: Address the potential security ramifications of the proposal. This includes discussing security-relevant design decisions, potential vulnerabilities, important discussions, implementation-specific guidance, and pitfalls. Mention any threats, risks, and mitigation strategies associated with the proposal.

  3. **Performance Impacts**: Outline any performance tests conducted and the impact of the proposal on system performance. This could be in terms of speed, resource consumption, or other relevant metrics.

  4. **Validation Procedures**: Describe any procedures, tools, or methodologies used to validate the proposal against its requirements or objectives. 

  5. **Peer Review and Community Feedback**: Highlight any feedback from peer reviews or the community that played a crucial role in refining the verification process or the proposal itself.


  TODO: Remove this comment before submitting
-->

Needs discussion.

---

## Errata
<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the proposal in which the error was identified.

  TODO: Maintain this comment.
-->


--- 

## References 

[1] Maurice Herlihy: Atomic Cross-Chain Swaps. PODC 2018: 245-254 [DOI](https://dl.acm.org/doi/10.1145/3212734.3212736)

[2] Maurice Herlihy, Barbara Liskov, Liuba Shrira: Cross-chain deals and adversarial commerce. VLDB J. 31(6): 1291-1309 (2022) [DOI](https://dl.acm.org/doi/10.1007/s00778-021-00686-1)

[3] André Augusto, Rafael Belchior, Jonas Pfannschmidt, André Vasconcelos, Miguel Correia:
XChainWatcher: Monitoring and Identifying Attacks in Cross-Chain Bridges.  (2024) [CoRR abs/2410.02029](https://arxiv.org/abs/2410.02029)


[4] Jakob Svennevik Notland, Jinguye Li, Mariusz Nowostawski, Peter Halland Haro: SoK: Cross-Chain Bridging Architectural Design Flaws and Mitigations. (2024)
[CoRR abs/2403.00405](https://doi.org/10.48550/arXiv.2403.00405)

---

## Appendix
<!--
  The Appendix should contain an enumerated list of reference materials and notes.

  When referenced elsewhere each appendix should be called out with [A<number>](#A<number>) and should have a matching header.

  TODO: Remove this comment before finalizing.

-->

### A1
Nothing important here.

---
## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).