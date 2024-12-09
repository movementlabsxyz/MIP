# MIP-65: FFS: Fastconfirmations
- **Description**: Fast-Finality Settlement : Fastconfirmations as confirmations on the L2.
- **Authors**: [Andreas Penzkofer](andreas.penzkofer@movementlabs.xyz)

<!--
  READ MIP-1 BEFORE USING THIS TEMPLATE!

  This is the suggested template for new MIPs. After you have filled in the requisite fields, please delete these comments.

  Note that an MIP number will be assigned by an editor. When opening a pull request to submit your MIP, please use an abbreviated title in the filename, `mip-draft_title_abbrev.md`.

  The title should be 44 characters or less. It should not repeat the MIP number in title, irrespective of the category.

  The author should add himself as a code owner in the `.github/CODEOWNERS` file for the MIP.

  TODO: Remove this comment before finalizing.
-->

## Abstract

This MIP introduces fastConfirmations on L2 as confirmations in addition to L2-level confirmations. fastCconfirmations are a way to settle transactions on the L2 with fast confirmation times. This is achieved by using the L2 as a settlement layer for the [Fast Finality Settlement mechanism](https://github.com/movementlabsxyz/MIP/pull/34).

## Motivation

We introduce postConfirmations on L1 in [MIP-37](https://github.com/movementlabsxyz/MIP/pull/37). While postConfirmations partially draw from Ethereum security, they are  slow due to the finality time on Ethereum, and also expensive due to high L1 (Ethereum) fees.

In contrast finality times on the L2 are much faster and fees are much lower. This justifies the introduction of fastConfirmations on the L2 as a way to settle transactions on the L2 with fast confirmation times, but without any additional security guarantees from the L1.

However, postConfirmations are a simple yet elegant design which permits implementation with

- high decentralization capability
- no requirements on p2p networking between validators
- no consensus required.

PostConfirmations can draw from the consensus progress on L1. Similarly, fastConfirmations can draw from the consensus progress on block-content on L2, which is independent of the confirmation of states.

## Specification

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