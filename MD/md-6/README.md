# MD-6: Suzuka Block Validation
- **Description**: Provide means to validate blocks to prevent public DA DOS attacks.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)


## Overview
The current implementation of the Suzuka Network relies on a public and permissionless DA. The blocks are further not validated besides their correctness w.r.t. the Aptos executor. 

This could lead to an unsophisticated DOS attack wherein the attacker simply spams the network with low gas fee--both on the DA and in the execution layer--blocks. A slightly more sophisticated attack would see the attack DOS the DA namespace itself in a [Woods Attack](https://forum.celestia.org/t/woods-attack-on-celestia/59).

While we cannot prevent latter, providing solutions to the former may prove vital to fairness amongst genuine network participants.

## Desiderata

<!--
  List out the specific desiderata. Each entry should consist of:

  1. Title: A concise name for the desideratum.
  2. User Journey: A one or two-sentence statement focusing on the "user" (could be a human, machine, software, etc.) and their interaction or experience.
  3. Description (optional): A more detailed explanation if needed.
  4. Justification: The reasoning behind the desideratum. Why is it necessary or desired?
  5. Recommendations (optional): Suggestions or guidance related to the desideratum.

  Format as:

  ### Desideratum Title

  **User Journey**: [user] can [action].

  **Description**: <More detailed explanation if needed (optional)>

  **Justification**: <Why this is a significant or required desideratum>

  **Recommendations**: <Any specific guidance or suggestions (optional)>

  TODO: Remove this comment before finalizing.
-->
### D1: Model Transaction Fairness in Suzuka Network
**User Journey**: A researcher or protocol implementer can understand what transaction fairness means in the Suzuka Network.

**Justification**: Transaction fairness is a key component of any blockchain network. It is important to understand what it means in the context of the Suzuka Network.

**Recommendations**:
- The strongest form of formally defined fairness is currently [batch-order-fairness](https://link.springer.com/chapter/10.1007/978-3-030-56877-1_16). What would it mean for the Suzuka Network to achieve this. 
- Transaction fairness should consider:
    - Time in flight
    - Congestion
    - Ingress node
    - Causality

### D2: Accept Only Blocks Signed by Staked Validators
**User Journey**: A staked Suzuka Validator is the only entity that can submit blocks to the network which will later be processed by the Aptos executor.

**Justification**: This will prevent DOS attacks on the network by requiring a stake to submit blocks.

**Recommendations**:
- Be sure to consider what is lost in this approach. For example, currently, a developer could bypass a Suzuka Full Node an submit directly to the DA--allowing them to avoid any potential censorship. This would be lost in a naive implementation of this approach, as they would be required to either (a) submit via a full-node or (b) stake themselves.

### D3: Invalidation or Validator-slashing for Producing Unfair Blocks
**User Journey**: Validators can be slashed for producing unfair blocks.

**Justification**: This will disincentivize validators from producing unfair blocks.

**Recommendations**:
- This would be a highly experimental feature and should be researched and implemented with caution. 
- Deterministic transaction and block ordering should cover most of the cases of unfairness. These are discussed in [MD-7](../md-7/README.md). However, in theory you could also slash on conditions like including too many transactions from one user, sending too many blocks at a given time, sending too few blocks at a given time, sending blocks of unequal size when transactions are available, etc.


## Errata
<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the desiderata in which the error was identified.

  TODO: Maintain this comment.
-->
