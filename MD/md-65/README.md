# MD-65: FFS: Fastconfirmations
- **Description**: Fast-Finality Settlement : Fastconfirmations as confirmations on the L2.
- **Authors**: [Andreas Penzkofer]()

## Overview

This MD requires fastconfirmations on L2 in addition to postconfirmations. Fastconfirmations are a way to settle transactions on the L2 with fast confirmation times. This is achieved by using the L2 as a settlement layer.

See also [MIP-34: Fast Finality Settlement](https://github.com/movementlabsxyz/MIP/pull/34).

## Desiderata

### D1: Efficient Fastconfirmation Certificate Generation

**User Journey**: The system quickly generates an availability certificate upon receiving enough votes from Validators off-L1.

**Justification**: A fast confirmation process enables timely communication of guarantees and improves user experience.

### D2: Decentralization of the approach

**User Journey**: The system is designed to be decentralized.

**Justification**: Decentralization is a core principle of blockchain technology, ensuring security and resilience.

### D3: Storage of the certificates to the DA layer

**User Journey**: Validators provide confirmation guarantees to the Data Availability (DA) layer within seconds.

**Justification**: Quick confirmation enhances user confidence and enables real-time transaction validation.

### D4: Synching of the L2 with the L1

**User Journey**: The L2 is in sync with the L1. Validators should not be able to provide fastconfirmations on the L2 for different blocks than the postconfirmations on the L1.

**Justification**: There should be a way to ensure eventual consistency between the L1 and the L2. This may require slashing validators that provide fastconfirmations on the L2 for different blocks than the postconfirmations on the L1.

## Errata
