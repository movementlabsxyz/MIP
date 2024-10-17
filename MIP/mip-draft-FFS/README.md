# MIP-?: Fast-Finality Settlement

- **Description**: Establish the scope and components that are part of the Fast-Finality Settlement mechanism.
- **Authors**: [Franck Cassez](), [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)

## Abstract

Fast-Finality Settlement (FFS) is a mechanism that allows for fast _confirmation_ of transactions backed by crypto-economic security. This MIP outlines the high-level specifications and architecture of FFS.

## Definitions

- **FFS** - Fast Finality Settlement
- **L1-finality** - finality mechanism (confirmation) for layer 1
- **L2-finality** -  finality mechanism (confirmation) for layer 2
- **MCR** - Multi-commit Rollup : an implementation of FFS
- **PosP** - Proof of Stake
- **Postconfirmation** - a finality guarantee related to L1
- **Validator** - a node that is responsible for validating transactions and producing blocks

## Motivation

Layer 2s (L2) and rollups have to publish transaction data to a data availability (DA) layer or to Ethereum mainnet (Layer 1, L1). Validity (ZKP) and optimistic (FP) rollups can finalize (confirm) transactions within approximately 30 minutes (ZKP) resp. ~1 week (FP). Until a transaction is finalized, there is no assurance about its validity and result (success or failure). This can be a limiting factor for certain types of DeFi applications.

Our objective is to enable transactions's issuers to quickly get some guarantees that their transactions are correctly included in a block. The crypto-economic security is provided by a PoS protocol.

The mechanism can be deployed independently for a chain, or used in combination with existing settlement mechanisms, such as ZK and optimistic settlements.

As a result, users can rely and trust the **L2-finality**  to use as confirmation, or if the chain is configured to do so, wait for **L1-finality**, end of challenge window for fraud proofs (optimistic L2) or verification of a ZK-proof (validity L2).

A introduction to FFS can be found in [this blog post on Fast-Finality Settlement](https://blog.movementlabs.xyz/article/security-and-fast-finality-settlement). A more detailed description of a (partial) implementation of the mechanism is available at [this blog post on Postconfirmations](https://blog.movementlabs.xyz/article/postconfirmations-L2s-rollups-blockchain-movement).

This MIP provides an overview of an architecture of FFS, and its main components.

## Specification

### Overview

The objective of FFS is to confirm that transactions are processed correctly. It does not relate to the ordering of transactions.

At an abstract level, the blockchain produces a new block in each round, and this block is the successor of the block in the previous round, the _predecessor_. Initially, there is a _genesis_ block with no predecessor.
Each round corresponds to the processing of a _batch_ of transactions which is computed and proposed by the _sequencer_ (can be centralised, decentralised, shared).

> [!NOTE]
> FFS aims to confirm the validity of each produced block, in **each round**. The validity judgement to be made is: given a block $B$ (predecessor), a batch of transactions $txs$ and a successor block $B'$, is $B'$ the^[the MoveVM is deterministic and there can be only valid successor.] _correct_ successor of $B$ after executing the sequence of transactions $txs$?

The term _correct_ means that the successor block $B'$ (and the state it represents) has been computed in accordance with the semantics of the MoveVM, which we denote  $B \xrightarrow{\ txs \ } B'$.

> [!IMPORTANT]
> If we confirm each successor block before adding it to the chain, there cannot be any fork except if the network is partitioned.

To guarantee the validity of a new block $B'$, we use a set of **validators** who are in charge of verifying the transition $B \xrightarrow{\ txs \ } B'$.
To do so they _attest_ for the new block $B'$ by casting a vote :white_check_mark: or :x:.
When enough validators have attested for a new block $B'$, the block is _postconfirmed_.

The security of the mechanism relies on a PoS protocol. Each validator has to stake some assets, and if they are malicious (vote :white_check_mark: for an invalid block or :x: for a valid block), they _should_ be slashed.

If the validators can confirm blocks quickly and make their attestations available to third-parties, we have a fast confirmation mechanism supported by crypto-econonimic security, the  level of which depends on what is at stake for the confirmation of a block.

### Main challenges

To achieve crypto-economically secured fast-finality, we need to solve the following problems:

1. design a _staking_ mechanism for the validators to stake assets, distribute rewards and manage slashing
1. _define and verify_ the threshold (e.g. 2/3 of validators attest :white_check_mark:) for L2-finality
1. _communicate_ the L2-finality status.

### Components

#### Staking (addresses 1. and 2.)

The staking mechanism is implemented in a contract on L1.
This contract provides the following functionalities:

- join: a new validator can join the set of validators by staking some assets
- exit: a validator exits and  get their stakes back
- vote: receive a vote or a set of votes, verify the integrity of the votes (signatures) and the minimum threshold (e.g. 2/3)

#### Generate an L2-finality certificate (addreses 3.)

To ensure that the L2-finality status is made available to third-parties, we may publish our _proof_  (2/3 of attestations :white_check_mark:) to a data availability layer and get a _certificate_ that the proof is available.  
This DA layer should offer a reliable _mempool_ for example as described [in this paper](https://arxiv.org/pdf/2105.11827).

## Reference Implementation

To simplify we assume that each validator stakes the same amount.
The set of validators is in charge of validating a block at each round.

A leader validator $V_l$ is elected in each round, and proposes the next transition (and block $B'$):  $B \xrightarrow{\ txs \ } B'$.
They can do by sending a digest of $txs$ (Merkle root) and a digest of $B'$ (Merke root hash of $B'$), or a _change set_.
Every other validator checks the validity of $B'$ and send their vote to $V_l$.
Once $V_l$ has received more than 2/3 of :white_check_mark: for $B'$ they sent the votes (who voted :white_check_mark: and who voted :x:) to the L1 staking contract **and** to the DA.

From there on two separate threads of event occur:

- the DA layer returns an _availability certificate_ that a proof of 2/3 super-majority is available for block $B'$. This step should take O(1) second if we use a fast reliable mempool.
- the Staking contract on L1 _will_ eventually verify the proof of of 2/3 super-majority (on Ethereum mainnet this should take in the order of 13mins).

<!-- The Fast-Finality Settlement mechanism consists of the following components/mechanisms and which should be addressed separately in their own MIPs:

- A set of validators that are responsible for validating transactions and producing blocks, and how they communicate with each other.
- A mechanism for validators to create a quorum certificte for new states on L2.
- A mechanism for validators to stake tokens as collateral.
- A mechanism for validators to be rewarded for correct behavior and penalized for misbehavior.
- Postconfirmations, a mechanism for a user to obtain a confirmation for a transaction that it has been attested to on L1 by a validator.
- L2-finality, a mechanism for validators to confirm transactions after they have been included in an L2-block AND a quorum of validators has confirmed the state that is created by that L2-block.
- A fast bridge that allows for the transfer of tokens between L1 and L2, and vice versa. -->

## Verification

### Correctness

The correctness of the mechanism relies on a few trust assumptions.

First we assume that at most $f$ of the total $n$ (L2) validators can be malicious.
This implies that if more than $2f +1$ attest :white_check_mark: for a new block, at least $f + 1$ honest validators have attested :white_check_mark:, so at least one honest validator has :white_check_mark: $B'$ and $B'$ is valid.

It is common to have $f = \frac{1}{3}n$ and in this case we request that $\frac{2}{3}n$ (super-majority)  validators have :white_check_mark: $B'$ to validate $B'$.

Second we assume that the Staking contract that validates the proof of super-majority is correct (there are no bugs in the implementation of the contract).
As a result, when the staking contract verification step is confirmed on L1 (L1-finality), the super-majority proof is verified.

Combining the two results above we have: confirmation (L1 contract) that 2/3 of validators have attested :white_check_mark: and if more than 2/3 have attested :white_check_mark_ then $B'$ is valid. So overall, if the 2/3 super-majority is verified by the staking contract, $B'$ is valid.

In the previous design, it takes upto 13 minutes to verify the super-majority proof on Ethereum.
However, the L2 validators also publish the proofs to DA layer and once the proof is available it cannot be tampered with.
This is why we can provide some guarantees about L2-finality when the availability certificate is delivered, and before the actual proof is verified on L1.
If the validators are malicious and publish an incorrect proof, they _will_ slashed in the next 13 minutes, which should be enough incentives for them to not be malicious.

This is conditional to:

- ensuring that the validators send the same proof to the L1 staking contract and tothe DA
- validators cannot exit too early (not before the proof they are participated to are confirmed).

### Security

The security of this approach is discussed in [this blog post on Fast-Finality Settlement](https://blog.movementlabs.xyz/article/security-and-fast-finality-settlement).
The level of security depends on the total stake of the L2 validators. The higher the more secure.

### Performance

There are several aspects that can impact performance and should be properly addressed:

- time to collect the super-majority votes
- time to get an availability certificate
- number and size of messages and transactions, specifically containing the signatures

## Detailed plan and implementation

A detailed plan should be proposed addressing the implementation of the different components, and ideally MIPs
to capture the requirements for each component.

- validators network, how they communicate and build the _super-majority proof_.
- staking: what crypto-coin is used for staking, safeguards to prevent validators from exiting too early etc
- communication of the super-majority proof to the DA. This is mostly a performamce issue and we need to get a certificate in the order of seconds to provide L2-finality in the order of seconds.

## Optimisations

There are several aspects that could be optimised and refined:

- super-majority proof: it can be a list of votes, but could also be a zk-proof (more compact). The suer-majority proof is not a proof of correct execution (as in zkVM) but simply of super-majority and this is cheaper to compute.
- signatures aggregation: we want to avoid sending large transcations to the L1 as it increases operational costs. How to aggregate signatures to send more compact messages/trasactions?
- delegation/weighted stakes: a mechanism for validators to delegate their voting power to other validators. Ability for validators to stake different amounts (and use weighted stakes super-majority)

<!-- 
4. **Validation Procedures**:

n/a

5. **Peer Review and Community Feedback**:

n/a -->

## Errata

<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the proposal in which the error was identified.

  TODO: Maintain this comment.
-->

n/a

## Appendix

<!--
  The Appendix should contain an enumerated list of reference materials and notes.

  When referenced elsewhere each appendix should be called out with [A<number>](#A<number>) and should have a matching header.

  TODO: Remove this comment before finalizing.

-->

n/a
