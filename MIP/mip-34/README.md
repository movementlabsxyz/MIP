# MIP-34: Fast-Finality Settlement

- **Description**: Establish the scope and components that are part of the Fast-Finality Settlement mechanism.
- **Authors**: [Franck Cassez](), [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)

## Abstract

Fast-Finality Settlement (FFS) is a mechanism that allows for fast _confirmation_ of transactions backed by crypto-economic security. This MIP outlines the high-level specifications and architecture of FFS.

## Definitions

- **L2-block** - See [Overview](#overview)
- **sequencer-batch** - See [Overview](#overview)  
- **FFS** - Fast Finality Settlement. See [Overview](#overview)  
- **L1-finality** - finality mechanism for layer 1. 
- **L2-finality** -  finality mechanism (confirmation) for layer 2. See [Overview](#overview)  
- **L2-confirmation** - Same as L2-finality, see [Overview](#overview)
- **QC** - Quorum certificate. See [Overview](#overview)  
- **postconfirmation** - a finality guarantee related to L1. See [Overview](#overview)  
- **MCR** - Multi-commit Rollup : an implementation of FFS.
- **PoS** - Proof of Stake
- **validator** - a node that is responsible for validating transactions and producing blocks. See [Overview](#overview)  

In addition we make the note for the following terms:

- **batch** (not recommended)
Less clean, but more common term for sequencer-batch. May be mixed up with the batch of transactions sent to the sequencer, or with the batch of blocks that should be processed by the L1-contract. 
- **block** 
More common term for block. May be mixed up with the batch of transactions sent to the sequencer, the L1-block or with the batch of blocks that should be processed by the L1-contract. Here we mean L2-block.
- **attester**  (not recommended)
The term attester has been deprecated in favor of validator.



## Motivation

Layer 2s (L2), including rollups, publish or secure transaction data in a data availability (DA) layer or at Ethereum mainnet (Layer 1, L1). Validity and optimistic rollups can finalize (confirm) transactions within approximately 30 minutes, resp. ~1 week. Until a transaction is finalized, there is no assurance about its validity and result (success or failure). This can be a limiting factor for certain types of DeFi applications.

Our objective is to enable transaction issuers to quickly get some guarantees that their transactions are correctly included in a block. The crypto-economic security is provided by a PoS protocol.

The mechanism can be deployed independently for a chain, or used in combination with existing settlement mechanisms, such as ZK and optimistic settlements.

As a result, users can rely and trust the **L2-finality**  to use as confirmation, or if the chain is configured to do so, wait for **L1-finality**, such as end of challenge window for fraud proofs (optimistic L2) or verification of a ZK-proof (validity L2).

A introduction to FFS can be found in [this blog post on Fast-Finality Settlement](https://blog.movementlabs.xyz/article/security-and-fast-finality-settlement). A more detailed description of a (partial) implementation of the mechanism is available at [this blog post on postconfirmations](https://blog.movementlabs.xyz/article/postconfirmations-L2s-rollups-blockchain-movement).

This MIP provides an overview of an architecture of FFS, and its main components.

## Specification

### Overview

The objective of FFS is to confirm that transactions are processed correctly. It does not relate to the ordering of transactions.

At an abstract level, the L2-blockchain increases by a new block in each (L2) round, and this block is the successor of the block in the previous round, the _predecessor_. Initially, there is a _genesis_ block with no predecessor.

**Sequencer-Batch**. Each round corresponds to the processing of a _sequencer-batch_ of transactions which is proposed by the _sequencer_ (can be centralised, decentralised, shared). 

**L2-Block**. Since we generally mean L2-blocks we will ommit the "L2-" prefix, i.e. by _block_ we mean L2-block. A node with execution capability is then in charge of validating the transactions in the sequencer-batch and calculate the new state. Since the sequencer-batch is given by the sequencer, the new state and the state roots for a block are deterministic. For a sequencer-batch $b$ the state is $S_b$ and the state root is $H(S_b)$. From the sequencer-batch $b$ and the state $S_b$ the block $B$ is computed (which contains the information of the sequencer-batch and the state root). 

**Local validation**. Since the block is deterministically calculated we say a block (and the associated new state) is _validated locally_ once the execution engine calculates it from the sequencer-batch. 

**L2-confirmation / L2-finality**. FFS aims to _confirm_ the validity of each produced block, at every block. The validity judgement to be made is: 
> [!NOTE]
> Given a block $B$ (predecessor), a sequencer-batch of transactions $txs$ and a successor block $B'$, is $B'$ the^[the MoveVM is deterministic and there can be only valid successor.] _correct_ successor of $B$ after executing the sequence of transactions $txs$?

The term _correct_ means that the successor block $B'$ (and the state it represents) has been computed in accordance with the semantics of the MoveVM, which we denote  $B \xrightarrow{\ txs \ } B'$.

> [!IMPORTANT]
> If we confirm each successor block before adding it to the (confirmed) L2-chain, there cannot be any fork, except if the sequencer would provide equivocating sequencer-batches for a given height AND there is a sufficiently strong Byzantine attack on the confirmation process.

**Validator**. To guarantee the validity of a new block $B'$, we use a set of _validators_ who are in charge of verifying the transition $B \xrightarrow{\ txs \ } B'$.

**Attestation**. To do so they _attest_ for the new block $B'$ by casting a vote :white_check_mark: or :x:. 

**L2-finality certificate / quorum certificate (QC)**. When enough validators have attested for a new block $B'$, the block is _L2-final_. The accumulation of enough votes is aggregated in a quorum certificate (i.e. the L2-finality certificate). The block is then considered to be _confirmed_. A naive implementation of the quorum certificate is a list of votes.

> [!NOTE]
> Until a better definition arises we consider _**confirmation**_ to be defined as _L2-finality_ (or _L2-confirmation_).

If the validators can attest blocks quickly and make their attestations available to third-parties, we have a fast confirmation mechanism supported by crypto-econonimic security, the  level of which depends on what is at stake for the confirmation of a block.


**Postconfirmation**. At certain intervals L2-finality certificates will also be published to L1. The L1 contract will verify the L2-finality certificate. This provides an L1-protected _postconfirmation_ that the block (or a batch of blocks) is indeed confirmed. This additional anchoring mechanism increases the security of the L2-confirmation as it locks in the L2-confirmation, reduces the risk of long range attacks and provides a way to slash validators that have attested for invalid blocks.

**Slashing**. The security of the mechanism relies on a PoS protocol. Each validator has to stake some assets, and if they are malicious they _should_ be slashed.
The condition for slashing may be met by several quiteria, and not all slashing conditions may be used:
- equivocate (send a different vote to different validators or users)
- vote :white_check_mark: for an invalid block 
- vote :x: for a valid block

### Main challenges

To achieve crypto-economically secured Fast-Finality, we need to solve the following problems:

1. design a _staking_ mechanism for the validators to stake assets, distribute rewards and manage slashing
1. _define and verify_ the threshold (e.g. 2/3 of validators attest :white_check_mark:) for L2-finality
1. _communicate_ the L2-finality status.

In addition the following may require separate discussion, as it is a different procedure (postconfirmations are handled in smart contracts on L1, whereas L2-finality is handled off-chain)

4. _define and verify_ the threshold (e.g. 2/3 of validators attest :white_check_mark:) for postconfirmation.


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

#### Handle postconfirmations (addresses 4.)

The L1 contract will verify the L2-finality certificate. If the certificate is correct the block (or sequence of blocks) are _postconfirmed_. This requires handling who should send the certificate to the L1 contract, and how to verify the certificate.


## Reference Implementation

To simplify we assume that each validator stakes the same amount.
The set of validators is in charge of validating sequenced batches and producing blocks that also commit to the state root of the sequenced batch.

There may be different protocols for the postconfirmation, and the L2-finality certificate. Here we focus only on the L1 contract.

#### Version A: Leader-dependent block

A leader validator $V_l$ is elected for a certain interval. 

The leader proposes the next transition (and block $B'$):  $B \xrightarrow{\ txs \ } B'$.
They can do by sending a digest of $txs$ (Merkle root) and a digest of $B'$ (Merke root hash of $B'$), or a _change set_.
Every other validator checks the validity of $B'$ and send their vote to $V_l$.
Once $V_l$ has received more than 2/3 of :white_check_mark: for $B'$ they sent the votes (who voted :white_check_mark: and who voted :x:) to the L1 staking contract **and** to the DA.

From there on two separate threads of event occur:

- the DA layer returns an _availability certificate_ that a proof of 2/3 super-majority is available for block $B'$. This step should take O(1) second if we use a fast reliable mempool.
- the Staking contract on L1 _will_ eventually verify the proof of of 2/3 super-majority (on Ethereum mainnet this should take in the order of 13mins).

#### Version B: Leader-independent block

A leader validator $V_l$ is elected for a certain interval. 

Blocks are deterministically derived from the sequencer-batch. Validators attest for the next transition:  $B \xrightarrow{\ txs \ } B'$.

In the scenario where validators commit individually they send the block hashes of the calculated blocks directly to the L1 contract. A leader may be required to update the latest state when the super-majority is reached. A leader approval may not be necessary, however the leader takes a special role and may incur increased gas costs compared to the remainder of validators and has to be rewarded accordingly. Since the block derivation is deterministic, $f+1$ may be sufficient to confirm the block. (However, we require $2f+1$ to cover potential edge cases, such as that the sequencer cannot be trusted.)

In a more optimised scenario, the leader sends the super-majority proof to the L1 contract. A similar approach applies on the DA layer.


<!-- The Fast-Finality Settlement mechanism consists of the following components/mechanisms and which should be addressed separately in their own MIPs:

- A set of validators that are responsible for validating transactions and producing blocks, and how they communicate with each other.
- A mechanism for validators to create a quorum certificte for new states on L2.
- A mechanism for validators to stake tokens as collateral.
- A mechanism for validators to be rewarded for correct behavior and penalized for misbehavior.
- Postconfirmations, a mechanism for a user to obtain a confirmation for a transaction that it has been attested to on L1 by a validator.
- L2-finality, a mechanism for validators to confirm transactions after they have been included in an block AND a quorum of validators has confirmed the state that is created by that block.
- A fast bridge that allows for the transfer of tokens between L1 and L2, and vice versa. -->

## Verification

### Correctness

The correctness of the mechanism relies on a few trust assumptions.

First we assume that at most $f$ of the total $n$ (L2) validators can be malicious.
This implies that if more than $2f +1$ attest :white_check_mark: for a new block, at least $f + 1$ honest validators have attested :white_check_mark:, so at least one honest validator has :white_check_mark: $B'$ and $B'$ is valid.

It is common to have $f < \frac{1}{3}n$ and in this case we request that >$\frac{2}{3}n$ (super-majority)  validators have :white_check_mark: $B'$ to validate $B'$.

**Postconfirmations**. Second, we assume that the staking contract that validates the proof of super-majority is correct (there are no bugs in the implementation of the contract). As a result, when the staking contract verification step is confirmed on L1 (L1-finality), the super-majority proof is verified.

Combining the two results above we have: confirmation (L1 contract) that >2/3 of validators have attested :white_check_mark: and if >2/3 have attested :white_check_mark: then $B'$ is valid. So overall, if the >2/3 super-majority is verified by the staking contract, $B'$ is valid.

**L2-finality** Third, in the above design, verification and inclusion happens in the order of seconds. However, it takes up to 13 minutes to verify the super-majority proof on Ethereum. The L2 validators also publish the proofs to DA layer and once the proof is available it cannot be tampered with. Thus, we can provide some guarantees about L2-finality when the availability certificate is delivered, and before the actual proof is verified on L1. If the validators are malicious and publish an incorrect proof, they _will_ be slashed in the next 13 minutes, which provides strong incentives for validators not to act malicious.

This is conditional to:

- ensuring that the validators send the same proof to the L1 staking contract and to the DA.
- validators cannot exit too early (not before the proof they are committeed to are confirmed on L1).

### Security

The security of this approach is discussed in [this blog post on Fast-Finality Settlement](https://blog.movementlabs.xyz/article/security-and-fast-finality-settlement).
The level of security depends on the total stake of the L2 validators. The higher the more secure.

### Performance

There are several aspects that can impact performance and should be properly addressed:

- time to collect the super-majority votes
- time to get an availability certificate for the super-majority proof
- number and size of messages and transactions, specifically containing the signatures

## Detailed plan and implementation

A detailed plan should be proposed addressing the implementation of the different components, and ideally MIPs to capture the requirements for each component.

- **validators network**: how they communicate and build the _super-majority proof_.
- **L2-finality**: communication of the super-majority proof to the DA. Validators should certificate in the order of seconds to provide L2-finality in the order of seconds.
- **postconfirmation**: L1 validation contract, how it verifies the super-majority proof and if and how there is interaction with the DA layer.
- **staking**: what crypto-coin is used for staking, safeguards to prevent validators from exiting too early etc


## Optimisations

There are several aspects that could be optimised and refined:

- super-majority proof: it can be a list of votes, but could also be a zk-proof (more compact). The suer-majority proof is not a proof of correct execution (as in zkVM) but simply of super-majority and this is cheaper to compute.
- signatures aggregation: we want to avoid sending large transcations to the L1 as it increases operational costs. How to aggregate signatures to send more compact messages/trasactions?
- delegation/weighted stakes: a mechanism for validators to delegate their voting power to other validators. Ability for validators to stake different amounts (and use weighted stakes super-majority).
- commit to a sequence of L2-blocks. The L2-finality certificate could be per block. However, on L1 we may want to commit to a sequence of blocks. This can be done by committing to the state root of the last block in the sequence or more complicated approaches using Merkle roots. 

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
