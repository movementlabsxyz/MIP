# MD-34: Fast Finality Settlement
- **Description**: Fast Finality Settlement mechanism requirements.
- **Authors**: [Andreas Penzkofer]()

## Overview

## Abstract

We require a mechanism to confirm the validity of transactions on L2. This mechanism should provide fast confirmations with crypto-economic security on L2. Moreover, it should also provide confirmations that leverage the economic security from L1 (this may be slower).

<!--
  Provide a brief, high-level overview of the desiderata. This section should illuminate the unified objective of the desired elements, functionalities, or features. More granular specifications should be provided below.

  TODO: Remove this comment before finalizing.
-->

## Desiderata

### D1: Postconfirmation

**User Journey**: Validators can attest to the correctness of a sequence of L2Blocks (superBlocks) on L1.

**Description**: Postconfirmation is the process of confirming a sequence of L2Blocks on L1. Validators attest to the correctness of the L2Blocks. The postconfirmation process leverages the economic security of L1.

**Justification**: Postconfirmation is necessary to provide finality to the L2 transactions. It leverages the economic security of L1 to provide finality to the L2 transactions.

### D2: Staking Mechanism for Postconfirmation

**User Journey**: Validators can stake assets, distribute rewards, and manage slashing for misbehavior.

**Description**: A staking mechanism is required on L1 for validators to stake assets, distribute rewards, and manage slashing for misbehavior.

**Justification**: A staking mechanism is necessary to incentivize validators to act honestly.

### D3: Fastconfirmation

**User Journey**: Validators can attest to the correctness of L2Blocks on L2.

**Description**: Fastconfirmation is the process of confirming L2Blocks on L2. Validators attest to the correctness of the L2Blocks. The fastconfirmation process provides fast confirmations for the L2 transactions.

**Justification**: Fastconfirmation is necessary to provide fast confirmations for the L2 transactions. It provides fast confirmation to the L2 transactions.

### D4: Staking Mechanism for Fastconfirmation

**User Journey**: Validators can stake assets, distribute rewards, and manage slashing for misbehavior.

**Description**: A staking mechanism is required on L2 for validators to stake assets, distribute rewards, and manage slashing for misbehavior.

**Justification**: A staking mechanism is necessary to incentivize validators to act honestly.

### D5: Communication of Fastconfirmation Certificates

**User Journey**: Validators can communicate fascconfirmation certificates to users.

**Description**: Validators communicate fastconfirmation certificates to users. The fastconfirmation certificates provide proof of the correctness of the L2Blocks.

**Justification**: The users need to know that the L2Blocks are correct. 

### D6: Compare Fastconfirmations with Postconfirmation

**User Journey**: Postconfirmation and fastconfirmation must confirm the same L2Blocks.

**Description**: Postconfirmation and fastconfirmation must confirm the same L2Blocks. The superBlock confirmed by postconfirmation must contain the L2Blocks that are confirmed by fastconfirmations.

## Errata
