# MD-65: FFS: Fastconfirmations

- **Description**: Fast-Finality Settlement : Fastconfirmations as confirmations on the L2.
- **Authors**: Andreas Penzkofer

## Overview

This MD requires Fastconfirmations on L2 in addition to Postconfirmations. Fastconfirmations are a way to settle transactions on the L2 with fast confirmation times. This is achieved by using the L2 as a settlement layer.

See also [MIP-34: Fast Finality Settlement](https://github.com/movementlabsxyz/MIP/pull/34).

## Desiderata

### D1: Efficient Fastconfirmation Certificate Generation

**User Journey**: The system quickly generates an availability certificate upon receiving enough votes from Validators on L2 (off-L1).

**Justification**: A fast confirmation process enables timely communication of guarantees and improves user experience. It enhances user confidence and enables real-time transaction validation.

### D2: Decentralization of the approach

**User Journey**: The system is designed to be decentralized.

**Justification**: Decentralization is a core principle of blockchain technology, ensuring security and resilience.

### D3: Storage of the certificates to the DA layer

**User Journey**: Validators provide confirmation guarantees to the Data Availability (DA) layer within seconds.

**Justification**: Storing certificates to the DA layer ensures that the system can provide guarantees to users in real-time.

### D4: Synching of the L2 with the L1

**User Journey**: The L2 is in sync with the L1. Validators should not be able to provide Fastconfirmations on the L2 for different blocks than the Postconfirmations on the L1.

**Justification**: There should be a way to ensure eventual consistency between the L1 and the L2. This may require slashing validators that provide Fastconfirmations on the L2 for different blocks than the Postconfirmations on the L1.

### D5: Alignment of stakes between L1 and L2

**User Journey**: The stakes on the L1 and L2 are aligned to ensure correct security guarantees.

**Justification**: The security guarantees of the L2 should be aligned with the security guarantees of the L1.

### D6: Rewarding Validators

**User Journey**: Validators are rewarded for providing Fastconfirmations.

**Justification**: Validators should be incentivized to provide Fastconfirmations.

## Changelog
