# MD-37: FFS: Postconfirmation

- **Description**: Confirmations of superBlocks on L1. A sub-protocol of Fast Finality Settlement.
- **Authors**: Andreas Penzkofer

## Overview

This document describes the requirements for the Postconfirmation protocol, a sub-protocol of the Fast Finality Settlement (FFS) protocol. Postconfirmation is responsible for confirming superBlocks on L1.

See also the [FFS protocol](../mip-34/README.md).

## Desiderata

### D1: Robust Postconfirmation verification

**User Journey**: The L1 validation contract accurately verifies the super-majority proof for superBlocks and interacts effectively with the DA layer when necessary.

**Justification**: Ensuring the correctness of proofs at the L1 level prevents invalid states and secures the system's integrity.

### D2: Decentralized Postconfirmation

**User Journey**: The Postconfirmation protocol is decentralized, with multiple validators confirming superBlocks on L1.

**Justification**: Decentralization enhances network security and prevents single points of failure.

### D3: Secure and transparent staking mechanism

**User Journey**: Validators stake a specified cryptocurrency, with safeguards preventing early exits and ensuring long-term participation.

**Justification**: A robust staking mechanism incentivizes validator honesty and stability, enhancing network trust and security.

**Recommendations**: Clearly define staking requirements, lock-in periods, and penalties for early exit to maintain validator accountability.

### D4: Identify slashing conditions where necessary

**User Journey**: Slashing conditions are clearly defined and enforced, with penalties for malicious behavior. Only utilize slashing if it is necessary.

**Justification**: Clearly defined slashing conditions deter malicious actors and protect the network from potential attacks. Overuse of slashing can discourage participation.

## Changelog
