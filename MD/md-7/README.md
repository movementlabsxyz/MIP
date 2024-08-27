# MD-7: Prevent Suzuka MEV Exploits and Censorship
- **Description**: Provide an account of possible Suzuka MEV attacks and censorship vulnerabilities, and propose solutions to mitigate these risks.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)


## Overview
The Suzuka Network is known to be subject to MEV exploits in the form of manipulating block size and order. That is, while transactions within a block are ordered deterministically, full nodes are currently given freedom to chose which transactions to include in a block and when to send those blocks to the network. Execution-level validation will only assert that the sequence numbers are appropriate and other dApp-specific logic. There are no penalties for being to have withheld a transaction. 

The desiderata presented herein request a complete model of MEV in the Suzuka Network. They also make some provisional requests based on surmised ways to prevent certain MEV attacks.

Most of the account of MEV attacks should be based on the model of transaction fairness given in [MD-6](../md-6/README.md).

Many of MEV attacks addressed can also be classed as censorship attacks. That is, a miner can choose to not include a transaction in a block. This is a form of censorship. As such, the desiderata herein also address censorship attacks.

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
### D1: Model Suzuka MEV Attacks
**User Journey**: A researcher or protocol implementer can understand the game theory of MEV attacks in the Suzuka Network.

**Justification**: Suzuka MEV attacks are a significant risk to the network. Understanding them is the first step to preventing them.

**Recommendations**:
- Begin be enumerating all of placers where a single entity has control over transaction inclusion or ordering. 
- Assess how transaction provenance can be formed. 

### D2: Merge Blocks and Assign Deterministic Cut-points
**User Journey**: An honest Suzuka Full Node can only form the final blocks needed for execution by (a) merging blocks in a given DA height range, (b) ordering transactions deterministically, and (c) assigning deterministic cut-points for block formation.

**Justification**: If the blocks from a given DA height range are merged and then split with deterministic cut-points, a Suzuka Proposer would only be able to manipulate the inclusion or exclusion of a transaction in a given DA height range--no longer the order of blocks therein. This limitation of the action space could render most MEV attacks implausible--particularly if it increases the latency of an attack held across two block height ranges beyond the window in which the client would notice the failure and submit a transaction to an honest Suzuka Full Node.

### D3: Induced Proposer Races for Fair Provenance
**User Journey**: Suzuka Proposers are subject to a potentially race on each transaction whereby if each 

**Justification**: This will disincentivize validators from producing unfair blocks.

**Recommendations**:
- This involves two primary innovations (1) making the transaction dataflow amenable to duplicate transactions and (2) providing reward or penalization controls applicable to the Proposer function similar to those referenced in [MD-6](../md-6/README.md).
- A simple protocol could provide a provocative start:
    1. The Client submits a signed transaction to a Suzuka Full Node.
    2. The Suzuka Full Node signs this transaction and sends it back as confirmation to the Client.
    3. The Client MAY optionally have submitted the same transaction to another Suzuka Full Node.
    4. The DA records where the transaction was included and by which Proposer. The first propose to have submitted wins the race. Subsequent duplicates are ignored.
    5. The state computed by the transactions in a block is eventually settled along with a set of signers who won their respective races.
    6. The settlement contract rewards the winning Proposer. 


## Errata
<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the desiderata in which the error was identified.

  TODO: Maintain this comment.
-->
