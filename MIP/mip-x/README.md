# MIP-XX: Move Stack

- **Description**: This document defines the Move Stack and its components such as the Movement SDK.
- **Authors**: Andreas PenZKofer
- **Desiderata**: [MD-91](../../MD/md-91/README.md)

## Abstract

The Move Stack and its components, such as Movement SDK are core foundational components for Movement technologies. The Move Stack provides a structured categorization of software components, one example of which is the Movement SDK.

## Motivation

The standardization of the Move Stack addresses key challenges in organizing, accessing, and understanding Movement Labs' technologies:

1. **Developer Experience**: Clear categorization of components accelerates development and improves accessibility.
2. **Clarity**: Defining the Stack and its components, such as the SDK reduces confusion regarding its scope and purpose.
3. **Visualization**: Providing a structured representation helps developers understand the relationships between components.

## Specification

### Taxonomy for the Move Stack

The Move Stack is organized into first-order and second-order categories:

#### First-Order Categories

1. **Movement SDK**: Tools for interacting with Movement technologies and its deployment.
1. **Move Stack Core (protocol units)**: Core components required for the operation of a Move-based Chain, as well as principle components.
1. **Move Stack Binder (protocol units)**: Components to which the Move-based chains can connect and that provide a greater environment for the chains to operate in.
1. **Services**: Modular components providing network or dApp remote APIs.
1. **Clients**: Interfaces for low-level interaction.

#### Second-Order Categories

Each first-order category is further categorized into second-order categories:

**Protocol Units**
Core modular components of the Move Stack, categorized as follows:

1. **Consensus**: Components for consensus mechanisms (e.g., HotStuff).
1. **Mempool**: Transaction memory pools (e.g., JellyRoll).
1. **Messaging**: Cross-ledger messaging solutions (e.g., Hyperlane Aptos).
1. **Proving**: Proving systems (e.g., ZK-SNARKs).
1. **Cryptography**: Cryptographic functions (e.g., hash functions).
1. **Execution**: Virtual machines and block executors (e.g., Aptos Block Executor).
1. **Data Availability**: Proofs and layers for data availability (e.g., SOV Labs DA).
1. **Settlement**: Settlement mechanisms (e.g., R0M ETH Settlement).
1. **Storage**: State storage solutions (e.g., TrailerPark).
1. **Data and Analytics**: Tools for creating blockchain data services (e.g., M1 Indexer).
1. **Modality**: Services enabling different modes (e.g., light clients).
1. **Censorship**: Components addressing transaction censorship.
1. **Software Analysis**: Tools for verification and analysis (e.g., Move Prover).
1. **Compiler**: Smart contract compilers (e.g., Move LLVM).
1. **Networking**: Networking utilities (e.g., MovePackets).
1. **Governance**: Governance mechanisms (e.g., RunningVote).

**Services**
Modular components providing network or dApp remote APIs, categorized into:

1. **L1**: Core network services (e.g., block producers).
2. **L2**: Layer 2 services (e.g., rollup validators).
3. **Provers**: Proving system services.
4. **Messaging**: Cross-ledger messaging services.
5. **Data and Analytics**: Indexing services (e.g., M1 Indexer Service).

**Clients**
Interfaces for low-level interaction, categorized into:

1. **L1**: Core network clients.
2. **L2**: Layer 2 clients.
3. **Provers**: Clients for proving systems.
4. **Messaging**: Messaging clients.
5. **Data and Analytics**: Indexer clients.
6. **Third-Party**: Bespoke clients for external integrations.

***Movement SDK***
Tools for interacting with Movement technologies:

1. **CLI**: Command-line interfaces.
2. **Network Builder SDK**: Tools for network development.
3. **dApp Builder SDK**: Tools for building dApps.
4. **Infrastructure Tooling**: Deployment and monitoring tools.
5. **Smart Contract Frameworks**: Frameworks for staking and governance.

### Movement SDK

The Movement SDK provides:

1. A unified interface for interacting with Movement technologies.
2. A curated toolkit for developers to deploy networks and dApps.

The SDK includes smaller, specialized SDKs that offer ergonomic tools for:

- Command-line operations.
- Network and dApp development.
- Infrastructure deployment and observability.

## Reference Implementation

## Verification

## Changelog

## Appendix

### A1 RFC-1

RFC-1 in [RFCs](https://github.com/movementlabsxyz/rfcs) is an initial document that outlines the components of the Move Stack and Movement SDK. It provides a detailed enumeration of components, their aliases, and purposes.

## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).
