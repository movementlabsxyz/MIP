# MD-49: Movement L2 Gas Fees
- **Description**: Provide a means of computing, charging, and distributing gas fees for the Movement L2s which rely on a separate DA and Settlement Layer, e.g., the Movement Network.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Reviewer**: Andreas Penzkofer


## Overview
In order to understand how to fairly and effectively incentivize participation in the Movement Network, we need to establish a means of computing, charging, and distributing gas fees for the Movement L2s which rely on a separate DA and Settlement Layer. This will allow us to ensure that the Movement Network is able to operate efficiently and that the incentives for participation are aligned with the goals of the Movement Network.

The work done in a Movement Network L2 is mostly outlined in [MIP-19](https://github.com/movementlabsxyz/MIP/pull/19). These desiderata request means to actually compute said work, charge proportional gas fees, and distribute these fees to the appropriate parties.

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
### D1: Specify How to Compute Execution Fees for a Movement L2

**User Journey**: A developer can implement execution fee computation for a Movement L2 from a specification thereof.

**Justification**:  [MIP-19](https://github.com/movementlabsxyz/MIP/pull/19) categorizes execution fees as "the costs that correspond to resources usage, CPU and permanent storage." These need to be accounted for in any system to ensure the operators of nodes are appropriately incentivized for their participation and the fairness of resource usage is maintained.

### D2: Specify How to Compute DA Gas Fees for a Movement L2

**User Journey**: A developer can implement DA fee computation for a Movement L2 from a specification thereof.

**Justification**:  [MIP-19](https://github.com/movementlabsxyz/MIP/pull/19) categorizes DA fees as "the costs of publishing transactions/blocks data to a data availability layer." These are considered separately from execution fees because the DA is expected to be a extrinsic system with its own fee model.

### D3: Specify How to Compute Settle Gas Fees for a Movement L2

**User Journey**: A developer can implement settlement fee computation for a Movement L2 from a specification thereof.

**Justification**: [MIP-19](https://github.com/movementlabsxyz/MIP/pull/19) categorizes DA fees as "the costs of validating a transaction (e.g. zk-proof generation and verification, validators attestations)." These are considered separately from execution fees because settlement is expected to be a extrinsic system with its own fee model.

### D4: Specify which Participants Should Be Charged which Gas Fees

**User Journey**: A network participant can understand which fees they are responsible for.

**Justification**: Costs can be passed through to various actors in the L2 system. It is important to specify which actors are responsible for which fees to ensure that the system is fair and that the incentives for participation are aligned with the goals of the Movement Network.

### D5: Specify How to Distribute Gas Fees to the Appropriate Parties

**User Journey**: A network participant can understand how gas fees are distributed.

**Justification**: Gas fees must ultimately be used to pay extrinsic costs or else be considered as rewards. It is important to specify how gas fees are distributed to ensure that the system is fair and that the incentives for participation are aligned with the goals of the Movement Network.

## Errata
<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the desiderata in which the error was identified.

  TODO: Maintain this comment.
-->
