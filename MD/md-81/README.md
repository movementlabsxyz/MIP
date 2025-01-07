# MD-81: Movement Mainnet Feature Flags

- **Description**: Define and manage feature flags for the Movement mainnet to optimize the network's launch with community-driven and developer-focused features.
- **Authors**: [Primata](mailto:primata@movementlabs.xyz)
- **Reviewer**: 

## Overview

To ensure the Movement mainnet launches with a robust feature set that meets the expectations of the community and developers, we propose introducing a feature flag system. This system will allow Movement Labs to toggle specific features, many of which are familiar to users from the testnet or analogous to features in Aptos. This document establishes the framework for defining, managing, and evolving these feature flags.

## Desiderata

### D1: Enable Fungible Asset as Gas Token

**User Journey**: MOVE coin can be used as both a fungible asset and the native gas token for transactions on the Movement mainnet.

**Justification**: This feature aligns with the community’s preference and facilitates interoperability and ease of use. This way we also do not need to go through the migration process. Aptos Mainnet has already gone through governance process to enable this feature with [AIP-70](https://governance.aptosfoundation.org/proposal/107), [AIP-85](https://github.com/aptos-foundation/AIPs/blob/main/aips/aip-85.md) and merged [gas charging](https://github.com/aptos-labs/aptos-core/pull/13194).

**Recommendations**:

- Implement MOVE as a [Fungible Asset](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/fungible_asset.move).
- Configure MOVE to serve as the native gas token to streamline user interactions.
- Features 61, 64,65 and 68 should be toggled true.

### D2: Remove Token Authorization Requirement

**User Journey**: Users can send tokens to any account without requiring prior authorization.

**Justification**: Simplifying token transfers encourages user adoption and aligns with community feedback.

**Recommendations**:

- Ensure tokens can be sent to accounts by default, without requiring explicit authorization.
- Implement this as a default setting for all accounts upon creation.

### D3: Turn on Binary Format V7

**User Journey**: Users can use the latest Binary Format used in Aptos.

**Justification**: Compatibility with Aptos deployments.

**Recommendations**:

- Feature 40 should be toggled true.

## Feature Flags

Below is the table of features for Aptos mainnet, testnet, devnet, and their comparison with Movement.

| Feature\_ID | Feature\_Name                                           | Mainnet\_Status | Testnet\_Status | Devnet\_Status | Movement\_Status | Consider\_Toggling |
| ----------- | ------------------------------------------------------- | --------------- | --------------- | -------------- | ---------------- | ---------------- |
| 1           | CODE\_DEPENDENCY\_CHECK                                 | True            | True            | True           | True             | False            |
| 2           | TREAT\_FRIEND\_AS\_PRIVATE                              | True            | True            | True           | True             | False            |
| 3           | SHA\_512\_AND\_RIPEMD\_160\_NATIVES                     | True            | True            | True           | True             | False            |
| 4           | APTOS\_STD\_CHAIN\_ID\_NATIVES                          | False           | False           | True           | True             | False            |
| 5           | VM\_BINARY\_FORMAT\_V6                                  | True            | True            | True           | True             | False            |
| 6           | COLLECT\_AND\_DISTRIBUTE\_GAS\_FEES                     | False           | False           | False          | False            | False            |
| 7           | MULTI\_ED25519\_PK\_VALIDATE\_V2\_NATIVES               | True            | True            | True           | True             | False            |
| 8           | BLAKE2B\_256\_NATIVE                                    | True            | True            | True           | True             | False            |
| 9           | RESOURCE\_GROUPS                                        | True            | True            | True           | True             | False            |
| 10          | MULTISIG\_ACCOUNTS                                      | True            | True            | True           | True             | False            |
| 11          | DELEGATION\_POOLS                                       | True            | True            | True           | True             | False            |
| 12          | CRYPTOGRAPHY\_ALGEBRA\_NATIVES                          | True            | True            | True           | True             | False            |
| 13          | BLS12\_381\_STRUCTURES                                  | True            | True            | True           | True             | False            |
| 14          | ED25519\_PUBKEY\_VALIDATE\_RETURN\_FALSE\_WRONG\_LENGTH | True            | True            | True           | True             | False            |
| 15          | STRUCT\_CONSTRUCTORS                                    | True            | True            | True           | True             | False            |
| 16          | PERIODICAL\_REWARD\_RATE\_DECREASE                      | True            | True            | False          | False            | False            |
| 17          | PARTIAL\_GOVERNANCE\_VOTING                             | True            | True            | False          | False            | False            |
| 20          | CHARGE\_INVARIANT\_VIOLATION                            | True            | True            | True           | True             | False            |
| 21          | DELEGATION\_POOL\_PARTIAL\_GOVERNANCE\_VOTING           | True            | True            | False          | False            | False            |
| 22          | FEE\_PAYER\_ENABLED                                     | True            | True            | True           | True             | False            |
| 23          | APTOS\_UNIQUE\_IDENTIFIERS                              | True            | True            | True           | True             | False            |
| 24          | BULLETPROOFS\_NATIVES                                   | True            | True            | True           | True             | False            |
| 25          | SIGNER\_NATIVE\_FORMAT\_FIX                             | True            | True            | True           | True             | False            |
| 26          | MODULE\_EVENT                                           | True            | True            | True           | True             | False            |
| 29          | SIGNATURE\_CHECKER\_V2\_SCRIPT\_FIX                     | True            | True            | True           | True             | False            |
| 31          | SAFER\_RESOURCE\_GROUPS                                 | True            | True            | True           | True             | False            |
| 32          | SAFER\_METADATA                                         | True            | True            | True           | True             | False            |
| 33          | SINGLE\_SENDER\_AUTHENTICATOR                           | True            | True            | True           | True             | False            |
| 34          | SPONSORED\_AUTOMATIC\_ACCOUNT\_CREATION                 | True            | True            | True           | True             | False            |
| 35          | FEE\_PAYER\_ACCOUNT\_OPTIONAL                           | True            | True            | True           | True             | False            |
| 38          | LIMIT\_MAX\_IDENTIFIER\_LENGTH                          | True            | True            | True           | True             | False            |
| 39          | OPERATOR\_BENEFICIARY\_CHANGE                           | True            | True            | True           | True             | False            |
| 40          | VM\_BINARY\_FORMAT\_V7                                  | True            | True            | True           | False            | True             |
| 41          | RESOURCE\_GROUPS\_SPLIT\_IN\_VM\_CHANGE\_SET            | True            | True            | True           | True             | False            |
| 42          | COMMISSION\_CHANGE\_DELEGATION\_POOL                    | True            | True            | True           | True             | False            |
| 43          | BN254\_STRUCTURES                                       | True            | True            | True           | True             | False            |
| 45          | RECONFIGURE\_WITH\_DKG                                  | False           | False           | False          | False            | False            |
| 46          | KEYLESS\_ACCOUNTS                                       | True            | True            | True           | True             | False            |
| 47          | KEYLESS\_BUT\_ZKLESS\_ACCOUNTS                          | False           | False           | True           | True             | False            |
| 49          | JWK\_CONSENSUS                                          | True            | True            | True           | True             | False            |
| 50          | CONCURRENT\_FUNGIBLE\_ASSETS                            | True            | True            | True           | True             | False            |
| 52          | OBJECT\_CODE\_DEPLOYMENT                                | True            | True            | True           | True             | False            |
| 53          | MAX\_OBJECT\_NESTING\_CHECK                             | True            | True            | True           | True             | False            |
| 54          | KEYLESS\_ACCOUNTS\_WITH\_PASSKEYS                       | False           | False           | True           | True             | False            |
| 55          | MULTISIG\_V2\_ENHANCEMENT                               | True            | True            | True           | True             | False            |
| 56          | DELEGATION\_POOL\_ALLOWLISTING                          | True            | True            | True           | True             | False            |
| 57          | MODULE\_EVENT\_MIGRATION                                | False           | False           | True           | True             | False            |
| 59          | TRANSACTION\_CONTEXT\_EXTENSION                         | True            | True            | True           | True             | False            |
| 60          | COIN\_TO\_FUNGIBLE\_ASSET\_MIGRATION                    | True            | True            | True           | True             | False            |
| 61          | PRIMARY\_APT\_FUNGIBLE\_STORE\_AT\_USER\_ADDRESS        | False           | False           | False          | False            | True             |
| 62          | OBJECT\_NATIVE\_DERIVED\_ADDRESS                        | True            | True            | True           | True             | False            |
| 63          | DISPATCHABLE\_FUNGIBLE\_ASSET                           | True            | True            | True           | True             | False            |
| 64          | NEW\_ACCOUNTS\_DEFAULT\_TO\_FA\_APT\_STORE              | False           | False           | False          | False            | True             |
| 65          | OPERATIONS\_DEFAULT\_TO\_FA\_APT\_STORE                 | False           | False           | False          | False            | True             |
| 66          | AGGREGATOR\_V2\_IS\_AT\_LEAST\_API                      | True            | True            | True           | True             | False            |
| 67          | CONCURRENT\_FUNGIBLE\_BALANCE                           | True            | True            | True           | True             | False            |
| 68          | DEFAULT\_TO\_CONCURRENT\_FUNGIBLE\_BALANCE              | False           | False           | False          | False            | True             |
| 70          | ABORT\_IF\_MULTISIG\_PAYLOAD\_MISMATCH                  | True            | True            | True           | True             | False            |
| 71          | ?                                                       | True            | True            | True           | False            | False            |
| 72          | NATIVE\_BRIDGE                                          | True            | True            | True           | False            | False            |
| 78          | TRANSACTION\_SIMULATION\_ENHANCEMENT                    | True            | True            | True           | null             | False            |
| 79          | COLLECTION\_OWNER                                       | True            | True            | True           | null             | False            |
| 80          | NATIVE\_MEMORY\_OPERATIONS                              | True            | True            | True           | null             | False            |

## Errata

**Transparency and Clarity**: Any corrections or updates to this document will be tracked and published here to ensure accuracy.

**Accountability**: Updates will include a reference to the date and version in which the error was identified and corrected.