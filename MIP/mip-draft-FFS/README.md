# MIP-?: Fast-Finality Settlement
- **Description**: Establish the scope and components that are part of the Fast-Finality Settlement mechanism.
- **Authors**: [Franck Cassez](), [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)


<!--
  READ MIP-1 BEFORE USING THIS TEMPLATE!

  This is the suggested template for new MIPs. After you have filled in the requisite fields, please delete these comments.

  Note that an MIP number will be assigned by an editor. When opening a pull request to submit your MIP, please use an abbreviated title in the filename, `mip-draft_title_abbrev.md`.

  The title should be 44 characters or less. It should not repeat the MIP number in title, irrespective of the category.

  TODO: Remove this comment before finalizing.
-->

## Abstract

<!--
  The Abstract is a multi-sentence (short paragraph) technical summary. This should be a very terse and human-readable version of the specification section. Someone should be able to read only the abstract to get the gist of what this specification does.

  TODO: Remove this comment before finalizing.
-->


Fast-Finality Settlement (FFS) is a mechanism that allows for fast settlement of transactions with crypto-economic security. This MIP outlines the specifications for implementing FFS on the Movement blockchain.

## Definitions

- FFS - Fast Finality Settlement
- MCR - Multi-commit Rollup : an implementation of FFS
- Validator - a node that is responsible for validating transactions and producing blocks
- Postconfirmation - a finality guarantee related to L1
- L2-finality - a finality guarantee related to L2

## Motivation

<!--
  The motivation section should include a description of any nontrivial problems the MIP solves. It should not describe how the MIP solves those problems.

  TODO: Remove this comment before finalizing.
-->

This MIP introduces a mechanism that provides crypto-economical guarantees on the finality level of transactions. 

The mechanism can be deployed independently for a chain, or in combination with existing settlement mechanisms, such as ZK and optimistic settlement. The main goal of the mechanism is to provide fast-finality settlement, which is crucial for reducing transaction costs and enabling new use cases for which existing finality times are not sufficient.

A more detailed description on the security of the mechanism can be found at [this blog post on Fast-Finality Settlement](https://blog.movementlabs.xyz/article/security-and-fast-finality-settlement). A description of a (partial) implementation of the mechanism is available at [this blog post on Postconfirmations](https://blog.movementlabs.xyz/article/postconfirmations-L2s-rollups-blockchain-movement).

## Specification
<!--
  The Specification section should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations.

  It is recommended to follow RFC 2119 and RFC 8170. Do not remove the key word definitions if RFC 2119 and RFC 8170 are followed.

  TODO: Remove this comment before finalizing
-->

The Fast-Finality Settlement mechanism consists of the following components/mechanisms and which should be addressed separately in their own MIPs:

- A set of validators that are responsible for validating transactions and producing blocks, and how they communicate with each other.
- A mechanism for validators to stake tokens as collateral.
- A mechanism for validators to be penalized for misbehavior.
- A mechanism for validators to be rewarded for correct behavior.
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