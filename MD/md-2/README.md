# MD-2: Enclave Crash-resistant Key Management

- **Description**: Provide a mechanism for allowing the use of keys in an enclave that can be recovered after crashes without breaking encapsulation.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)

## Overview

## Desiderata

### D1: Minimize Direct Access to Bridge Keys while Maintaining Use

**User Journey**: Movement Labs Atomic Bridge Service Operators (MLABSO) can run the service with appropriate signing keys without direct access to said keys.

**Justification**: Without direct access to the keys, MLABSO are forced to use a more secure mechanism for signing messages which can be more easily secured audited such as an HSM or enclave.

### D2: Only Allow Attested Usage of Bridge Keys

**User Journey**: Only attested software can use bridge keys.

**Justification**: Even without direct access to the keys, MLABSO could still abuse bridge keys by abusing their access to the secure signing mechanism. Enforcing attestation of software using the keys can help mitigate this risk.

### D3: Time-Lock Key Usage

**User Journey**: MLABSO can only reliably replace software using a key in a time-locked manner.

**Justification**: The software using a given key may require updates or replacement. Time-locking can allow this to occur without diminishing the benefits of attestations.

## Changelog