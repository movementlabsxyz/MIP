# MIP-\<number\>: Rate-Limiter for the Native Bridge
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

The **Rate-Limiter** for the Native Bridge is introduced to de-escalate the risk of double-spends through the bridge by limiting the number of tokens that can be transferred during a certain time frame. The rate limit is determined by the reaction time of the bridge operator, called the **Risk Period**, and the value locked in the **Security Fund**, see [MIP-50](https://github.com/movementlabsxyz/MIP/pull/50).

The Native Bridge Rate Limiter is implemented through a contract on L1. This contract is governed by the Aptos governance framework, see [MIP-48](https://github.com/movementlabsxyz/MIP/pull/48/), and can be updated through a governance process.

## Motivation

The correct operation of the Native Bridge relies on liveness and safety assumptions for the relayer, see [MIP-13](https://github.com/movementlabsxyz/MIP/tree/mip/security_falliblity/MIP/mip-46). If any of these would not hold, the Native Bridge could expose the network to double-spends.

## Specification


The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.


![Overview](overview.png)
*Figure 1: Overview of the Rate-Limiter mechanism for the Native Bridge.*

> [!NOTE] In the following we note that when talk about the Rate-Limiter, we mean the Rate-Limiter contract.

1. The Rate-Limiter SHOULD be implemented as a contract on L1.
1. The Rate-Limiter MUST handle both the **transfer directions** L1 -> L2 and L2 -> L1. 
1. For either transfer direction the transfer value MUST be tracked, i.e. the transferred value for L1->L2 should be recored in `budget_L1L2` and for L2->L1 in `budget_L2L1`.
1. The Rate-Limiter SHOULD be governed by the Aptos governance framework, see [MIP-48](https://github.com/movementlabsxyz/MIP/pull/48/), and can be updated through a governance process.
1. The `security_fund` value SHOULD be read from the actual balance from the security fund contract and updated regularly, see [MIP-50](https://github.com/movementlabsxyz/MIP/pull/50). Alternatively it COULD be updated through the security fund contract, whenever the `security_fund` value changes in the security fund contract.
1. The `risk_period` value SHOULD be set by the governance process and updated through the governance process. It estimates the maximum reaction time to check whether transfers have been completed correctly.
1. For a given transfer direction, the Rate-Limiter should disable transfers across the bridge if the rate limit is exceeded for that transfer direction.
1. The rate limit MUST be set according to the equation `rate_limit = security_fund / risk_period * 0.5`. This is to ensure that each bridge transfer direction is ensured sufficiently.
1. The Rate-Limiter MUST reject a transfer request if the rate limit is exceeded for that transfer direction by that transaction. I.e. for L1->L2 the Rate-Limiter MUST reject any transfer that would violate `budget_L1L2 < rate_limit` and for L2->L1 the Rate-Limiter MUST reject any transfer that would violate `budget_L2L1 < rate_limit`.

### Optimization

1. The Rate-Limiter COULD be implemented as a contract on L2 to save on gas costs. However the security of this approach must be carefully evaluated, as the base truth for the protocol is the L1, which entertains ultimate settlement.
1. The rate limit COULD be unbalanced between the two transfer directions, i.e. `rate_limit_L1L2 = security_fund / risk_period * weight` and `rate_limit_L2L1 = security_fund / risk_period * (1-weight)`. This would allow for a more flexible rate limit, if the network experience higher inflow into or outflow from L2.
1. The `budget_L1L2` and `budget_L2L1` values COULD be reset, if the governance is convinced that all transfers have been processed correctly and are not revertible, however this is risky due to the introduction of human error. Alternatively, an automated approach could be considered that takes into account all completed transfers. However, this is out of scope for this MIP.

### Limitations


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