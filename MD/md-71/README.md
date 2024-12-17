# MD-71: Informer service
- **Description**: Provide a component that informs about the total circulating supply of \$MOVE across L1 and L2.
- **Authors**: [Author](mailto:andreas.penzkofer@movementlabs.xyz)

<!--
  This template is for drafting Desiderata. It ensures a structured representation of wishes, requirements, or needs related to the overarching objective mentioned in the title. After filling in the requisite fields, please delete these comments.

  Note that an MD number will be assigned by an editor. When opening a pull request to submit your MD, please use an abbreviated title in the filename, `md-draft_title_abbrev.md`.

  The title should be 44 characters or less. It should not repeat the MD number in title.

  The author should add himself as a code owner in the `.github/CODEOWNERS` file for the MD.

  TODO: Remove this comment before finalizing.
-->

## Overview

Several components should react if the bridge is under attack or faulty. In particular, the considered components are the Security Fund, see [MIP-50](https://github.com/movementlabsxyz/MIP/pull/50) and the Rate Limiter, see [MIP-56](https://github.com/movementlabsxyz/MIP/pull/56), and more generally the governance operator.

The Operator that controls these components requires knowledge about the states of minted or locked tokens on L1 and L2. Moreover, the operation of these components may be handled via a governance, which could also rely on state information.

This MD requests to provide an informing service that satisfies the above.

## Desiderata

### D1: Implications if relayer does not utilize postconfirmations.

The postconfirmation process is a synchronization mechanism for L2 to L1, see [MIP-37](https://github.com/movementlabsxyz/MIP/pull/37).

If the Relayer completes transfers from L2 to L1 without awaiting postconfirmation of the L2 `initiate` transaction, synchronization guarantees are reduced. The postconfirmation is an anchoring mechanism that binds the L2 to a certain L2 block height and hash, and hinders reorgs beyond a certain depth on L2.

We need to check the implications for the Informer if the Relayer ignores postconfirmations.

### D2: 



<!--
  List out the specific desiderata. Each entry should consist of:

  1. Title: A concise name for the desideratum.
  2. User Journey: A one or two-sentence statement focusing on the "user" (could be a human, machine, software, etc.) and their interaction or experience.
  3. Description (optional): A more detailed explanation if needed.
  4. Justification: The reasoning behind the desideratum. Why is it necessary or desired?
  5. Recommendations (optional): Suggestions or guidance related to the desideratum.

  Format as:

  ### D<number>: Desideratum Title

  **User Journey**: [user] can [action].

  **Description**: <More detailed explanation if needed (optional)>

  **Justification**: <Why this is a significant or required desideratum>

  **Recommendations**: <Any specific guidance or suggestions (optional)>

  TODO: Remove this comment before finalizing.
-->

## Errata