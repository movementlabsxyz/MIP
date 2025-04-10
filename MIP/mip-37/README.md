# MIP-37: FFS: Postconfirmation

- **Description**: Confirmations of superBlocks on L1. A sub-protocol of Fast Finality Settlement.
- **Authors**: Andreas Penzkofer
- **Desiderata**: [MD-37](https://github.com/movementlabsxyz/MIP/tree/mip/postconfirmation/MD/md-37), [MD-4](https://github.com/movementlabsxyz/MIP/pull/4), [MD-5](https://github.com/movementlabsxyz/MIP/pull/5), [MD-117](https://github.com/movementlabsxyz/MIP/pull/117)

## Abstract

Fast-Finality-Settlement (FFS) is proposed in [MIP-34](https://github.com/movementlabsxyz/MIP/pull/34), with two confirmation mechanisms: one on the base chain level (L1) and one on the rollup/sidechain level (L2). This MIP details the mechanism on Level 1 (L1), which is called ***Postconfirmation***.

The L2 produces **L2Blocks**. At certain intervals validators commit a sequence of L2Blocks in a ***superBlock***, to L1. The L1 contract will verify if >2/3 of the validators have attested to a given superBlock height. The action for this validation is called Postconfirmation and it is initiated by the ***acceptor***. The acceptor is a specific validator selected for some interval and it is added to the protocol to provide separation of concerns (attestations vs. Postconfirmation) and provide more predictable costs and rewards.

This provides an L1-protected guarantee that a superBlock (i.e. a sequence of L2Blocks) is accepted and correctly executed. This anchoring mechanism increases the security of the L2 as it protects the L2-state against long range attacks, see [MD-5](https://github.com/movementlabsxyz/MIP/tree/l-monninger/long-range-attacks/MD/md-5).

A introduction to Postconfirmation can also be found in [this blog post](https://blog.movementlabs.xyz/article/security-and-fast-finality-settlement) and a more detailed description of a (partial) implementation of the mechanism is available at [this blog post](https://blog.movementlabs.xyz/article/Postconfirmations-L2s-rollups-blockchain-movement).

## Motivation

We require from the FFS protocol that it is secure and efficient, yet simple in its *initial* design. In order for the protocol to fulfill the requirement for simplicity, validators only communicate to the L1-contract and not with each other. This is a key design decision to reduce the complexity of the protocol, but can be improved in the future.

We also request that rewards and costs are made more predictable for validators. For this, we propose a special role -- the acceptor -- to perform the action of updating the L1 contract to accept a given state by super majority. This action is called Postconfirmation.

## Specification

*The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.*

Figure 1 shows the leader-independent (deterministic) block generation process, which is also discussed in [MIP-34: Fast Finality Settlement](https://github.com/movementlabsxyz/MIP/pull/34).

![Version A Diagram](Postconfirmation.png)
*Figure 1: Leader-independent (deterministic) block generation process.*

Since this document introduces a large number of new terms, we provide a specification by defining the terms and their interactions.

#### Domains - one staking contract to rule them all

The L1 staking contract is intended to handle multiple chains. We differentiate between the chains by their unique identifier `domain` (of type `address`).

#### L2Blocks

L2Blocks are deterministically derived from the sequencer-batches, which are called protoBlocks. Validators calculate the next deterministic transition (imposed through the sequence of transactions $txs$) $B \xrightarrow{\ txs \ } B'$, where $B$ and $B'$ are L2Blocks.

#### SuperBlock

The Postconfirmation protocol is unlikely to attest to each individual L2Block. L2Blocks may be produced at higher frequency than L1Blocks or the cost of Postconfirmation is high, thus leading to low frequency commitments. Therefore, after a defined number of L2blocks, validators calculate the next (deterministic) superBlock and commit to it in the L1 contract. The L1 contract will verify (triggered by the acceptor) if >2/3 of the validators have attested at a given superBlock height to a superBlock. Each incremental hight increase may be considered a round.


#### Commitment

Validators commit the hash of the superBlock on the L1-contract. It commits the validator to a certain superBlock at a given height, with no option for changing their opinion. (This is intentional - validators should not be able to revert).

```solidity
struct Commitment {
  uint256 height;
  bytes32 value;
  bytes32 id;
}
```

#### Epochs

We require epochs in order to provide

- **secure on- and off-boarding process** of validators. A validator MUST live in a well-defined state for a sufficient amount of time. The available states are `staked`, `unstaking`, and `not-staking` (in code only the former two may be required). This longevity of a given state both provides stability to the protocol, as well as is a security measure to prevent validators from harming the protocol towards the end of an epoch without implications. Specifically, 
  - if a validator calls the `stake` function, the tokens get locked and voting SHOULD begin at the start of the next epoch. 
  - if a validator calls the `unstake` function, voting SHOULD end at the end of the current epoch. The tokens SHOULD get unlocked no earlier than the end of the next epoch.
- **reward and penalty application**. The borders between periods are also used to manage rewards and penalties. This also renders inefficiencies as calculation of voting weights could be expensive or attackable and thus it should be performed infrequent.

The `epochDuration` MUST be set when initializing a chain. It MAY be changeable later on through a governance mechanism. The `epochDuration` should be set to a value that is large enough to allow for the `staking` and `unstaking` process to be completed. Moreover, it should be long enough for human operators to react.

> :bulb: The initial recommendation for `epochDuration` is 1 day, but it could be lower, as long as it is substantially larger than the finality time of the L1. E.g. in Ethereum the `epochDuration` could be 1 hour, however this would increase gas costs due to frequent epoch transitions.

There are three relevant epoch types

##### 1. `presentEpoch`

`presentEpoch` is the epoch that is currently active on L1.

```solidity
uint256 presentEpoch = getEpochFromL1BlockTime();
```

where

```solidity
function getEpochFromL1BlockTime(address domain) public view returns (uint256) {
    return (block.timestamp - L1GenesisTime ) / epochDuration;
}
```
and `L1GenesisTime` is the time when the L1 contract was deployed.

##### 2. `assignedEpoch`

If a commitment height is new, the current `presentEpoch` value is assigned to the commitment height.

```solidity
/// map each commitment height to an epoch
mapping(uint256 commitmentHeight => uint256 epoch) public commitmentHeightAssignedEpoch;

// assume an instance of Commitment
Commitment memory commitment;

if (commitmentHeightAssignedEpoch[commitment.height] == 0) {
  commitmentHeightAssignedEpoch[commitment.height] = getEpochFromL1BlockTime();
}
```

Any validator can commit the hash of a superBlock. The rollover function should update to the correct epoch for a given commitment height (and the heights above).

> :warning: This may result in an attack vector. An adversary could commit to far in the future commitment heights. While this has no implications on the security, it may increase costs within the contract operation for the acceptor.

As an initial measure, the height of the commitment should not be able to be set too far into the future. Hence there SHOULD be a `leadingBlockTolerance`, that limits how far into the future a block can be added.

```solidity
if (lastPostconfirmedBlockHeight + leadingBlockTolerance < blockCommitment.height) {
    revert ValidatorAlreadyCommitted();
    }
```

The validators have to check if the current commitment height (off-L1) is within the above window. Otherwise the commitment of the (honest) validator will not be added to the L1 contract.

##### 3. `acceptingEpoch`

Votes are counted in the current `acceptingEpoch`. If there are enough votes for a commitment `id` the commitment height receives a Postconfirmation status (for the corresponding commitment value).

The current `acceptingEpoch` SHOULD be queried by

```solidity
function getAcceptingEpoch() public view returns (uint256) {
    return acceptingEpoch;
}
```

#### Staking and Unstaking

Validators can stake and unstake their tokens. The staking and unstaking process is managed by the staking contract. Validators can stake their tokens for a certain epoch. The staking process is initiated by the validator. The validator can also unstake their tokens, such that the stake is released at the end of the next epoch.

The reason for the delay in the unstaking process is to prevent validators from harming the protocol towards the end of an epoch without implications, and to remain accountable for at least one epoch. See also Section [Epochs](#epochs).

```mermaid
gantt
    title Unstaking Timeline
    dateFormat  DD HH:mm
    axisFormat  %d %H:%M

    section Epochs
    Current epoch: active, currentEpoch, 01 00:00, 02 00:00
    Unstake epoch: unstakeEpoch, 02 00:00, 03 00:00
    Next epoch: releaseOfFundsEpoch, 03 00:01, 04 00:00

    section Actions
    Request for unstaking: milestone, 01 16:00, 1min
    Release of Funds: milestone, 03 00:00, 0min
```

We require functions `addStake`, `removeStake`, `addUnstake`, `removeUnstake` to manage the staking and unstaking process.

We require the following mappings

```solidity
// Type aliases for better readability
type Domain is address;
type Epoch is uint256;
type Custodian is address;
type Attester is address;

// Mappings
mapping(Domain => mapping(Epoch => mapping(Custodian => mapping(Attester => uint256)))) public epochStakesByDomain;
mapping(Domain => mapping(Epoch => mapping(Custodian => uint256))) public epochTotalStakeByDomain;
mapping(Domain => mapping(Epoch => mapping(Custodian => mapping(Attester => uint256)))) public epochUnstakesByDomain;

```

For example, the addition functions are

```solidity
function _addStake(
    address domain,
    uint256 epoch,
    address custodian,
    address attester,
    uint256 amount
) internal {
    epochStakesByDomain[domain][epoch][custodian][attester] += amount;
    epochTotalStakeByDomain[domain][epoch][custodian] += amount;
}
```

and

```solidity
function _addUnstake(
    address domain,
    uint256 epoch,
    address custodian,
    address attester,
    uint256 amount
) internal {
    epochUnstakesByDomain[domain][epoch][custodian][attester] += amount;
}
```

#### Rollover

The protocol increases the `acceptingEpoch` incrementally by one, i.e. the protocol progresses from one accepting epoch to the next. Whenever, such an incrementation happens, the stakes of the validators get adjusted to account for `staking` and `unstaking` events. This transition is called *Rollover*. On the default path the `rolloverEpoch` function is called by the [acceptor](#acceptor).

A rollover can occur in two types of paths:

1. If the `assignedEpoch` of the next superBlock height falls into the next epoch, the protocol progresses to the next epoch.

```solidity
uint256 nextSuperBlockHeight = thisPostconfirmationBlockHeight + 1;
uint256 nextSuperBlockEpoch = superBlockHeightAssignedEpoch[nextSuperBlockHeight];
while (getAcceptingEpoch() < NextSuperBlockEpoch) {
  rollOverEpoch();  // this also increments the acceptingEpoch
}
```

2. If the votes in the current `acceptingEpoch` are not sufficient to postconfirm a superBlock, and the `acceptingEpoch` is less than the `currentEpoch`, the protocol progresses to the next epoch.

```solidity
if (!superMajorityReached(thisSuperBlockHeight) && getAcceptingEpoch() < presentEpoch) {
    rollOverEpoch();  // this also increments the acceptingEpoch
}
```

> :warning: Close to the epoch border there should be some buffer. Otherwise the protocol rolls over too early.

This step protects against liveness issues through inactive validators by taking advantage of the L1 clock. For more on this consult [MD-117](https://github.com/movementlabsxyz/MIP/pull/117). The current `acceptingEpoch` has not been live and should be skipped.

#### Acceptor

An acceptor provides the postconfirmation functionality and rolls over the epoch. In order to allow for sufficient time for honest validators to provide their commitments, the postconfirmation for a given commitment SHOULD be delayed.

Every interval `acceptorTerm` one of the validators takes on the role to perform the Postconfirmation functionality. This acceptor is responsible for updating the contract state once a super-majority is reached for a commitment height. The acceptor is rewarded for this service, see the [Rewards section](#rewards). We note that this does not equate to a leader in a traditional consensus protocol, as the acceptor does not propose new states. Its role can also be taken over by a [volunteer-acceptor](#volunteer-acceptor).

> :bulb: We separate the acceptor from the validators to achieve separation of concerns and simplify the reward mechanism for the validators. This addresses [MD-4:D1](https://github.com/movementlabsxyz/MIP/tree/l-monninger/gas-offset/MD/md-4).

The acceptor MUST be selected via L1-randomness and weighted by the stake. The randomness MAY be provided through L1Block hashes, which can be considered sufficiently random, initially. Alternative higher-quality randomness from L1 SHOULD be considered.

```solidity
function getCurrentAcceptor() public view returns (address) {
  uint256 currentL1BlockHeight = block.number;
  // deduct finalizationBlockDepth because we should only consider finalized L1 blocks
  uint256 relevantL1BlockHeight = currentL1BlockHeight - (currentL1BlockHeight / acceptorTerm ) -  finalizationBlockDepth; 
  bytes32 blockHash = blockhash(relevantL1BlockHeight);
  return = getAcceptorFromL1Randomness(blockHash);

function getAcceptorFromL1Randomness(bytes32 blockHash) internal view returns (address) {
  // Implement logic to get the acceptor from the L1 randomness
  // and that considers the stake.
}
```

#### Volunteer-acceptor

The acceptor is supposed to update the contract state once enough votes are collected for the lowest unconfirmed commitment height. However, if the acceptor does not update the contract state for `acceptorLivenessWindow` the protocol allows for a volunteer-acceptor to provide the service.

The first volunteer-acceptor to provide the service of the acceptor after elapse of the liveness window will be accepted and receives the reward for the service, see [Rewards](#rewards). This is a liveness measure.

#### Rewards

**Validators** are rewarded for their service. The reward is calculated proportional to the validator stake and activity. The reward is issued in the next epoch.

The **acceptor** is rewarded for the service. The reward is calculated proportional to the activity. The reward is issued in the next epoch. 

The **volunteer-acceptor** is rewarded for their service (the acceptor must have missed the liveness window `acceptorLivenessWindow`).

```solidity
function rewardAcceptor(address acceptor) internal {
    uint256 reward = calculateAcceptorReward(acceptor);
    // Check if the acceptor has missed the liveness window
    if (!getCurrentAcceptor() == acceptor) {
        require(hasAcceptorMissedLivenessWindow(), "Volunteer-acceptor can only be rewarded if the acceptor missed the liveness window");
    }
    // add the reward to the reward queue, which gets processed at the end of the next epoch
    addReward(acceptor, reward);
}

function hasAcceptorMissedLivenessWindow() internal view returns (bool) {
    uint256 lastActivity = getAcceptorLastActivity();
    uint256 currentTime = block.timestamp;
    return currentTime > lastActivity + acceptorLivenessWindow;
}

function getAcceptorLastActivity() internal view returns (uint256) {
    // This function should return the last recorded activity timestamp of the acceptor
    // Placeholder implementation, replace with actual storage retrieval
    return acceptorLastActivity;
}
```

#### (Optional) Slashing

With Postconfirmations alone nodes do not need to get slashed if they voted for an invalid commitment. Since only their first vote for a given height gets accepted by the contract, they cannot equivocate. More abstractly the L1 provides consensus on the votes. Slashing MAY be considered to prevent flooding the L1 contract with invalid commitments, however, this is also expensive for the adversary and at most causes additional cost to the acceptor.

> :bulb: Nodes MAY get slashed if it has been proven that the validator voted more than once for a given block height on L2. This is a security measure to protect against long-range attacks. However, this is part of the scope of [MIP-65: Fastconfirmations](https://github.com/movementlabsxyz/MIP/pull/65) and not Postconfirmations.

## Reference Implementation

A reference implementation for Postconfirmation is provided by MCR, see [here](https://github.com/movementlabsxyz/movement/tree/714831820d78b3910729a194cd0508fa1efd9aa9/protocol-units/settlement/mcr).

## Verification

## Appendix

## Changelog
