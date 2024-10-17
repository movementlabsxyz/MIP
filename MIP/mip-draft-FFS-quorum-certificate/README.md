# MIP-\<number\>: \<Title\>
- **Description**: Quorum certificate for Fast-Finality Settlement
- **Authors**: [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)

<!--
  READ MIP-1 BEFORE USING THIS TEMPLATE!

  This is the suggested template for new MIPs. After you have filled in the requisite fields, please delete these comments.

  Note that an MIP number will be assigned by an editor. When opening a pull request to submit your MIP, please use an abbreviated title in the filename, `mip-draft_title_abbrev.md`.

  The title should be 44 characters or less. It should not repeat the MIP number in title, irrespective of the category.

  TODO: Remove this comment before finalizing.
-->

## Abstract

Fast-Finality Settlement (FFS) is a mechanism that allows for fast settlement of transactions with crypto-economic security, see [MIP ???](). 

This MIP outlines the specifications for implementing the quorum certificate creation for FFS. For code history reasons this protocol is called Multi-commit Rollup (MCR).

<!--
  The Abstract is a multi-sentence (short paragraph) technical summary. This should be a very terse and human-readable version of the specification section. Someone should be able to read only the abstract to get the gist of what this specification does.

  TODO: Remove this comment before finalizing.
-->


## Definitions

- FFS - Fast Finality Settlement
- Validator - a node that is responsible for validating transactions and producing blocks
- QC - Quorum Certificate - a certificate that is signed by a quorum of validators. The certificate is used to prove that a block has been committed by a quorum of validators.
- MCR - Multi-commit Rollup : an implementation of the quorum certificate creation for FFS

## Motivation

The FFS requires the creation of certificates that prove that a block has been approved by a set of validators. This certificate has to withstand Byzantine faults under the assumption that the supermajority (>2/3) is honest. Thus the certificate has to be supported by a large enough subset of the validators. 

<!--
  The motivation section should include a description of any nontrivial problems the MIP solves. It should not describe how the MIP solves those problems.

  TODO: Remove this comment before finalizing.
-->

## Specification



![Diagram to obtain the Quorum Certificate](diagram.png)
<!-- 
  The Swimlane link changes if the diagram is updated. Hence update the link if the diagram is updated.
  https://swimlanes.io/#ZdBNCoNADAXgfU7xlu3CC7gQRLsVxAOUcYxUas10JlM8fkco/XOTRfiSF9LxPfJi2SPLigJ1mUNXDEYNDk5CmPqZ4YxejkR1iazAaWUbdZIFjQz85kTdZ9Ve9bPYK9Fve4NtBedFxcqMHCE6J155QFCjDC+iRN9mN5LqzFbxEOWws3+BOdooPt5QsddpnGwK2V+1fUKiuqhp4NzISyZwhowpn+gJ
-->


<!--
  The Specification section should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations.

  It is recommended to follow RFC 2119 and RFC 8170. Do not remove the key word definitions if RFC 2119 and RFC 8170 are followed.

  The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

  TODO: Remove this comment before finalizing
-->



## Reference Implementation

Implemented: [View the Code](https://github.com/movementlabsxyz/movement/tree/main/protocol-units/settlement/mcr)

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