# MD-116: Dongmen (Postconfirmations) Standards

- **Description**: Provides a set of liveness and correctness requirements for Postconfirmations protocols. 
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Approval**: 
- **Etymology**: These standards were originally drafted in the Dongmen neighborhood of Taipei. 

## Overview

As identified in [MD-3](https://github.com/movementlabsxyz/MIP/tree/main/MD/md-3), [MD-4](https://github.com/movementlabsxyz/MIP/tree/main/MD/md-4), [MD-5](https://github.com/movementlabsxyz/MIP/tree/main/MD/md-5), [MIP-34](https://github.com/movementlabsxyz/MIP/pulls?page=2&q=is%3Apr+is%3Aopen), and [MIP-37](https://github.com/movementlabsxyz/MIP/pull/37), naive interpretations--such as MCR--of the Postconfirmations protocol fall short of modern BFT expectations. 

We summarize the shortcomings relevant to these standards as follows:

1. **Asynchronicity**: per [FLP](https://groups.csail.mit.edu/tds/papers/Lynch/jacm85.pdf), asynchronous voting protocols cannot achieve consensus in the presence of one or more faulty processes. Thus, Asynchronous Postconfirmations protocols, i.e., those not defining a Global Stabilization Times, are **not in fact BFT consensus protocols.** MCR, for example--if implemented with a single vote per slot and without any bound on when the slot moves to a new committee--may remain in permanent disagreement. 
2. **Liveness**: failure to come to consensus presents a liveness shortcoming. Permanent disagreement means that the network will never progress to the next accepted state. Further, we assert indefinite disagreement is unnecessary in the context of Postconfirmations. 

For more detailed information on these properties, see [BFT Synchronicity and Liveness](#a1-bft-synchronicity-and-liveness).

In response to these shortcomings, we request a protocol which is **fully-synchronous**, **fork-transferable**, **fork-perfect**, and **minority-aware**. The last three of these terms are introduced and defined in this MD. 

Because the Dongmen Postconfirmations Standards request a **fully-synchronous** protocol, we assert said protocol can no longer be traditionally-BFT. That is, non-supermajority forks may exist under these standards. For a traditional BFT standard, see the [Ximen Postconfirmations Standards]().

## Definitions

- **Fully-synchronous**: Describes a synchronous model. A network and protocol assumption in which message transmission and processing are guaranteed to complete within known, fixed bounds. Messages destined to be handled within a certain bound may arrive outside of these bounds, however, they are then ignored. A protocol that assumes this model must commit or reject decisions by a deterministically computable time. 

- **Global Stabilization Time (GST)**: The unknown point in time after which a partially synchronous network behaves synchronously. This term is critical in distinguishing traditional BFT protocols from fully-synchronous ones, which assume GST has already occurred or is always satisfied.

- **Fork-transferable**: A property of a consensus protocol that allows consumers to transfer application state from a forked chain of consensus rounds while preserving verifiability and auditability, even in the presence of honest partitions or temporary disagreement.

- **Fork-perfect**: A refinement of PBFT’s intersection safety. A fork is fork-perfect if every round of consensus along the fork intersects with at least one unit of honest voting power *relative to the fork*. This ensures local safety guarantees on a per-fork basis, even in the presence of multiple non-merging branches.

- **Perfect Expert**: A theoretical construct (adapted from [expert learning models](https://people.csail.mit.edu/ronitt/COURSE/S16/notes7.pdf)) which assumes the existence of a strategy (or sequence of decisions) that would have been globally optimal or correct. In consensus, identifying this expert is analogous to identifying a perfect fork. Fork-perfectness aims to localize this ideal to a given fork in the presence of asynchrony or faults.

- **Minority-aware**: A protocol property requiring formal understanding and bounded valuation of consensus decisions made by a Byzantine minority. This property mandates a clear risk model quantifying the probability and cost of such decisions under full synchrony when liveness demands finality at fixed times.

## Desiderata

### D1: Fully-synchronous

**User journey**: Consumers of Dongmen Postconfirmations consensus can rely on agreement to be achieved by a know Global Stabilization Time w.r.t. to the confirming ledger. 

**Justification**: A fully-synchronous protocol is a consensus protocol under FLP. It also renders predictable points in time by which consensus will be achieved, offering qualitatively optimal liveness. 

### D2: Fork-transferable

**User journey**: Consumers of Dongmen Postconfirmations consensus can safely transfer state from the ledger by following a set of standards. 

**Justification**: The transfer of value from a BFT system to other systems is critical in the modern DLT landscape. How to do this safely is critical to both application and general ledger usage.

### D3: Fork-perfect

**User journey**: Consumers of Dongmen Postconfirmations consensus can rely on consensus to identify the assumed perfect expert w.r.t. a given fork. 

**Justification**: We assert the perfectness of PBFT argued for in [PBFT and Perfectness](#a2-pbft-and-perfectness) is an essentially quality of modern BFT networks. 

### D4: Minority-aware

**User journey**: Consumers of Dongmen Postconfirmations consensus can rely on a formalized understanding of the expected value of Byzantine consensus attack w.r.t. the value of the state and intrinsic rewards. This may additionally consider [fork-transferrable](#d2-fork-transferable) stipulations.  

**Justification**: We assert that the [**full-synchronicity**](#d1-fully-synchronous) of Dongmen Protocols complicates BFT assumptions. These complications must be well understood for a given protocol. 

## Appendix

### A1: BFT Synchronicity and Liveness

| Model            | Network Delays Known? | Bounded? | Known Bound? |
|------------------|------------------------|----------|----------------|
| Synchronous      | Yes                    | Yes      | Yes            |
| Asynchronous     | No                     | No       | No             |
| Partially Synchronous | No                     | Yes, after GST | No            |


| Feature               | Asynchronous               | Partially Synchronous         | Fully Synchronous              |
|-----------------------|---------------------|-------------------------|--------------------------|
| **Message delay**         | Unbounded forever   | Unbounded until GST     | Bounded always           |
| **Knowledge of bounds**   | None                | Exist post-GST (unknown) | Known and fixed          |
| **Liveness possible?**    | No | Yes, eventually         | Yes, by bounds |

| Feature                        | Fully Synchronous            | Partially Synchronous               |
|-------------------------------|-----------------------------------|----------------------------------------|
| **Timing Assumption**         | Fixed known bounds                | Unknown bounds before GST              |
| **Liveness Guarantee**        | Always (if bounds hold)           | Only eventually (after GST)            |
| **Safety Guarantee**          | Depends on strict timing, traditional Byzantine assumption violated          | Holds even under asynchrony            |
| **Fault Tolerance**           | Assumptions must be modified to allow a non-supermajority fork to exist, hence not traditionally BFT  | Designed to tolerate Byzantine faults  |
| **Performance**               | High under tight control          | Adaptive but may have delays           | 

### A2: PBFT and Perfectness

[PBFT](https://pmg.csail.mit.edu/papers/osdi99.pdf) introduced a protocol which ensures consecutive rounds of consensus intersect in at least one unit of honest voting power via the Generalized Pigeon Hole Principle. The transitivity of this property ensures that a chain of consensus rounds must intersect in at least one unit of honest voting power. 

Under an [experts model](https://people.csail.mit.edu/ghaffari/AA19/AAscript.pdf?utm_source=chatgpt.com) understanding of PBFT systems, we can make an assumption that there is a perfect expert and thus that this perfect expert is identified by consensus. This, in turn, renders PBFT a lossless approximate algorithm.

If we consider allowing forks, however, it is initially unclear how perfectness translates. Naively, our assumption that there is globally one perfect expert means that there is one **perfect** fork. 

We can, however, apply a reduced criterion and state that a each **fork** be comprised of a chain of consensus rounds each of which intersect in one unit of honest voting power w.r.t. to the fork itself. We call this **fork-perfectness**.

Preserving **fork-perfectness** reduces to ensuring the fraction of stake which decided the original fork maintains a supermajority. If this does not occur, then it is impossible to have the guaranteed intersection. 

### A3: Awareness of Minority Decisions

The requirement of **full-synchronicity** means that if a supermajority decision is not made by Global Stabilization Time, some form of minority decision must effectively be made. This does not inherently mean that a Byzantine fraction of voting power may decide the global state. For example, if long-lived forks are preserved, there are multiple global states and eventual supermajority consistency can be achieved via a reconstitution of supermajority stake on an honest fork. In other words, while a **partially-synchronous** system renders eventual liveness and guaranteed safety, a **full-synchronous** system can render guaranteed liveness and eventual safety. 

Regardless, Dongmen Postconfirmation protocols are required to provide a formal model of the expected value of consensus on a Byzantine minority w.r.t. the value of the state and intrinsic rewards. In other words, they must explain the nature of eventual safety that abides by Byzantine assumptions or else describe the non-BFT nature of the protocol at full-synchronous decision points. 

### A4: Example Minority-Aware Protocol
Consider the following fully-synchronous protocol:

1. Votes $v \in V_h$ are cast for states $s \in S_h$ at height $h \in H$.
2. A decision in made on a vote $s, h$ by time $t \in T$.
    1. If $V_{h}(s) > \frac{2*|V|}{3}$, accept $s, h$
    2. Otherwise, begin **Play Foward** algorithm.

The **Play Forward** algorithm is as follows:

Given a duration $d: (t + d) \in T$, and a slot duration $l: (d/l) \in T$, for each slot $l'$ in the duration $t, t + l, ... t + d$ $h' = h + (l'/l)$. 

If $l' > d$, accept the root $s, h$ of the heaviest remaining subtree by weight. 

Otherwise, for each tuple $(s, h') \in V_{h'}$ 

1. If $V_{h'}(s) > \frac{2*|V|}{3}$, accept $s, h$, i.e., the original commitment at the root of the subtree. 
2. If $V_{h'}(s) = \text{argmin} V_{h'}(s)$, remove all tuples $s, h \leq V_{h'}(s)$ and their descendants from the entire tree.

At any given round, the number of ways the Byzantine fraction $\frac{|V|}{3} - 1$ can be eliminated is $n' = (incomplete)$ out of the total number of combinations $n$. 

Thus, the probability of that the Byzantine fraction makes it to the final acceptance is $p =(incomplete)$. 

All other subtrees are considered honest partitions. Accepting any of these is considered **perfect**.

Thus, our protocol now admits a $p$ probability of Byzantine attack. The expected value of Byzantine consensus attack is $p(Val(s) + Val(Rewards(h)))$.

This is **fully-synchronous** because a decision will be cast on $h$ by $t + d$. 

### A6: Examples Minority-Selecting Protocols

Consider the following synchronous protocol:

Voters, where $N$ is the number of voters, cast their votes $v \in V_h$, for states $s \in S_h$ at slot height $h \in H$. The first recorded vote on height $h$ determines the timestamp $t_h$ of that slot. Let $\sigma_h(s_h)$ be the number of votes for state $s_h$ at slot height $h$. A voter can cast at most one vote per state per slot height.

Slots are handled sequentially, i.e. if slot height $h^+$ has not been processed, then slot height $h^++1$ is not processed.

The basic protocol looks as follows:

1. Vote and potential vote propagation (described in next subsections)
1. For each undecided height $h^+ < h$
    1. If $\sigma_{h^+}(s_h^+) > \frac{2}{3}|V|$ AND $t \leq t_h^+ + \Delta$, accept the tuple $(s_h^+, h^+)$. Continue processing slot $h^++1$.
    2. Else If $t > t_h^+ + \Delta$, select the branch with the highest weight. Continue processing slot $h^++1$.
    3. Else Return

Note that 2.ii) is where the **synchronous nature** of the protocol is used.

> :warning: Since nodes could set the timestamp arbitrarily into the future for a given slot height, we MUST require that nodes cannot vote for heights that are too far away from accepted heights. This is important for the synchronous model.

We assume that the nodes can become faulty or byzantine, vote for a branch with state $s^x_h$ and may acknowledge they voted for the wrong branch.

We suggest that these nodes should be permitted to support a different branch (with state $s_h$) that they deem correct (and that is in conflict with their previous vote). In order to vote for $s_h$ they MUST be permitted to cast an additional vote (**revote**) for $s_h$ at height $h$.

Since a the choice for a new branch would mean that all previous votes are invalid (from the point of view of the voter itself), this raises the question of how to handle revotes, and in particular the ancestor votes that depend on this.

A combination of the following two properties can be used to achieve the desired protocol:

- Revoting
    1. Revoting is not allowed. (Voter can cast one vote per slot height only)
    1. Revoting is allowed.
- Counting of votes
    1. Double counting, i.e., all votes count, including votes before revoting.
    1. Only the last vote counts.
- Propagation of votes
    1. Votes are cast for a branch, not a state. (less transactions but per transaction more computation)
    1. Votes are cast for a state, not a branch. (more transactions but per transaction less computation)

Lets explore sone of the options:

#### A6.1: Revotes, double counting, no propagation

Step 1 of the above algorithm becomes

1. Given a vote for state $s_h$ at slot height $h$, update
 $\sigma_h(s_h) \leftarrow \sigma_h(s_h) + 1$.

**What can go wrong?**

- If no branch is finalized at $t_h^+ + \Delta$, the protocol will select the branch with the highest weight, this may not be secure against a Byzantine minority.
- Since votes of a node can double count, it is possible that eventually the wrong branch wins, since a byzantine actor plus the initial wrong "honest" votes can outvote the correct branch.

#### A6.2: No Revotes, single-counting, with propagation

Here we would like to entertain that nodes can resubmit their vote for a different branch, but existing votes cannot be changed. We also would like to propagate votes a long a branch to ensure that this branch is maximally supported.

Step 1 of the above algorithm becomes

1. Given a vote for state $s_h$ at slot height $h$, update
    1. $\sigma_h(s_h) \leftarrow \sigma_h(s_h) + 1$.
    2. For each ancestor state $s_{h-k}$, $k>0$ of $s_h$ in the tree that is not yet voted on, $\sigma_{h-k}(s_{h-k}) \leftarrow \sigma_{h-k}(s_{h-k}) + 1$.

We note this is marginally different to the previous example. It differs only in that a voter can batch votes for a branch not a state. This is not a meaningful solution but it is the precursor to the next example.

**What can go wrong?**
1. Same problem as previous example.

#### A6.3: Revotes, single-counting, with propagation

Assume the previous protocol, but votes are removed from branches that are not supported any longer. This means we override previous votes.

Step 1 of the above algorithm becomes

1. Given a vote for state $s_h$ at slot height $h$, update
 $\sigma_h(s_h) \leftarrow \sigma_h(s_h) + 1$.
2. For each ancestor state $s_{h-k}$ of $s_h$ in the tree that is not finalized and for which the vote has not already been cast, $\sigma_{h-k}(s_{h-k}) \leftarrow \sigma_{h-k}(s_{h-k}) + 1$.
3. For each height $h^+< h$, remove all votes for $s_{h^+}$ from a branch that is not an ancestor of $s_h$.

> :bulb: This has infact similar behavior and properties to [Tangle 2.0 Leaderless Nakamoto Consensus on the Heaviest DAG](https://ieeexplore.ieee.org/document/9907014). However, here we have a tree and an L1 to synchronize and remove problems with partitions, which makes the challenges much easier.

**What can go wrong?**

- If no branch is finalized at $t_h^+ + \Delta$, the protocol will select the branch with the highest weight, this may not be secure against a Byzantine minority.

## Changelog
