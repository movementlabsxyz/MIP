# MIP-\<number\>: Native Bridge Rate-Limiter
- **Description**: A rate limitation mechanism for the native bridge.
- **Authors**: [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)

<!--
  READ MIP-1 BEFORE USING THIS TEMPLATE!

  This is the suggested template for new MIPs. After you have filled in the requisite fields, please delete these comments.

  Note that an MIP number will be assigned by an editor. When opening a pull request to submit your MIP, please use an abbreviated title in the filename, `mip-draft_title_abbrev.md`.

  The title should be 44 characters or less. It should not repeat the MIP number in title, irrespective of the category.

  The author should add himself as a code owner in the `.github/CODEOWNERS` file for the MIP.

  TODO: Remove this comment before finalizing.
-->

## Abstract

The Native Bridge Rate-Limiter is introduced to de-escalate the risk of double-spends through the bridge by limiting the number of tokens that can be transferred during a certain time frame. The rate limit is determined by the reaction time of the bridge operator and the value locked in the Security Fund, see [MIP-50](https://github.com/movementlabsxyz/MIP/pull/50).

The Native Bridge Rate Limiter is implemented through a contract on L1. This contract is governed by the Aptos governance framework, see [MIP-48](https://github.com/movementlabsxyz/MIP/pull/48/), and can be updated through a governance process.

## Motivation

The correct operation of the Native Bridge relies on liveness and safety assumptions for the relayer, see [MIP-13](https://github.com/movementlabsxyz/MIP/tree/mip/security_falliblity/MIP/mip-46). If any of these would not hold, the Native Bridge could expose the network to double-spends.

## Specification



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