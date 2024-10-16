# MIP-?: Fast-Finality Settlement

- **Description**: Establish the scope and components that are part of the Fast-Finality Settlement mechanism.
- **Authors**: [Franck Cassez](), [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)

## Abstract

Fast-Finality Settlement (FFS) is a mechanism that allows for fast _confirmation_ of transactions backed by crypto-economic security. This MIP outlines the high-level specifications and architecture of FFS.

## Definitions

- **FFS** - Fast Finality Settlement
- **L1-finality** - finality mechanism (confirmation) for layer 1
- **L2-finality** -  finality mechanism (confirmation) for layer 2
- **MCR** - Multi-commit Rollup : an implementation of FFS
- **PosP** - Proof of Stake
- **Postconfirmation** - a finality guarantee related to L1
- **Validator** - a node that is responsible for validating transactions and producing blocks

## Motivation

Layer 2s (L2) and rollups have to publish transaction data to a data availability (DA) layer or to Ethereum mainnet (Layer 1, L1). Validity (ZKP) and optimistic (FP) rollups can finalize (confirm) transactions within approximately 30 minutes (ZKP) resp. ~1 week (FP). Until a transaction is finalized, there is no assurance about its validity and result (success or failure). This can be a limiting factor for certain types of DeFi applications.

Our objective is to enable transactions's issuers to quickly get some guarantees that their transactions are correctly included in a block. The crypto-economic security is provided by a PoS protocol.

The mechanism can be deployed independently for a chain, or used in combination with existing settlement mechanisms, such as ZK and optimistic settlements.

As a result, users can rely and trust the **L2-finality**  to use as confirmation, or if the chain is configured to do so, wait for **L1-finality**, end of challenge window for fraud proofs (optimistic L2) or verification of a ZK-proof (validity L2).

A introduction to FFS can be found in [this blog post on Fast-Finality Settlement](https://blog.movementlabs.xyz/article/security-and-fast-finality-settlement). A more detailed description of a (partial) implementation of the mechanism is available at [this blog post on Postconfirmations](https://blog.movementlabs.xyz/article/postconfirmations-L2s-rollups-blockchain-movement).

This MIP provides an overview of an architecture of FFS, and its main components.

## Specification
<!--
  The Specification section should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations.

  It is recommended to follow RFC 2119 and RFC 8170. Do not remove the key word definitions if RFC 2119 and RFC 8170 are followed.

  TODO: Remove this comment before finalizing
-->

The Fast-Finality Settlement mechanism consists of the following components/mechanisms and which should be addressed separately in their own MIPs:

- A set of validators that are responsible for validating transactions and producing blocks, and how they communicate with each other.
- A mechanism for validators to create a quorum certificte for new states on L2.
- A mechanism for validators to stake tokens as collateral.
- A mechanism for validators to be rewarded for correct behavior and penalized for misbehavior.
- Postconfirmations, a mechanism for a user to obtain a confirmation for a transaction that it has been attested to on L1 by a validator.
- L2-finality, a mechanism for validators to confirm transactions after they have been included in an L2-block AND a quorum of validators has confirmed the state that is created by that L2-block.
- A fast bridge that allows for the transfer of tokens between L1 and L2, and vice versa.

## Reference Implementation

<!--
  The Reference Implementation section should include links to and an overview of a minimal implementation that assists in understanding or implementing this specification. The reference implementation is not a replacement for the Specification section, and the proposal should still be understandable without it.

  TODO: Remove this comment before submitting
-->

n/a

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

1. **Correctness**:

n/a

2. **Security Implications**:

The security of this approach is discussed in [this blog post on Fast-Finality Settlement](https://blog.movementlabs.xyz/article/security-and-fast-finality-settlement).

3. **Performance Impacts**:

The mechanism provides fast finality.

Performance concerns are

- the time it takes for a transaction to be confirmed
- the time it takes for aggregation of signatures
- the time it takes for issuing a postconfirmation and getting included in an L1-block
- the time it takes for issuing an L2-finality and getting
- the impact of the validator set size
- bridge volume capacity and time

4. **Validation Procedures**:

n/a

5. **Peer Review and Community Feedback**:

n/a

## Errata

<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the proposal in which the error was identified.

  TODO: Maintain this comment.
-->

n/a

## Appendix

<!--
  The Appendix should contain an enumerated list of reference materials and notes.

  When referenced elsewhere each appendix should be called out with [A<number>](#A<number>) and should have a matching header.

  TODO: Remove this comment before finalizing.

-->

n/a
