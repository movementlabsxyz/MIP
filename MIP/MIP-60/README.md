# MIP-60: Cross-chain bridge architectures

- **Description**: This MIP provides some background on cross-chain bridges designs and trade-offs related to security, decentralization, and performance.
- **Authors**: [Franck Cassez](mailto:franck.cassez@movementlabs.xyz), Andreas Penzkofer

## Abstract

Cross-chain bridges allow assets to be transferred between different blockchains. This MIP provides some background on cross-chain bridge designs and the trade-offs related to security, decentralization, and performance.

## Motivation

To transfer assets from Ethereum to the chain (and back), we have to employ a _bridge_. Ideally we would re-use an existing bridge, but there is no available bridge template from Ethereum to Move-based chains, so we have to design one.
Designing a bridge between two blockchains is a complex task. As pointed out in [Bridges – Ethereum Foundation](https://ethereum.org/en/developers/docs/bridges/#integrating-bridges):

> 1. **Building your own bridge** – Building a secure and reliable bridge is not easy, especially if you take a more trust-minimized route. Moreover, it requires years of experience and technical expertise related to scalability and interoperability studies. Additionally, it would require a hands-on team to maintain a bridge and attract sufficient liquidity to make it feasible.

To design our bridge, it may be useful to understand the main types of architectures, their strengths and weaknesses. It can also help us reflect on the different discussions and proposals (MIPs, MDs) and how they relate to the different architectures.


## Definitions and Bridge introduction

Bridge terminology is frequently ambiguous as the following shows but we attempt to clarify the terms used in this MIP.

**Base classes of bridges** [[5]][REF5]

There are several base classes of bridges to apply to our setting. We select **Native Bridge** as the most appropriate for our use case.

- **Native Bridges** bootstrap liquidity from a base chain into a different chain, e.g. to onboard users and move value into a chain.
- **Canonical Bridges** is a term typically used to refer to L1 to L2 bridges, and have a similar meaning to Native Bridges. They typically take a longer period of time to bridge assets than liquidity networks as they require a time period for finality to be established, such as the challenge period for optimistic
rollups.
- **Validating Bridges** are bridges between Ethereum and another chain, where the bridge contract verifies the state updates proposed by the off-chain system.
- **Validator or Oracle-based Bridges** rely on a set of external validators or oracles to validate cross-chain transfers.

> [!NOTE]
> The term **Native Bridge** is used to refer to a bridge that transfers the native ERC-20 `$L1MOVE` token from a base chain (L1) to the `$L2MOVE` token on a different chain (L2).

**Liquidity Networks** [[5]][REF5]

The term of Liquidity Networks is associated with 

- **Continuous Liquidity Pools** The majority of Liquidity Networks consist of two liquidity pools of assets - one on the source and the other on the destination chain. In this structure, an intermediary token can act as an exchange medium allowing accurate amounts of the final token to be transferred to the user and to rebalance the pools once a transaction has occurred, e.g. RUNE in Thorchain, or stablecoins such as USDC in Stargate.

In our setting the intermediary IS the final token, and this could be interpreted as a **lock/unlock** bridge.

- **Continuous Liquidity Pools (CLP) with AMMs** are a subset of Continuous Liquidity Pools that use Automated Market Makers (AMMs) in series. [MIP-40](https://github.com/movementlabsxyz/MIP/pull/40) has proposed such a design.

**Types of bridge mechanisms**

There are three types of cross-chain bridges. They differ in the way they handle the native assets (source chain) and the representation of the assets (wrapped asset) on the target chain.

1. **burn/mint**: the asset is burned on the source chain and an asset is minted on the target chain.
_Supply: The bridge operator is in control of creating supply on both chains._
1. **lock/mint**: the native asset (minted e.g. in an ERC20 contract) is locked on the source chain and a wrapped asset is minted on the target chain.
_Supply: The bridge operator is only in control of minting supply on the target chain (L2). On L1 the bridge operator holds a token pool into/from which tokens get locked/unlocked._
1. **lock/unlock**: although difficult to classify in literature, this variant naturally completes the above two types. It may be classified as a subcategory of a swap, a **liquidity network** (see above), or it could be interpreted as a trusted [Automated Market Maker (AMM) with a constant sum invariant](https://medium.com/@0xmirai77/curve-v1-the-stableswap-invariant-f87ad7641aa0). The asset is locked on the source chain and unlocked on the target chain. 
_Supply: The bridge operator is neither in control of creating new supply on the source chain nor on the target chain. The bridge operator only holds token pools into/from which tokens get locked/unlocked._

!!! warning A lock/mint that is capped may be considered effectively a lock/unlock mechanism. However, it differs in that in the lock/mint assets are burned and minted, whereas in the lock/unlock assets are locked and unlocked.

To complete the lingo, we also mention the definition of swaps:

4. **swap (atomic)**: A swap is a generic mechanism and allows to swap any asset for any other asset. As a result it can be used to implement a bridge. Assets are swapped from the source chain against, potentially non-equivalent tokens on the target chain. A swap involves two parties, Alice on chain A and Bob on chain B. Both Alice and Bob can withdraw from the swap deals at any time and have a time window to accept the swap deal [[1]][REF1],[[2]][REF2]. A swap mechanism usually requires an _escrow_ and a _time lock_ mechanism.

> [!WARNING]
> As both parties can decide to withdraw or accept the swap, a swap requires each party to independently issue a transaction on their chain.

> [!NOTE]
> Source and target imply direction: e.g. for a swap, burn/mint and lock/unlock between a user1 on chain A and a user2 on chain B, the source chain of user1 is chain A and the target chain is chain B. For these three bridge mechanisms the transfer in opposite direction would be called the same. In contrast, **lock/mint** implies that the source chain is the chain where the native asset lives. But the bridge also operates in the opposite direction - however a more correct term for the opposite direction would be a **burn/unlock** mechanism instead.

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

### Cross-chain communication and the Relayer

The transfer of assets between two chains requires a mechanism to communicate between the two chains. This mechanism is necessarily off-chain: a chain can emit events/messages to a channel but cannot receive event from a channel (they need to be converted to transactions).

> [!TIP]
> Cross-chain communications can be implemented using different strategies. For a bridge the most common is to use a _relayer_ or _messenger_ that listens to events on one chain and emits corresponding transactions on the other chain.

The _relayer_ can be _trusted_ or _untrusted_. Trusted relayers are usually run by the bridge operator and users must trust the operator. Untrusted relayers (trustless bridges) rely on the trust assumptions on the source chain (e.g., Ethereum) and the target chain (e.g., Movement Network) and the bridge operator is not required to be trusted.

> [!TIP]
> Trusted relayers are usually faster and more cost-effective, but not decentralized so not censorship resistant. Untrusted relayers (trustless bridges) offer greater security and decentralization but are usually slower and more expensive.

There are several MIPs and MDs that discuss the relayer mechanism: [MD-21](https://github.com/movementlabsxyz/MIP/tree/primata/bridge-attestors/MD/md-21), [MIP-46](https://github.com/movementlabsxyz/MIP/pull/46), [MIP-56](https://github.com/movementlabsxyz/MIP/pull/56), [MIP-57](https://github.com/movementlabsxyz/MIP/pull/57), [MIP-58](https://github.com/movementlabsxyz/MIP/pull/58).


### What is communicated?

The relayer mechanism is used to relay information about the _state_ of one chain to the other chain. The relayer monitors the logs of a chain and relays event emitted to the logs. The logs are part of the _state_ of the chain.

> [!WARNING] 
> The information relayed by the relayer should be reliable and ideally immutable. 

If the relayer relays incorrect information, the bridge can be _hacked_ and assets _duplicated_ or _stolen_ (see [MIP-39](https://github.com/movementlabsxyz/MIP/blob/mip-move-bridge-architecture/MIP/mip-39/README.md), [MIP-46](https://github.com/movementlabsxyz/MIP/tree/mip/security_falliblity/MIP/mip-46)) This problem is addressed in [issue-838](https://github.com/movementlabsxyz/movement/issues/838).

On Ethereum, a block is immutable when it is declared _final_. Until is is final, a block can be _reverted_ (i.e., the transactions in the block are not executed).
Other criteria can be used to accept a block as _almost-final_ with a risk that it is reverted, e.g. k-confirmations, where k is the number of blocks that have been added to the chain since the block was added, see also [issue-838](https://github.com/movementlabsxyz/movement/issues/838).

> [!IMPORTANT]
> Since the introduction on blobs on Ethereum, the [probability of a 1-confirmed block being reverted is approximately 0.3%](https://ethresear.ch/t/big-blocks-blobs-and-reorgs/19674), so 3 out of 1000, approximately once every hour. In contrast if a block is final, the probability of it being reverted is negligible as it is protected by the fully economic security of the Ethereum finality mechanism.


### Trusted Relayer

Using a trusted relayer is a popular choice. The trust assumption on the relayer are:

- **[safety]** it relays  only final states of the chain (source or target).
- **[liveness]** it relays the states in a timely manner.

**[safety]**
In the lock/mint design with a trusted relayer, the relayer can mint assets on the target chain. If the relayer is compromised, the assets can be duplicated or stolen. Special care should be taken to ensure that the relayer is not compromised (multisig?).

**[liveness]**
Even if the relayer is not compromised, it is hard to guarantee that the relayer will relay each event within a fixed time bound.

1. The message delivery network can be slow or congested.
2. The relayer submits a transaction (to mint the assets on the target chain) to the mempool of the target chain. But the target chain may be down, congested or slow, or the relayer's transaction may be low priority.
3. The relayer must cover the cost of submitting transactions on the target chain. If the relayer's funds are low (or gas price is high), the relayer may not be able to submit the transaction.

### Designs

**HTLC-based design**

Our initial bridge design, [RFC-40](https://github.com/movementlabsxyz/rfcs/blob/main/0040-atomic-bridge/rfc-0040-atomic-bridge.md), is based on an _atomic swap_ (4. above).  The current architecture of our bridge, [MIP-39](https://github.com/movementlabsxyz/MIP/blob/mip-move-bridge-architecture/MIP/mip-39/README.md), borrows ideas from _lock/mint_ and _swap_ ([HTLC](https://en.bitcoin.it/wiki/Hash_Time_Locked_Contracts)):
 
- if a user wants to bridge from Ethereum to Movement Network, they have to submit two independent transactions: one on Ethereum (lock) and one on Movement Network (mint). This is not user friendly and may be a barrier to adoption.
<!-- A bridge is slightly different to a swap in the sense that the two transactions (lock and mint) are not meant to be decoupled.-->
- another issue is that the first transfer of MOVE tokens requires a user to have some _gas tokens_ (the token used to pay execution fees on the Movement Network). If the gas token is the `$L2MOVE` token, we have to implement a mechanism to sponsor the first transfer of MOVE tokens.

**Lock/Mint design**

> [!TIP]
> A simple _lock/mint_, _burn/mint_ or _lock/unlock_ mechanism requires only one transaction from the user and is probably more user friendly than the HTLC-based design.

A simple design that is adopted by many L2 chains is the _lock/mint_ design. A user initiates a transfer on the source chain and the bridge operator is responsible for completing the transfer on the target chain. In this design, the trust assumptions are that the contracts on the source chain and the target chain are _correct_ and implement the lock and mint operations correctly (respectively burn and unlock for the opposite direction).

[MIP-58](https://github.com/movementlabsxyz/MIP/pull/58/files) is an instance of a _lock/mint_ bridge. Once initiated on the source chain, the user does not need to interact with the target chain to complete the transfer. The bridge operator is responsible for coupling the lock/mint transactions for L1->L2 transfers. Similarly for L2->L1 transfers, the bridge operator is responsible for the coupling of the burn/unlock transactions.

## Security

### Security - HTLC-based design

See [MIP-39](https://github.com/movementlabsxyz/MIP/blob/mip-move-bridge-architecture/MIP/mip-39/README.md) for a complete discussion of the security of this type of design.

### Security - Trusted-Relayer design

See [Trusted Relayer design](#58).

Assuming we have a _correct_ implementation of the lock/mint contracts on the source and target chains, and a trusted relayer, we may still have to deal with the following issues:

- Relayer is down (or network is slow): how do we detect that the relayer is down? And what measurements are taken.
- How long does it take to complete a transfer? After what time can we consider the transfer as unsuccessful?
- How do we cancel transfers? Is it a manual process or do we have a mechanism to automatically cancel transfers and refund users?
- We have to accurately estimate the cost of the transfer to charge the user for the relayer transaction on the target chain.
- How do we mitigate the risk of gas fees manipulation? For example, if gas fees are low on the L2 chain (which is the expectation), users can submit thousands of transfer transactions. If at the same time, the gas fees are high on the L1, the relayer will incur some large costs to unlock the locked assets.
- How do we ensure that for a given (successful) transfer initiation on the source chain, the relayer does not accidentally mint (or unlock) tokens twice.

The bridging mechanisms on Arbitrum and Optimism use a [generic message passing framework](https://docs.arbitrum.io/build-decentralized-apps/cross-chain-messaging) to communicate between chains. This relies on _retryable transactions_ up to a certain number of retries or deadline.

> [!TIP]
The [cross-chain risk framework](https://cross-chainriskframework.github.io/framework/01intro/introduction/) provides some guidelines and criteria for evaluating cross-chain protocols security. Risk mitigation strategies are also discussed in [XChainWatcher][REF3] and  this [SoK on Cross-Chain Bridging Architectural Design Flaws and Mitigations][REF4].

## Reference Implementation

## Verification

Needs discussion.

---

## Errata

## References

[1] Maurice Herlihy: "Atomic Cross-Chain Swaps". PODC 2018: 245-254 [DOI][REF1]

[2] Maurice Herlihy, Barbara Liskov, Liuba Shrira: "Cross-chain deals and adversarial commerce". VLDB J. 31(6): 1291-1309 (2022) [DOI][REF2]

[3] André Augusto, Rafael Belchior, Jonas Pfannschmidt, André Vasconcelos, Miguel Correia: "XChainWatcher: Monitoring and Identifying Attacks in Cross-Chain Bridges". (2024) [CoRR abs/2410.02029][REF3]

[4] Jakob Svennevik Notland, Jinguye Li, Mariusz Nowostawski, Peter Halland Haro: "SoK: Cross-Chain Bridging Architectural Design Flaws and Mitigations". (2024) [CoRR abs/2403.00405][REF4]

[5] "SoK: Cross-chain Token Bridges and Risk", 2024 IEEE International Conference on Blockchain and Cryptocurrency (ICBC), Dublin, Ireland, 2024, pp. 696-711. [IEEE Xplore][REF5]

[REF1]: https://dl.acm.org/doi/10.1145/3212734.3212736
[REF2]: https://dl.acm.org/doi/10.1007/s00778-021-00686-1
[REF3]: https://arxiv.org/abs/2410.02029
[REF4]: https://doi.org/10.48550/arXiv.2403.00405

[REF5]: https://ieeexplore.ieee.org/document/10634379

## Appendix

## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).
