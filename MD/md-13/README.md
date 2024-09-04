# MD-13: Suzuka DA Migrations Format
- **Description**: Data format which describes migrations of the canonical state of the DA over time.
- **Authors**: [Mikhail Zabaluev](mailto:mikhail.zabaluev@movementlabs.xyz)

## Overview

In order to allow for safe upgrades, data model changes, and DA migrations, it has been proposed
that we provide a configuration data format which describes the canonical state of the DA over time.
This would be a hardfork or coordinated approach (TODO: clarify terminology) to upgrades, in that
each node participating in the network SHOULD be deployed with an up to date copy describing
the migrations up to and above the current block height.

## Desiderata

### D1: Produce DA Blobs Accordingly To Migrations Config

  **User Journey**: Producer of DA blobs (DA light node in current architecture)
  should encode using the formats defined by migration settings for the current block height.

  **Description**: At the current height, the node should apply the corresponding DA configuration
  that is deployed on the node by the operator in a timely fashion, to format blobs for the DA layer.

  **Justification**: We may need to evolve the data format and organization of the DA blobs
  in the future. Migrations should be performed on the live chain so that
  by the designated height, all sequenced transaction data is submitted to the DA in uniform format
  to be aggregated by the consumer.

### D2: Decode DA Blobs Accordingly To Migrations Config

  **User Journey**: Consumer of DA blobs (DA light node in current architecture)
  should decode using the formats defined by migration settings for the current block height.

  **Description**: At the current height, the node should apply the corresponding DA configuration
  that is deployed on the node by the operator in a timely fashion, to read blobs from the DA layer.

  **Justification**: We may need to evolve the data format and organization of the DA blobs
  in the future. Migrations should be performed on the live chain so that
  by the designated height, all sequenced transaction data that has been submitted by compliant
  nodes is available on the DA in uniform format.

## Errata
<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the desiderata in which the error was identified.

  TODO: Maintain this comment.
-->