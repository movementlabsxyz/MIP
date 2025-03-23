# MD-n: Probabilistic distributed and decentralized compute and memory

- **Description**: Requests informal and formal descriptions of probabilistic distributed and decentralized compute and memory systems. 
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz), [Jake Hillard](mailto:jhillard@stanford.edu)
- **Approval**: :red-x:

## Overview

We provide this MD to motivate proposals for probabilistic distribute compute and memory systems and as a common reference for the core abstractions which define distributed and decentralized technologies. 

To date, the most popular lineage of distributed computing systems contending with [The Byzantine Generals Problem](https://lamport.azurewebsites.net/pubs/byz.pdf) has been [PBFT](https://pmg.csail.mit.edu/papers/osdi99.pdf). PBFT provides a practical solution to the problem of achieving consensus in a distributed system where nodes may fail or act maliciously. However, PBFT systems generally rely on a replica model of decentralized compute which generally requires a supermajority of nodes in a shard to run the exact same state transitions. This model is elaborated upon in [Appendix A1](#a1-the-replica-model-of-decentralized-computing).

We identify two fundamental inefficiencies inherent to the replica model of decentralized compute:

1. **Redundant computation**: In the replica model, each replica in a shard must compute the entirety of a given task, ultimately resulting in at best the user having access to $\frac{1}{n}$ of the total compute power of the shard where $n$ is the number of replicas in the shard.
2. **Round-trip messaging**: The replica model also requires round-trip messaging with at least a `PREPARE` and `COMMIT` phase for each atomic state transition. This results in a minimum of two round-trip messages per state transition, which can be a significant bottleneck in high-throughput systems. Asserting time as a resource, this means the user can only utilize at best $\frac{p}{p + 2r}$ of the total compute time in the shard to complete a given task where $p$ is the time spent computing and $r$ is the time spent in round-trip messaging.

We seek proposals for the distributed and decentralized systems which challenge these inherent inefficiencies.

## Definitions

## Desiderata

### D1.1: Provide a definition of consistency

**User journey**: Researchers can understand what kind of consistency is achieved by honest participants in your distributed compute system over compute

**Justification**: We maintain that all distributed and decentralized systems consider some kind of consistency of state over participants.

**Recommendations**: 

1. We recommend that you review the [CAP theorem](https://en.wikipedia.org/wiki/CAP_theorem), [FLP impossibility](https://groups.csail.mit.edu/tds/papers/Lynch/jacm85.pdf), and [Paxos](https://lamport.azurewebsites.net/pubs/paxos-simple.pdf) to understand common tradeoffs in distributed systems and starting points for notions of consistency.
2. Consider established types of consistency such as eventual consistency, strong consistency, causal consistency, etc. and reference their similarities to your definition.

### D1.2: Describe the consistency properties of your system
**User journey**: Researchers can understand the specific consistency properties of your distributed compute system.

**Justification**: We maintain that all distributed and decentralized systems consider some kind of consistency of state over participants. It is important to understand the specific properties of consistency in your system.

### D2.1 Provide a definition of an atomic state transition (transaction) or reject the notion thereof
**User journey**: Researchers can understand what constitutes an atomic state transition in your distributed compute system.

**Justification**: We maintain that distributed systems of interest are--from the perspective of the user--a series of atomic state transitions which can be programmed. That is, distributed systems expose a machine, but one which is still essentially a state machine.

**Recommendations**:
1. Consider [total order block](https://arxiv.org/abs/2203.06871) and [partial order models](https://docs.sui.io/paper/sui-lutris.pdf) of atomic state transitions.

### D2.2 Describe the atomic state transition properties of your system
**User journey**: Researchers can understand the specific atomic state transition properties of your distributed compute system.

**Justification**: We maintain that distributed systems of interest are--from the perspective of the user--a series of atomic state transitions which can be programmed. It is important to understand the specific properties of atomic state transitions in your system.

### D3.1: Provide a definition of state transition scheduling
**User journey**: Researchers can understand how state transitions are scheduled in your distributed compute system.

**Justification**: We maintain that the primary function of a distributed system is to schedule state transitions such that they (a) use minimal resources and (b) maintain the consistency guarantees you provide. In current decentralized and distributed systems, scheduling often takes the form of executing proposed blocks of transactions in a specific order.

### D3.2: Describe the state transition scheduling properties of your system
**User journey**: Researchers can understand the specific state transition scheduling properties of your distributed compute system.

**Justification**: We maintain that the primary function of a distributed system is to schedule state transitions such that they (a) use minimal resources and (b) maintain the consistency guarantees you provide. It is important to understand the specific properties of state transition scheduling in your system.

### D4.1: Provide a definition of order
**User journey**: Researchers can understand what you mean by order in your distributed compute system.

**Justification**: We maintain that order is a fundamental property of state transitions in distributed systems. Order refers to the sequence in which state transitions are applied, which can impact the final state of the system.

### D4.2: Describe the effect order has your distributed compute system
**User journey**: Researchers can understand how order affects the consistency and scheduling of state transitions in your distributed compute system.

**Justification**: For all operations which are not both commutative and associative, the order of operations matters. Further, we maintain even a set of commutative and associative operations must be rendered finite to actually "know" a value at a given point in time. The role of most consensus mechanisms is to provide a total order of state transitions, but there are alternatives.

### D5.1: Provide a definition of state transition atomicity
**User journey**: Researchers can understand how state transition atomicity is achieved in your distributed compute system.

**Justification**: We maintain that atomicity is a fundamental property of state transitions in distributed systems. Atomicity ensures that a state transition is treated as a single, indivisible operation, which either completes fully or has no effect at all. However, it is conceivable that atomicity might not be realized until a later point in time, e.g. in the case of eventual consistency.

### D5.2: Describe the state transition atomicity properties of your system
**User journey**: Researchers can understand the specific state transition atomicity properties of your distributed compute system.

**Justification**: We maintain that atomicity is a fundamental property of state transitions in distributed systems. It is important to understand the specific properties of state transition atomicity in your system.

### D6.1: Provide a definition of state transition finality
**User journey**: Researchers can understand how state transition finality is achieved in your distributed compute system.

**Justification**: We maintain that finality is a fundamental property of state transitions in distributed systems. Finality ensures that once a state transition is finalized, it cannot be reversed or altered. This is crucial for client usage of the system.

### D6.2: Describe the state transition finality properties of your system
**User journey**: Researchers can understand the specific state transition finality properties of your distributed compute system.

**Justification**: We maintain that finality is a fundamental property of state transitions in distributed systems. It is important to understand the specific properties of state transition finality in your system.

### D7.1: Provide a definition of state
**User journey**: Researchers can understand how state is defined and managed in your distributed compute system.

**Justification**: Commonly, state refers to the symbols on a tape in a Turing machine. In more exotic models of computation, it may be more difficult to map a notion of state to this model. 

### D7.2: Describe the state properties of your system
**User journey**: Researchers can understand the specific state properties of your distributed compute system.

**Justification**: Commonly, state refers to the symbols on a tape in a Turing machine. In more exotic models of computation, it may be more difficult to map a notion of state to this model. It is important to understand the specific properties of state in your system.

### D8.1: Describe the relationship between state and memory in your system
**User journey**: Researchers can understand how state and memory are related in your distributed compute system.

**Justification**: Commonly, memory refers to the storage of information in a system. It is often simplest to just think of this as some representation of the the symbols on a tape in a Turing machine. However, more exotic models of computation may have more complicated relationships between state and memory.

**Recommendations**:
1. Consider how a [Merkle tree](https://www.ralphmerkle.com/papers/Thesis1979.pdf) can be thought of as a memory structure where symbols on tape are in fact abstractly represented throughout the structure of the tree when the state machine is required to verify the memory of the system.

### D8.2: Describe the state and memory properties of your system
**User journey**: Researchers can understand the specific state and memory properties of your distributed compute system.

**Justification**: Commonly, memory refers to the storage of information in a system. It is often simplest to just think of this as some representation of the the symbols on a tape in a Turing machine. However, more exotic models of computation may have more complicated relationships between state and memory. It is important to understand the specific properties of state and memory in your system.

### D9.1: Provide a definition of safety
**User journey**: Researchers can understand how safety is achieved in your distributed compute system.

**Justification**: Commonly, safety refer to the ability of a distributed system to compute the intended effects. 

### D9.2: Describe the safety properties of your system
**User journey**: Researchers can understand the specific safety properties of your distributed compute system.

**Justification**: Commonly, safety refer to the ability of a distributed system to compute the intended effects. It is important to understand the specific properties of safety in your system.

### D10.1: Provide a definition of liveness
**User journey**: Researchers can understand how liveness is achieved in your distributed compute system.

**Justification**: Commonly, liveness refers to the ability of a distributed system to continue making progress and not become stagnant or deadlocked.

**Recommendations**:
1. Review [The Byzantine Generals Problem](https://lamport.azurewebsites.net/pubs/byz.pdf), [PBFT](https://pmg.csail.mit.edu/papers/osdi99.pdf), [CAP theorem](https://en.wikipedia.org/wiki/CAP_theorem), and [FLP impossibility](https://groups.csail.mit.edu/tds/papers/Lynch/jacm85.pdf) for a foundational understanding of liveness.
2. Review [Casper the Friendly Finality Gadget](https://arxiv.org/abs/1710.09437) for a practical example of reasoning about liveness in a distributed system.

### D10.2: Describe the liveness properties of your system
**User journey**: Researchers can understand the specific liveness properties of your distributed compute system.

**Justification**: Commonly, liveness refers to the ability of a distributed system to continue making progress and not become stagnant or deadlocked. It is important to understand the specific properties of liveness in your system.

### D11.1: Provide a definition of incentive
**User journey**: Researchers can understand how incentives are structured in your distributed compute system.

**Justification**: Incentives are often a crucial component of distributed systems, particularly in decentralized systems where participants may be motivated by economic factors.

### D11.2: Describe the incentive properties of your system
**User journey**: Researchers can understand the specific incentive properties of your distributed compute system.

**Justification**: Incentives are often a crucial component of distributed systems, particularly in decentralized systems where participants may be motivated by economic factors. It is important to understand the specific properties of incentives in your system. We need to know why we should expect participants to behave honestly and contribute to the system's operation.

### D12.1: Provide a definition of a shard 
**User journey**: Researchers can understand what you mean by a shard in your distributed compute system.

**Justification**: Because of physical communication constraints, simply propagating information throughout the globe greatly restricts throughput. Shards are a common solution to this problem, where a subset of nodes is responsible for processing a subset of transactions and can communicate more efficiently.

### D12.2: Describe the shard properties of your system
**User journey**: Researchers can understand the specific shard properties of your distributed compute system.

**Justification**: Because of physical communication constraints, simply propagating information throughout the globe greatly restricts throughput. Shards are a common solution to this problem, where a subset of nodes is responsible for processing a subset of transactions and can communicate more efficiently. It is important to understand the specific properties of shards in your system.

### D13.1: Provide a definition of a resource
**User journey**: Researchers can understand what you mean by a resource in your distributed compute system.

**Justification**: Commonly, resources are fundamental state objects in any system with concurrent write and read access. Distributed systems often modify state in a way that requires careful management of resources to ensure consistency and avoid conflicts.

**Recommendations**:
1. Consider the differences in how resource acquisition is treated under [Aptos Block STM](https://arxiv.org/abs/2203.06871) (optimistic discovery over a set of transactions) and the [Sui object runtime](https://docs.sui.io/paper/sui-lutris.pdf) (a priori acknowledgement of resources).

### D13.2: Describe the resource properties of your system
**User journey**: Researchers can understand the specific resource properties of your distributed compute system.

**Justification**: Commonly, resources are fundamental state objects in any system with concurrent write and read access. Distributed systems often modify state in a way that requires careful management of resources to ensure consistency and avoid conflicts. It is important to understand the specific properties of resources in your system.

### D14.1: Provide a definition of synchronization
**User journey**: Researchers can understand how synchronization is achieved in your distributed compute system.

**Justification**: Synchronization is often a crucial component of distributed systems, particularly in ensuring that state transitions are applied in the correct order and that resources are managed effectively. 

### D14.2: Describe the synchronization properties of your system
**User journey**: Researchers can understand the specific synchronization properties of your distributed compute system.

**Justification**: Synchronization is often a crucial component of distributed systems, particularly in ensuring that state transitions are applied in the correct order and that resources are managed effectively. It is important to understand the specific properties of synchronization in your system. How does a programmer safely work with a resource in your system?

### D15.1: Provide a definition for loss
**User journey**: Researchers can understand what you mean by loss in your distributed compute system.

**Justification**: In distributed systems, loss can refer to the failure of nodes, messages, or state transitions. In cryptoeconomic systems, this can, for example, refer to the astronomical probabilities that an invalid signature would be verified or the expectation that honest participation is $E[H]$ under incentivization. 

### D15.2: Describe the loss properties of your system
**User journey**: Researchers can understand the specific loss properties of your distributed compute system.

**Justification**: In distributed systems, loss can refer to the failure of nodes, messages, or state transitions. In cryptoeconomic systems, this can, for example, refer to the astronomical probabilities that an invalid signature would be verified or the expectation that honest participation is $E[H]$ under incentivization. It is important to understand the specific properties of loss in your system.

### D16: Provide an informal description of your system encapsulating desiderata D1 through D15
**User journey**: Both Experts and Novices can understand the core properties of your distributed compute system.

**Justification**: A concise summary of the core properties of your system will help both experts and novices understand the fundamental aspects of your distributed compute system.

**Recommendations**:
1. Review [Appendix A2](#a2-a-sketch-of-an-exotic-distributed-system) for an example of how to succinctly and informally describe your system.

## Appendix

### A1: The Replica Model of Decentralized Computing

### A2: A Sketch of an Exotic Distributed System

**Abstract**:
We propose the Anwansi Machine as an exotic distributed and decentralized compute system. The term "anwansi" is the Igbo word for "magic." This is a "magic machine" because its description is intended as an example and many components are left as "magic boxes."

**Description**:
The Anwansi Machine takes a state transition $s_1 \in S$ splits it into a smaller number of "magic" tasks $\{\zeta_{s_1,1}, \zeta_{s_1,2}, \ldots, \zeta_{s_1,n}\} \in \Zeta$ and distributes subsets of them to a subset of nodes $N_{\zeta_{s_j,k}}$. 

Each of the nodes $N_{\zeta_{s_j,k}}$ executes the task $\zeta_{s_j,k}$ with some "unique isomorphic noise" $\iota(N_{\zeta_{s_j,k}})$ and returns the result to a "magic" aggregator node $N_{agg}$ which combines the results into a final state transition $s_1^{\prime} \in S^{\prime}$.

Each transition task $\zeta_{s_j,k} \star \iota(N_{\zeta_{s_j,k}}) \rightarrow \zeta^{\prime}_{s_j,k}$ is commutative with each other and associative with each other, but the final state transition $s_1^{\prime}$ can only be computed via the set of all $\zeta^{\prime}_{s_j,k}$.

Each transition task $\zeta_{s_j,k} \star \iota(N_{\zeta_{s_j,k}}) \rightarrow \zeta^{\prime}_{s_j,k}$ is incorrect with probability $\epsilon$. When given isomorphic noise the probability that $l$ agreeing nodes $N_{\zeta_{s_j,k}}$ return the correct result is $1 - \epsilon^l$.

The Awansi Machine protocol can be generalized to consider applying sets of user state transitions $S$ to a set of nodes $N$ with some unique isomorphic noise $\iota(N)$ and returning a final state transition $S^{\prime}$.

The aggregator node $N_{agg}$ can be any node in the network or merely an abstraction realized when sampling the set of nodes $N$.

**Properties**:

- **Consistency**: The Anwansi Machine can be run in a traditional PBFT architecture with the key difference that not every node must run every computing task. All Awansi Replicas are consistent once a state transition is finalized.
- **Atomic State Transition**: The Anwansi Machine executes a set of atomic state transitions $S$ which can be any Turing machine state transition.
- **State Transition Scheduling**: The Anwansi Machine schedules state transitions by distributing tasks to nodes and aggregating the results.
- **Order**: The Anwansi Machine maintains a total order of state transitions but decomposes these stat transitions into smaller commutative and associative tasks.
- **State Transition Atomicity**: The Anwansi Machine ensures that state transitions are atomic, meaning they are indivisible and either complete fully or have no effect at the aggregator.
- **State Transition Finality**: The Anwansi Machine ensures that once a state transition is finalized, it cannot be reversed or altered.
- **State**: The Anwansi Machine maintains a traditional symbols and tape state that is updated with each finalized state transition.
- **Memory**: The Anwansi Machine maintains a memory structure that is abstractly represented throughout the structure of the tree when the state machine is required to verify the memory of the system.
- **Safety**: The Anwansi Machine ensures that the intended effects of state transitions are computed correctly.
- **Liveness**: The Anwansi Machine is agnostic to liveness considerations as it can compute the correct state transitions with one replica available for each task. If the surrounding protocol wishes to wait for a supermajority or similar, it can assign its own slot deadlines.
- **Incentive**: The Anwansi Machine does not specify any particular incentive structure, but it can be designed to include economic incentives for participants.
- **Shard**: The Anwansi Machine can be designed to operate with or without shards, depending on the specific implementation and requirements of the system.
- **Resource**: The Anwansi Machine muddles resources in its abstract decomposition of computing tasks. Resource acquisition and sychronization are no longer removed by the associative and commutative properties of the tasks.
- **Synchronization**: The Anwansi Machine ensures that state transitions are applied in the correct order and that resources are managed effectively.
- **Loss**: The Anwansi Machine can handle node failures and message loss, as the probability of correct results increases with the number of agreeing nodes.

## Changelog
