# MIP-\<number\>: Security Assumptions and Fallibility
- **Description**: ????
- **Authors**: Richard, [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)

<!--
  READ MIP-1 BEFORE USING THIS TEMPLATE!

  This is the suggested template for new MIPs. After you have filled in the requisite fields, please delete these comments.

  Note that an MIP number will be assigned by an editor. When opening a pull request to submit your MIP, please use an abbreviated title in the filename, `mip-draft_title_abbrev.md`.

  The title should be 44 characters or less. It should not repeat the MIP number in title, irrespective of the category.

  The author should add himself as a code owner in the `.github/CODEOWNERS` file for the MIP.

  TODO: Remove this comment before finalizing.
-->

## Abstract

The Native Bridge design presented in [MIP-39](../mip-39/) has the following assumptions to achieve secure operation, and which we detail in [Motivation](#motivation).

Given that these hold, the sum of the token supply of `$L1MOVE` and `$L2MOVE` is equal to `MOVE_MAX`. To improve the security of the relayer and protect the total token supply against violations of the above assumptions, we propose several safety mechanisms:

1. The token supply of `$L1MOVE`, as well as `$L2MOVE` cannot exceed the total supply individually.
1. The bridge transfers are rate limited, and where the increase of that rate can only be increased by a governance body.
1. The relayer shall maximize security measurements to protect keys.


## Motivation

Two security assumptions underpin the secure operation of the bridge.

1. **Liveness of the relayer**. It is assumed that the relayer is active within some time Delta. For further details on this we refer to [MIP-39](../mip-39/).

2. **Secure relayer**. It is assumed that the relayer keys are operated securely. More specifically we require that the key access and the signing process of the relayer is not compromised. For example the keys could get compromised if a malicious entity could get access to the key(s). In the basic design, see [MIP-????](???), the relayer has the capability to mint `$L2MOVE` tokens, thus could increase the total supply if compromised.

To increase the the reliability and security of the Native Bridge design, measures to improve the above assumptions are proposed.


## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

##### 1. Fix the Potential Supply

As described in the [Abstract](#abstract), the sum of the token supply of `$L1MOVE` and `$L2MOVE` is equal to `MOVE_MAX`.Since the bridge is the sole point of creation of `$L2MOVE` token the L2 contract MUST monitor the `$L2MOVE` supply. The L2 bridge contract MUST not release more `$L2MOVE` than the maximum supply `MOVE_MAX`.

Since the maximal released supply of `$L1MOVE` is `MOVE_MAX` the maximum *Potential Supply* (of the sum of the supply of `$L1MOVE` and `$L2MOVE`) is 2 $\times$ `MOVE_MAX`, even in the case of compromised relayer.

##### 2. Native Bridge rate limiation

The bridge transfers are rate limited, and where the increase of that rate can only be increased by a governance body.

##### 3. Relayer key protection

The relayer shall maximize security measurements to protect keys.

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