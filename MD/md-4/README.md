# MD-4: Postconfirmation: gas costs and rewards

- **Description**: Provide models for the game theory of offsetting gas costs in MCR.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz), Andreas Penzkofer

## Overview

The Postconfirmation protocol [MIP-37](https://github.com/movementlabsxyz/MIP/blob/mip/MCR/MIP/mip-37/README.md) is a stake-based settlement protocol on L1. Postconfirmations confirm superBlocks, which are a sequence of L2Blocks.

**Postconfirmer**. Once 2/3 of the total stake has been accumulated, a special actor must trigger the Postconfirmation. This action consumes additional gas compared to the basic validator confirmations. Moreover, a special actor has to update the contract to a new epoch to update the stake of validators, which also consumes gas. We call this actor the Postconfirmer.

#### Challenges with the current approach

[MCR](https://github.com/movementlabsxyz/movement/tree/main/protocol-units/settlement/mcr) is an implementation of Postconfirmation. In it's [current form](https://github.com/movementlabsxyz/movement/tree/baa83356a14d44fd4e8346e1eddfc184cebc17d3/protocol-units/settlement/mcr), the last validator that is required to reach 2/3 of the total stake becomes the actor to postconfirm.

The current implementation of MCR does not offset gas costs for this validator. This could lead to a disincentive to participate in the game, as the accumulated stake approaches 2/3 of the total stake.

#### Challenges with the proposed solution

Naturally, it has been proposed to reward the Postconfirmer. However, this also creates game-theoretic problems, as validators could be incentivized to wait until the last moment to participate to gain that reward, which could increase the finality time of the protocol.

It has also been proposed to have the Postconfirmer selected through randomness obtained from the L1. This also could create a game-theoretic problems, as the Postconfirmer is, for example, in control of when to postconfirm. I.e., liveness is affected.

## Desiderata

### D1: Investigate gas costs in the Postconfirmation protocol and impact of rewards

**User journey**:
A researcher or protocol implementer can understand the game theory of gas costs without rewards for the Postconfirmation and similar tasks.

**Justification**:
The current implementation of MCR does not reward the last validator. This could lead to a disincentive to participate in the game. We require to analyze this.

**Recommendations**:
Start with [Rollover Gas](./rollover-gas.md) to understand the current state of the problem.

### D2: Provide a model for gas costs with rewards for Postconfirmation

**User journey**: A researcher or protocol implementer can understand the game theory with Postconfirmation reward.

**Justification**: Naive proposals suggest to reward the Postconfirmer transparently can alleviate some of the issue. Provide a model which demonstrates the game theory of this.

### D3: Provide models for when the validators are not omniscient about their expected rewards and costs

**User journey**:
A researcher or protocol implementer can understand the game theory of gas costs when  incomplete information.

**Justification**:
Information incompleteness may improve the game theory of costs and rewards. Provide models which demonstrate this for incompleteness derived from network latency, randomness in the rewards, and more.

## Changelog

2025-01-29: Add rollover-gas.md example for MCR
