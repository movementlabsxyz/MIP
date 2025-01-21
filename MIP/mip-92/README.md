# MIP-92: Move Stack

- **Description**: This document defines the Move Stack and its components such as the Movement SDK.
- **Authors**: Andreas Penzkofer
- **Desiderata**: [MD-91](../../MD/md-91/README.md)

## Abstract

The Move Stack and its components, such as Movement SDK, are core foundational components for Movement technologies. The Move Stack provides a structured categorization of software components, one example of which is the Movement SDK.

## Motivation

The standardization of the Move Stack addresses key challenges in organizing, accessing, and understanding Movement Labs' technologies:

1. **Developer Experience**: Clear categorization of components accelerates development and improves accessibility.
2. **Clarity**: Defining the Stack and its components, such as the SDK, reduces confusion regarding its scope and purpose.
3. **Visualization**: Providing a structured representation helps developers understand the relationships between components.

## Specification

The Move Stack is organized into first-order and second-order categories:

### First-Order Categories

1. **Movement SDK**: Tools for interacting with Movement technologies and its deployment. For more see [Movement SDK](#movement-sdk).
1. **Move Stack Core (protocol units)**: Core components required for the operation of a Move-based Chain, as well as principal components.
1. **Move Stack Binder (protocol units)**: Components to which the Move-based chains can connect and that provide a greater environment for the chains to operate in. Such as cross-chain communication, FFS Validators, and decentralized shared sequencing:
1. **Services**: Modular components providing network or dApp remote APIs.
1. **Clients**: Interfaces for low-level interaction and components providing network or dApp remote APIs.

### Second-Order Categories

Each first-order category is further categorized into second-order categories:

**Movement SDK**

1. **CLI**: Command-line interfaces.
1. **Network Builder SDK**: Tools for network development.
1. **dApp Builder SDK**: Tools for building dApps.
1. **Infrastructure Tooling**: Deployment and monitoring tools.
1. **Smart Contract Frameworks**: Frameworks for staking and governance.
1. **Software Analysis**: Tools for formal verification and analysis (e.g., Move Prover).

**Move Stack Core (protocol units)**

1. **Cryptography**: Cryptographic functions (e.g., hash functions, encryption).
1. **Proving**: Proving systems (e.g., ZK-SNARKs).
1. **Governance**: Mechanisms for network governance (e.g., RunningVote).
1. **Ledger**: Tools for ledger operations, state transitions, and state management.
1. **Storage**: State storage solutions (e.g., TrailerPark).
1. **Settlement**: Settlement mechanisms (e.g., R0M ETH Settlement).
1. **Compiler**: Smart contract compilers for the Move language (e.g., Move LLVM).
1. **Execution**: Virtual machines and block executors (e.g., Aptos Block Executor).

**Move Stack Binder (protocol units)**

1. **Consensus**: Components for consensus mechanisms (e.g., HotStuff).
1. **Mempool**: Transaction memory pools (e.g., JellyRoll).
1. **Data Availability (DA)**: Proofs and layers for data availability (e.g., SOV Labs DA).
1. **Networking**: Networking utilities (e.g., MovePackets).
1. **Shared Sequencers**: Components enabling decentralized sequencing of transactions.
1. **Censorship**: Components addressing transaction censorship.

**Services**

1. **L1**: Core network services (e.g., block producers).
1. **L2**: Layer 2 services (e.g., rollup validators).
1. **Provers**: Proving system services.
1. **Messaging**: Cross-ledger messaging services (e.g., Hyperlane Aptos).
1. **Data and Analytics**: Indexing services (e.g., M1 Indexer Service).
1. **Modality**: Services enabling different modes (e.g., light clients).

**Clients**

1. **L1**: Core network clients.
2. **L2**: Layer 2 clients.
3. **Provers**: Clients for proving systems.
4. **Messaging**: Messaging clients.
5. **Data and Analytics**: Indexer clients.
6. **Third-Party**: Bespoke clients for external integrations.

### Movement SDK

The Movement SDK provides:

1. A unified interface for interacting with Movement technologies.
2. A curated toolkit for developers to deploy networks and dApps.

The SDK includes smaller, specialized SDKs that offer ergonomic tools for:

- Command-line operations.
- Network and dApp development.
- Infrastructure deployment and observability.

### Visualization

More compact view of the specification in this document.

```mermaid
flowchart TD
  direction TB

  linkStyle default stroke:white,stroke-width:0;

  Movement_SDK["Movement SDK"]
  Move_Stack_Core["Move Stack Core (protocol units)"]
  Move_Stack_Binder["Move Stack Binder (protocol units)"]
  Services["Services"]
  Clients["Clients"]

  Movement_SDK --> Move_Stack_Core
  Move_Stack_Core --> Move_Stack_Binder
  Move_Stack_Binder --> Services
  Services --> Clients

  subgraph Movement_SDK["Movement SDK"]
    direction TB
    CLI["CLI"]
    Network_Builder_SDK["Network Builder SDK"]
    dApp_Builder_SDK["dApp Builder SDK"]
    Infrastructure_Tooling["Infrastructure Tooling"]
    Smart_Contract_Frameworks["Smart Contract Frameworks"]
    Software_Analysis["Software Analysis"]
  end

  subgraph Move_Stack_Core["Move Stack Core (protocol units)"]
    direction TB
    Cryptography["Cryptography"]
    Proving["Proving"]
    Governance["Governance"]
    Ledger["Ledger"]
    Storage["Storage"]
    Settlement["Settlement"]
    Compiler["Compiler"]
    Execution["Execution"]
  end

  subgraph Move_Stack_Binder["Move Stack Binder (protocol units)"]
    direction TB
    Consensus["Consensus"]
    Mempool["Mempool"]
    Data_Availability["Data Availability (DA)"]
    Networking["Networking"]
    Shared_Sequencers["Shared Sequencers"]
    Censorship["Censorship"]
  end

  subgraph Services["Services"]
    direction TB
    L1["L1"]
    L2["L2"]
    Provers["Provers"]
    Messaging["Messaging"]
    Data_Analytics_Services["Data and Analytics"]
    Modality["Modality"]
  end

  subgraph Clients["Clients"]
    direction TB
    L1_Clients["L1"]
    L2_Clients["L2"]
    Provers_Clients["Provers"]
    Messaging_Clients["Messaging"]
    Data_Analytics_Clients["Data and Analytics"]
    Third_Party["Third-Party"]
  end
```


## Reference Implementation

## Verification

## Changelog

## Appendix

### A1 RFC-1

RFC-1 in [RFCs](https://github.com/movementlabsxyz/rfcs) is an initial document that outlines the components of the Move Stack and Movement SDK. It provides a detailed enumeration of components, their aliases, and purposes.

## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).
