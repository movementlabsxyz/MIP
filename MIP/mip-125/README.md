# MIP-125: Risk Assessment for Staking and Governance Launch

- **Description**: A comprehensive risk assessment document outlining potential risks in launching staking and governance on Movement L1, including mitigation strategies and policy recommendations.
- **Authors**: [Andreas Penzkofer]()
- **Desiderata**: [MD-125](../MD/md-125)
- **Approval**: <!--Either approved (:white_check_mark:), rejected (:x:), stagnant or withdrawn by the governance body. To be inserted by governance. -->

## Abstract

This proposal provides a comprehensive risk assessment framework for launching staking and governance mechanisms on Movement L1. The document identifies critical risks across two main categories: **staking risks** _(validator concentration, insufficient participation, delegation centralization, treasury exposure, and bootstrap trust)_ and **governance risks** _(proposal spam, centralized voting power, stake-based attacks, governance delays, rushed upgrades, and legal compliance)_. 

Each risk includes specific examples, root causes, and detailed mitigation strategies to guide parameter selection and policy design for a secure and decentralized launch.

## Motivation

The successful launch of staking and governance on Movement L1 requires careful consideration of various risks that could compromise network security, decentralization, and long-term sustainability. Without proper risk assessment and mitigation strategies, the network faces potential threats including validator centralization, governance attacks, treasury exposure, and regulatory compliance issues. This proposal addresses these concerns by providing a structured framework for identifying, analyzing, and mitigating risks before they materialize.

### Definitions

- **Validator stake**: The stake of a validator.
- **Delegated stake**: The stake of a delegator.
- **Combined stake**: The sum of the validator stake and the delegated stake.
- **MVMT Fnd**: The Movement Foundation.
- **Move Inc**: The Movement Inc.
- **Soft delegation caps**: A limit on the amount of stake that can be delegated to a validator. This limit can be exceeded (hence soft) if other validators reduce their combined stake.
- **Diminishing returns**: A function that reduces the reward to a validator the more stake it holds (delegated or directly).

## Specification

_The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174._

The risk assessment follows a structured approach:

1. Risk identification through analysis of similar systems
2. Impact assessment with specific examples
3. Root cause analysis
4. Mitigation strategy development
5. Implementation considerations

### A. Behavioral Recommendations

*Addresses [MD-125 D2: Behavioral Recommendations for Launch](../MD/md-125#d2-behavioral-recommendations-for-launch)*

Based on the risk assessment, the following behavioral recommendations are made to mitigate identified risks:

**Staking Launch Behavior:**

- Use initially permissioned / white-listed validators to reduce collusion risks.
- Delegate MVMT Fnd tokens to several validators to promote diversity.
- Require minimum validator stake to ensure sufficient commitment.
- Roll out staking separately before governance decentralization.

Consider with reservations:

- Implement soft caps (relative to the total stake) for combined stake per validator. Beyond code complexity this may not come without crypto-economic challenges, so this approach should be taken with reservations.


**Governance Behavior:**

- Start with centralized governance.
- Implement and publish a progressive decentralization timeline for governance.
- Require minimum stake threshold for proposal submission.
- Require low-enough threshold for passing proposals.

### B. Staking Risks

*Addresses [MD-125 D1: Comprehensive Risk Assessment Framework](../MD/md-125#d1-comprehensive-risk-assessment-framework)*

#### 1. Validator Concentration Risk

**Description:** Excessive stake concentration can lead to centralization, collusion, or network halts.
*Example: one validator holds 0.34 of total stake and goes offline, halting block production.*

**Cause:**

- A single entity controlling > 0.33 of total stake. Could be spread across several nodes.
- No max stake cap and uneven delegation distribution.

**Mitigation:**

- MVMT Fnd should delegate to several validators.
- Enforce a **max validator stake ratio** (e.g., 0.10). Limits concentration on a single validator.
- Only permit white-listed validators. Reduces risk of collusion between validators.
- Run a majority of validators self.
- Encourage **delegation diversity** through incentives.

**Additional notes:**

- Limiting the absolute total stake is risky and not considered as a valid option. An attacker could frontrun to stake a large amount of the total stake. Obviously it also discourages token participation and increases sell pressure.
- Minor: Total stake can diminish over time. Stakers cannot be forced to unstake, so it is possible that a validator can exceed the threshold. This issue is minor.
- Diversity can in principle be encouraged by giving higher APY to validators with lower stake, however this adds additional code complexity.

#### 2. Insufficient Validator Participation

**Description:** A low number of active validators can lead to centralization and bad image.
*Example: only 6 of 20 potential validators can afford an amount $X as minimum, leaving the network under-decentralized.*

**Cause:**

- High min validator stake.
- Overly restrictive onboarding or KYC requirements.

**Mitigation:**

- Start with a reasonable low minimum but permissioned validator set.
- Adjust minimums dynamically post-launch.

#### 3. Delegation Centralization

**Description:** Delegators may prefer well-known validators, concentrating stake and influence.
*Example: 0.70 of all delegated MOVE accrues to two MVMT Foundation-associated validators.*

**Cause:**

- No max stake per validator.
- Low visibility for smaller validators.

**Mitigation:**

- Introduce soft delegation caps or diminishing returns.
- Improve validator discovery and transparency tools.

#### 4. Reward Pool and Treasury Risk Exposure

**Description:** Using Foundation or reward treasuries for staking can blur lines between governance funds and validator economics, putting them at risk.
*Example: the Foundation stakes part of its reward treasury, a slashing event reduces funds intended for future ecosystem rewards.*

**Cause:**

- Reward treasury used as validator capital.
- Undefined policy for treasury participation in staking.

**Risk:**

- Slashing due to errors or bugs could lead to unwarranted loss of funds.

**Mitigation:**

- Give well defined control over slashing, such that funds are at least initially recoverable. For example transfer slashed funds to a MVMT Fnd controlled treasury.

#### 5. Bootstrap Trust Risk

**Description:** A small, permissioned validator set makes early consensus trust-based rather than decentralized.
*Example: If all validators are operated by Move Inc, centralizing control over consensus.*

**Risk:** Bad image due to centralization.

**Cause:**

- Initial validators run by a single organization.
- No decentralization roadmap with concrete milestones.

**Mitigation:**

- Publish **decentralization milestones**.
- Gradually onboard new validators; enable appropriate **monitoring**.

---

### C. Governance Risks

*Addresses [MD-125 D1: Comprehensive Risk Assessment Framework](../MD/md-125#d1-comprehensive-risk-assessment-framework)*

#### 1. Proposal Spam and Governance Flooding

**Description:** Without minimum thresholds, actors can overload governance with junk proposals.
*Example: one actor submits 200 trivial proposals, crowding out legitimate ones.*

**Cause:**

- No **proposal deposit or stake threshold**.
- Unlimited proposal frequency.

**Mitigation:**

- Require proposers to bond **≥ X** fraction of circulating stake.
- Add **proposal cooldowns** and refundable deposits.
- Require a threshold of minimum stake to submit a proposal.

#### 2. Centralized Voting Power

**Description:** Foundation or Move Inc controlling most voting power predetermines outcomes.
*For example, if Move Inc controls 0.70 of votes via delegation and passes proposals unilaterally.*

**Cause:**

- Large token concentration in a single entity.
- Multiple validators controlled by the same operator.

**Mitigation:**

- Acknowledge initial centralization phase.
- Implement **progressive voting-power decentralization**.

#### 3. Stake-based Governance Attacks

**Description:** An attacker lends a large amount of tokens from the open market to a validator it controls, allowing it to pass proposals.

**Cause:**

- Stake-based governance.
- Insufficient stake limit on validators.

**Mitigation:**

- Implement a **stake limit** on validators, that is relative to the total stake of the network.

#### 4. Governance Delay / Inflexibility

**Description:** Prolonged delay in decentralizing governance weakens confidence and agility.

**Example:** One year post-launch, all governance still routes purely through Move Inc.

**Cause:**

- No decentralization roadmap.
- Dependencies on off-chain processes.

**Mitigation:**

- Publish **phase-based milestones** (e.g., multisig → on-chain voting).
- Track progress publicly.

#### 5. Rushed Upgrades

**Description:** Rapid or unchecked upgrades can introduce bugs or malicious code paths.

**Example:** A rushed proposal upgrades the staking contract and unintentionally locks validator funds.

**Cause:**

- No **timelock** or **security audit** before execution.
- No rollback or veto mechanism.

**Mitigation:**

- Add **execution timelocks** on passed proposals.
- Enable a temporary **emergency veto** (safety council).

#### 6. Legal and Compliance Exposure

**Description:** Move Inc-managed staking or reward distribution can draw regulatory scrutiny if deemed custodial or yield-bearing.
*For example, if regulators classify Move Inc or MVMT Fnd staking returns as securities due to weak separation between treasury and validator operations.*

**Cause:**

- Move Inc or MVMT Fnd directly participating in staking rewards.
- Lack of a compliance framework for third-party validators.

**Mitigation:**

- Maintain **legal separation** between treasury and validators.
- Apply **KYC / AML** for accredited participants where applicable.

#### 7. Governance Threshold Too High

**Description:** Maximum threshold for proposal passage may be set too high, preventing any proposals from passing and effectively halting governance.

*Example: requiring 50% of total stake to pass proposals when only 30% of the total stake is active in governance, making governance impossible.*

**Cause:**

- Overly conservative threshold setting to prevent attacks.
- Lack of consideration for realistic stake distribution.

**Mitigation:**

- Set thresholds based on realistic stake distribution analysis.
- Implement graduated thresholds that can be adjusted over time.
- Monitor proposal passage rates and adjust thresholds if needed.


## Changelog

- **2025-10-15**: Initial risk assessment document created. [PR#125](https://github.com/movementlabsxyz/MIP/pull/125)
