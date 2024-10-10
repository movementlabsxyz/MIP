# MD-26: User-facing checks
- **Description**: Automate checking user experience by submitting transactions every few minutes
- **Authors**: [Andy Golay](mailto:liam@movementlabs.xyz)


<!--
  This template is for drafting Desiderata. It ensures a structured representation of wishes, requirements, or needs related to the overarching objective mentioned in the title. After filling in the requisite fields, please delete these comments.

  Note that an MD number will be assigned by an editor. When opening a pull request to submit your MD, please use an abbreviated title in the filename, `md-draft_title_abbrev.md`.

  TODO: Remove this comment before finalizing.
-->

## Overview
We need to check that users can submit transactions. This MD outlines a simple automated solution.

## Definitions

Provide definitions that you think will empower the reader to quickly dive into the topic.

## Desiderata 26

  ### User-facing Suzuka Checks

  **User Journey**: Users get more assurance that we know when Suzuka testnet has a transaction-processing outage. 

  **Description**:

- Implement e2e tests which are already packaged as containers. See https://github.com/movementlabsxyz/movement/tree/main/networks/suzuka/suzuka-client/src/bin/e2e for the test logic and https://github.com/orgs/movementlabsxyz/packages?repo_name=movement for the containers (those with e2e in the name).

- Run these checks periodically, say once every 3 minutes, to simulate users sending transactions, and add to monitoring infrastructure, reporting based on the exit code of the e2e test binaries and not requiring any modifications to the implementation.

(See @l-monninger comments in discussion.)

**Justification**:

  It's a high priority to have testnet running and able to process transactions, or alterting us otherwise.

**Guidance and suggestions**: 

  We will need the address for this job allowlisted to use the Suzuka testnet faucet.


## Errata
<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the desiderata in which the error was identified.

  TODO: Maintain this comment.
-->
