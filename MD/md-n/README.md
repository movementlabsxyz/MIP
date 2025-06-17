# MD-\<number\>: Multi-chain ecosystem with cross-chain protocol

- **Description**: A single sentence description summarizing the items in the desiderata.
- **Authors**: [Author]()
- **Approval**: <!--Either approved (:white_check_mark:), rejected (:x:), stagnant or withdrawn by the governance body. To be inserted by governance. -->

## Overview

Below is a high-level overview of the key arguments and components for a multi-chain system with cross-chain protocol.

| Section                                       | Purpose                                                                 | Key Concepts                                                                                       |
|----------------------------------------------|-------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| A. Custom VMs                                 | Enable per-chain configuration of VM behavior without needing custom forks | Scoped execution, runtime modularity, backend choice, isolated upgrades                             |
| B. Private Chains                             | Provide execution, governance, and data isolation for specific groups or use cases | Access control, data sovereignty, fast governance, operational isolation                     |
| C. Unified Accounts Across MoveVM Chains      | Allow users to use one account/keypair across all Move-based chains       | Cross-chain identity, address reuse, simplified wallets, developer portability                      |
| D. Dedicated and Custom Sequencers            | Give each chain full control over its sequencer and how it orders transactions | Operator autonomy, governance, ordering logic, access policies                              |
| E. Micro-chains                               | Run one app per chain with isolated execution and atomic multi-chain txs  | App-specific runtimes, CAT transactions, execution isolation                                        |
| F. Native Bridges                             | Enable native cross-chain execution and asset flow without relying on bridges | Confirmation layer, atomicity, compatibility with external bridges                             |

## Desiderata

### A. Custom VMs

See also “D. Micro-chains”

**Author:** Franck

#### **Why Custom VMs?**

A multi-chain system benefits from supporting **customizable virtual machines per chain**—not in the sense of arbitrary low-level code changes, but through **configuration-driven specialization**.

#### **Motivation**

1. **Scoped Execution Logic**
    
    Applications can declare tailored behavior without needing to modify the global VM. For example:
    
    - Altering gas pricing mechanisms for microtransaction use cases.
    - Preloading app-specific modules or assets.
    - Tailored system features (e.g., access to randomness, certain opcodes).
2. **Runtime Modularity**
    
    A modular VM allows developers to assemble components: e.g., an NFT minting module, a confidential transfer extension, or off-chain oracle hooks—**without deploying to a shared global runtime**.
    
3. **Pluggable Backends**
    
    Chains can select from supported backends (e.g., MoveVM, EVM, zkVM), allowing applications to opt into ecosystems and tooling they prefer—**while still interoperating across chains**.
    
4. **Operational Predictability**
    
    Chain-specific VMs ensure that changes (e.g., upgrades, bugfixes) don’t cascade across unrelated apps. This improves upgrade safety and regression testing.
    

#### **How It Could Work**

Chains are defined with:

- A **VM backend** from a supported catalog.
- A **declarative runtime profile** (resource limits, modules, fee model).
- Optional **custom system calls or extensions**, subject to validator/runtime agreement.

Applications get just enough control—without the burden of maintaining a VM fork or consensus logic.

---

### B. Private Chains

**Author: Primata**

#### **Why Private Chains?**

Private chains offer **execution isolation, governance autonomy**, and **data control**—without needing to build an entirely new L1. They allow organizations to deploy application-specific logic in a secure, interoperable, yet **permissioned or semi-permissioned** environment.

#### **Motivation**

1. **Access Control**
    
    Define **who can submit transactions** or read state. This is crucial for:
    
    - Enterprise use cases with regulatory boundaries.
    - DAO governance with limited participation.
    - Role-based control over protocol actions (e.g., whitelisted oracles or issuers).
2. **Data Sovereignty**
    
    Private chains can operate with **selective state transparency**—e.g., exposing balances or events selectively, or encrypting on-chain data for internal use.
    
3. **Governance Independence + fast progress**
    
    Chains can **define their own upgrade and policy mechanisms** without relying on global community buy-in. This enables **fast iteration**, **versioning**, and **feature experimentation**.
    
4. **Operational Isolation**
    
    Performance issues, failures, or spam on one chain do not affect others. This makes private chains suitable for:
    
    - High-frequency applications (trading, payments)
    - Internal coordination (supply chain, organizational logic)
    - Region- or partner-specific deployments

#### **How It Could Work**

A private chain is instantiated by:

- Registering its **VM, configuration, and access rules**.
- Specifying **transaction visibility and propagation rules**.
- (Optionally) Restricting validator or prover sets to known participants.

It becomes a **first-class chain** in the network—able to interact with others—but with **fine-grained boundaries on control, data, and participants**.

### C. Unified Accounts Across MoveVM Chains

**Author: Young**

#### **Why Shared Accounts Across Chains?**

In a multi-chain system built on MoveVM, allowing users to maintain the **same account across all chains** simplifies authentication, improves UX, and enables seamless protocol composability. It eliminates the need for fragmented key management and enables applications to treat users as globally identifiable actors—even across execution environments.

---

#### **Motivation**

1. **Simplified Key Management**
    
    Users only need to manage **one keypair** to interact with multiple chains. No need to create or track per-chain wallets or addresses.
    
2. **Cross-Chain Addressability**
    
    Applications can **refer to the same user account** across chains, making it easier to build protocols like:
    
    - Cross-chain access control or governance
    - Multi-chain airdrops or credential systems
    - Delegation or staking flows that span multiple domains
3. **Developer and Wallet Reuse**
    
    Wallets, tooling, and signing logic built for one Move-based chain can **work everywhere** in the system, without modification. This encourages composability and lowers the barrier to multi-chain development.
    

---

#### **How It Could Work**

- Each chain adopts the **same account structure and cryptographic scheme** as Aptos (e.g., Ed25519-based authentication keys, account addresses derived from public keys).
- The runtime logic for account creation, authentication, and capability delegation is kept consistent across MoveVM chains.
- Optional: Chains may expose an **identity module** that enables mapping metadata or roles to accounts across domains, or verifying consistency via the shared confirmation layer.

This provides a **globally portable identity layer** while maintaining local execution autonomy. Accounts feel like “wallets” in one place—but work everywhere.

### D. Dedicated and Custom Sequencers

**Author: Andreas**

#### **Why Per-Chain Sequencers?**

In this multi-chain system, **each chain comes with its own sequencer**, independently operated and configured. This allows chains to define both **who controls sequencing** and **how sequencing behaves**, aligning with application needs in terms of ownership, governance, performance, and fairness.

---

#### **Motivation**

1. **Ownership and Autonomy**
    
    Each chain can **choose its own sequencer operator**—a company, or community. This ensures full control over transaction flow, without depending on a shared global sequencer.
    
2. **Governance Flexibility**
    
    Chains may define **how sequencers are selected, rotated, or replaced**, including mechanisms for fallback, challenge, or committee-based operation.
    
3. **Application-Specific Behavior**
    
    Sequencers can implement **custom transaction ordering** strategies:
    
    - Liquidation-priority for DeFi
    - Chronological ordering for social
    - Batched oracle updates, etc.
4. **Fee and Access Logic**
    
    Chains can adopt different **fee models** (flat, dynamic, subsidized), or define **access rules** for transaction submission (e.g., allowlists, rate limits).
    
5. **Operational Diversity**
    
    Chains may differ in performance profiles, liveness guarantees, or censorship resistance based on **who runs the sequencer** and **what rules it enforces**.
    

---

#### **How It Could Work**

- Sequencers are **declared at chain launch** and governed independently.
- Each sequencer may load a **policy module** defining:
    - Transaction filtering and sorting
    - Inclusion criteria
    - Fee handling
- Chains may implement **single-operator**, **rotating**, or **committee-based** sequencing models.
- Cross-chain protocols remain compatible, ensuring **interoperability even with heterogeneous sequencers**.

This design enables a decentralized network of chains, each with **local control over sequencing**, but connected through a shared protocol and confirmation fabric.

### F. Micro-chains

**Author:** Philippe

#### Why Micro-chains?

The current blockchain ecosystem is roughly divided into two categories:

- **General blockchains** like Ethereum, Solana, and Polygon, which can be L1 or L2 but share the same chain for all applications.
- **Multichain** like Polkadot, Cosmos, or Avalanche, which allow the deployment of full blockchains connected to each other via a specific protocol. Currently, most of these sub blockchains offer a complete ecosystem with several applications.

The goal of the micro chain project is to go **one step beyond multichain** by providing a dedicated execution runtime for each application. This runtime can run any application, similar to multichain platforms, but it is designed to host only a single application. This is made possible by multi-transaction atomicity: you can execute multiple transactions across several micro chains within one main transaction, atomically.

---

#### **Why is this behavior important and a game changer?**

First, it is important to be able to run **one application per micro chain**.

Today, blockchains allow developers to build DApps using smart contracts. While the application logic is defined in the contract, the way it is executed is determined by the blockchain, and some applications require a specific execution process. By using a micro chain, you can **define your own execution layer tailored to the needs of the application.**

For example, DeFi applications may need to **liquidate a position if the price drops too low**. To do this, a liquidation transaction must be executed while the price remains low. If this transaction cannot be executed because too many transactions are filling the block, it can be delayed, and the liquidation period might be missed. By allowing the application to define priorities in the execution runtime, it can ensure that liquidation transactions are prioritized.

Running one application per execution runtime allows you to define not only the application logic with smart contracts, but also **how transactions are executed and how data is stored**. For instance, if your application needs to stream video, you could design a specific integration with a stream storage service.

---

#### **Second, the importance of multi-transaction atomicity**

The micro chain project proposes the creation of transactions that can aggregate transactions for several micro chains (CAT transactions). This behavior is essential because it allows you to send cross-application transactions **without needing to host all applications on the same chain.** With this capability, you can call other applications' smart contracts within a single transaction, even if they are executed on different micro chains.

This behavior is related to **transaction reordering before execution**. In a block, a transaction can depend on another transaction. To avoid halting block execution until the dependency is resolved, such transactions are removed and executed later (in another block) when the dependency has been cleared.

Current multichain solutions do not allow this; instead, they require complex protocols and do not support all use cases. As a result, most multichain users, end up recreating entirely new ecosystems, which leads to significant fragmentation. The same application is deployed on several chains.

---

#### **Why is it important for most blockchain applications to be able to customize their execution runtime?**

Today, the blockchain application market is dominated by DeFi, and most blockchains have evolved to meet the needs of this market. However, in the future, blockchain applications will not be limited to DeFi. They will include any application that requires security, trust, or money transfer, meaning most of today's internet applications. For **applications** related to **identification, social content, incentives, goods exchange, or sharing,** blockchain offers a better solution than current centralized sites.

To meet the diverse needs of these applications, general-purpose blockchains **cannot provide a one-size-fits-all solution.** At some point, application developers will require specific behaviors in the blockchain, but building a new blockchain from scratch is difficult.

A current example is **Helium**. Simply put, Helium is a network of **WAN** devices that provides WAN access to field workers, such as farmers. They need a blockchain that enables low-fee payments between network users and device providers. With the Helium network, you pay for the data you send, not a monthly subscription, requiring the ability to make many very small transfers.

Initially, Helium built their own blockchain, but creating a fast, low-fee, and reliable blockchain is difficult. Eventually, their blockchain became too slow and expensive, so they decided to shift to **Solana** for its performance and low fees. However, Solana does not meet all their needs. Helium chose Solana because they had no other option. They lost the ability to control and define how transactions are executed and must now adapt to Solana's evolution, even if it does not fit their requirements. For example, Solana's transaction costs can increase significantly during high load periods.

If the movement micro chain had existed, Helium would have chosen it because it offers what is difficult, fast, reliable, low-fee blockchain infrastructure while allowing projects to bring what they need: an **execution runtime customized to their application's needs.**

Many projects, such as **Akash Network** or **Gevolut**, have started their own blockchains using the **Cosmos SDK**, which allows for quickly bootstrapping a blockchain with a few validators. However, there are many limitations, such as performance constraints, **limited validator set size** (which affects decentralization), the need to **build and maintain an entire blockchain** and **execution runtime**, and **low interoperability** with other blockchains or similar applications.

The Cosmos SDK is currently the easiest way to bootstrap custom blockchain functionality, but it is very restrictive. With micro chains, you only **bootstrap** what you need: **the execution runtime**.

---

#### **The market for the Movement micro chain**

The market for the Movement micro chain consists of all those applications that require blockchain trust and currently either bootstrap a full blockchain or adapt to a general-purpose blockchain.

We can see these as the **Kubernetes for blockchain**. It's a trusted environment to execute Web3 Application.

---

#### **Multi chain needs:**

- **trusted** blockchain environment, fast with low fee like Aptos.
- **default** **general purpose** execution runtime like Move VM for generally available applications.
- out of the box execution runtime that can be **customized using a SDK** and **deployed in the trusted blockchain environment**
- Atomic multi chain transaction.
- Tx reordering before execution and after block production.

### G. Native Bridges

**Author: Andreas**

#### **Cross-Chain Transactions Without Relying on External Bridges**

In many blockchain ecosystems, **bridges** are the default solution for cross-chain interaction. They serve a vital role in connecting independent networks, especially when chains have distinct consensus, finality, or execution layers.

In this system, however, chains are part of a **shared confirmation framework**, and transactions can span multiple chains **natively**. This allows for cross-chain asset movement and message passing **without relying on external bridge infrastructure** for coordination or finality.

#### **How It Works**

- Applications submit a transaction with effects on Chain A and B.
- The transaction is finalized once **successful simulation** is confirmed of all parts in the **shared confirmation layer**, which acts as a source of truth for all participating chains.
- Each chain **executes its local portion** of the transaction once confirmed, ensuring **atomicity and consistency**.

This built-in mechanism performs the same essential function as a bridge—but **within the system’s native protocol**, with no need for wrappers, relayers, or trust-minimized bridge contracts.

#### **Bridge-Compatible by Default**

This architecture doesn't aim to replace or exclude bridges. In fact, **external bridges remain essential** for:

- Interoperating with other ecosystems (e.g., Ethereum, Solana, Aptos)
- Supporting delayed or asynchronous workflows

Rather than positioning bridges as obsolete, this design simply **reduces the operational burden** of bridging within the ecosystem. It gives developers the choice: **use native cross-chain capabilities when possible, and fall back to bridges when appropriate.**

## Changelog
