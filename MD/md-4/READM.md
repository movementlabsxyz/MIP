# MD-4: MCR Offsetting Gas Costs
- **Description**: Provide models for the game theory of offsetting gas costs in MCR.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)


## Overview
In the current MCR implementation, the last attester which trips the `rollOverEpoch` function may pay large gas fees, as they perform roll-over work for previous participants. This would create a disincentive for the last attester to participate in the game, potentially not doing so at all. It has been presumed that the implementation would be updated s.t. the last attester would be specially rewarded for their work. This also creates a game-theoretic problem, as the last attester could be incentivized to wait until the last moment to participate.

To combat this, round-robin rewarding and commitment schemes such as Pedersen Commitments have been suggested. However, these have not been formalized. 

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
### D1: Model for Gas Costs in MCR without Offset
**User Journey**: A researcher or protocol implementer can understand the game theory of gas costs in MCR without offsetting.

**Justification**: The current implementation of MCR does not offset gas costs for the last attester. This could lead to a disincentive to participate in the game, provide a model which clearly shows this.

### D2: Model for Gas Costs in MCR with Offset
**User Journey**: A researcher or protocol implementer can understand the game theory of gas costs in MCR with offsetting.

**Justification**: Naive proposals suggest simply offsetting the gas cost by rewarding the last attester transparently. Provide a model which demonstrates the game theory of this.

### D3: Models for Information Incomplete Gas Cost Offset
**User Journey**: A researcher or protocol implementer can understand the game theory of gas costs in MCR with incomplete information.

**Justification**: Information incompleteness may improve the game theory of offsetting gas costs. Provide models which demonstrate this for incompleteness derived from (1) general network latency, (2) a round-robin rewarding scheme, and (3) a Pedersen Commitment scheme.

## Errata
<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the desiderata in which the error was identified.

  TODO: Maintain this comment.
-->
