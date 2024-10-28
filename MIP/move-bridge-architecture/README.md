# MIP-\<number\>: \<Title\>

- **Description**: Architecture of the bridge for Move token.
- **Authors**: [Franck Cassez](mailto:franck.cassez@movementlabs.xyz)
- **Desiderata**: [MIP-\<number\>](../MIP/mip-\<number\>)

## Abstract

This MIP describes the high-level architecture of the MOVE token bridge. The architecture describes the main bridge components and high-level requirements.

## Motivation

The Movement chain (L2) uses the \$MOVE token to pay for gas fees. As a result users need to hold \$MOVE tokens to pay for their transactions.
The _native_ \$MOVE token is an ERC-20 contract on Ethereum (L1).  By native, we mean that this is the location where the token is minted and burned and where the total supply is set and possibly modified (inflation/deflation). The \$MOVE token reserve is in the L1 contract.

To use the Movement chain and pay for gas fees, a user will acquire \$MOVE (native) tokens on L1, and bridge them to L2. On the L2 they can the token to pay for gas fees or with any other dApps that transact the \$MOVE token.
A user can choose to migrate their L2 \$MOVE tokens back to the L1 at any time.

The process of transferring tokens across different chains if implemented with a _bridge_ (between the chains).
There are several choices for the architecture of a bridge, and we describe here a bridge with a  _lock-mint-_ protocol (see Chainlink's [What Is a Cross-Chain Bridge?](https://chain.link/education-hub/cross-chain-bridge) for a quick introduction to types of bridges).

In the sequel, we use

- **L1\$MOVE** for the native token on L1,
- **L2\$MOVE** for the _wrapped_ token on L2.

The main idea of the _lock-mint_ protocol is as follows. For the sake of simplicity, assume the two chains (L1 and L2) have only one user and the user has an account `l1acc` on L1, and another account `l2acc` on L2.
If the user wants to bridge 1 L1\$MOVE to L2.

- they lock 1 L1\$MOVE into a contract `L1MoveBridge` on the L1 side: they transfer 1 L1\$MOVE from `l1acc` to the
    `L1MoveBridge` contract;
- once the contract `L1MoveBridge` receives the 1 L1\$MOVE, it emits a corresponding event `FundReceivedFrom(l1acc)`,
- a _relayer_ monitors the logs of the L1 side, and when they see the `FundReceived(l1acc)` event they send a transaction to an L2 contract, `L2MoveBridge` asking the contract to mint 1 L2\$MOVE (wrapped \$MOVE) and transfer it to `l2acc`, the user account on the L2.

The transfer from L2 to L1 is similar:

- the user transfers 1 L2\$MOVE to the `L2MoveBridge`. The `L2MoveBridge` burns (destroys) the token and emits an event
`TokenBurned(l2acc)`.
- a relayer monitors the L2 logs and when they see the event `TokenBurned(l2acc)`, they send a transaction to the L1 contract `L1MoveBridge` to _unlock_ some of the locked tokens and transfer them to   `l1acc`.

The previous protocol has three main components:

- a contract on the L1 side,
- a contract on the L2 side,
- a relayer.

As can be seen the protocol above has three distinct phases, and many things can go wrong: for instance, the user locks their funds in the L1 contract, but the relayer never issues the minting transaction. In that case the user may never be able to retrieve their funds.
What we want is some _atomicity_ between the steps: if the user locks their funds, then either the corresponding minting transaction occurs, or if it does not (and we may set a time bound), the funds are returned to the user on L1.
Another source of difficulty is to make sure that only the user `l2acc` can redeem the wrapped tokens. i.e. they are not credited to another user.

All these problems have been thoroughly studied and bridges have been in operation for several years. However hacks related to bridges account for more than 1/3 of the total hacks values which tends to indicate that bridges are vulnerable, frequently attacked, and should be designed carefully. Infamous attacks are the two Ronin bridge attacks [2022: Crypto Hackers Exploit Ronin Network for $615 Million](https://www.bankinfosecurity.com/crypto-hackers-exploit-ronin-network-for-615-million-a-18810), and [2024: Ronin Bridge Paused, Restarted After $12M Drained in Whitehat Hack](https://www.coindesk.com/tech/2024/08/06/ronin-bridge-paused-after-9m-drained-in-apparent-whitehat-hack/), and the Nomad bridge attack [August 2022: Hack Analysis: Nomad Bridge ($192M)](https://medium.com/immunefi/hack-analysis-nomad-bridge-august-2022-5aa63d53814a).
Some solutions [XChainWatcher](https://arxiv.org/abs/2410.02029) rely on monitoring bridges and detect attacks.

Designing a safe bridge is a hard problem.

## Specification

In this section we specify the high-level architecture of the bridge and identify potential attacks (with a model of the attacker).

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
