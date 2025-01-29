# MD-3: Postconfirmation : Commitment Delay, Network Partitions, and Asynchrony

- **Description**: Consider delays, network partitions and asynchrony. And address how rewards and slashing conditions impact these.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz), Andreas Penzkofer

## Overview

The Postconfirmation protocol [MIP-37](https://github.com/movementlabsxyz/MIP/blob/mip/MCR/MIP/mip-37/README.md) is a stake-based settlement protocol on L1.

Since it is a decentralized protocol we have to account for

- commitment delays
- network partitions
- asynchrony

#### Challenges with the current approach

[MCR](https://github.com/movementlabsxyz/movement/tree/main/protocol-units/settlement/mcr) is an implementation of Postconfirmation.

In it's [current form](https://github.com/movementlabsxyz/movement/tree/baa83356a14d44fd4e8346e1eddfc184cebc17d3/protocol-units/settlement/mcr), it does not account for effects on validators through commitment delays, network partitions, or asynchrony:

- once $\frac{2}{3}$ of the active stake is reached the state gets committed.
- rewards and slashing is not implemented. Thus, not being successful in this type of race is not disadvantageous. However, rewards (and potentially slashing) are necessary to incentivize participation.

#### Challenges with future approaches

**Introduction of rewards**. With the introduction of rewards well connected nodes may have a higher rate of rewarded commitments, which could lead to a rapid centralization of the network. Moreover, network partitions forced by an adversary could lead to further centralization.

**Introduction of slashing conditions**. Slashing conditions, similar to rewards, have significant impact on the protocol, which should be well understood before implementation.

## Desiderata

### D1: Assess impact of delays and network partitions

**User Journey**: A researcher or protocol implementer can understand the impact of delays and network partitions.

**Justification**: It is important to understand the impact on the protocol from delays in commitments and network partitions. Network partitions can also describe a variety of asynchrony problems, such as DOS-attacks, network upgrades, and other forms of asynchrony.

**Recommendations**:
We assume all forms of asynchrony with which we are concerned can be modeled through network partitions. For example, a node that is not technically offline but that cannot commit to the current block height, could just be exposed to asynchronous delays. However we can model this by assuming a partition.

### D2: Provide a model that considers absent commitments

**User Journey**: A researcher or protocol implementer can refer to a formal model that describes the impact of absent commitments. Furthermore, rewards and slashing conditions should be considered.

**Justification**: Network partitions effectively result in absent commitments to a given block height. While not changing the stake needed to agree on the height, it may impact liveness or hinder certain validators to commit. Rewards (and slashing) based on this absent commitment should be expected to impact behavior in the protocol. The model would support the derivation of the logic necessary to implement rewarding (and potentially slashing).

**Recommendations**:

- Model the value of a node's commitment or absenteeism to the available voting options.
- Model byzantine attack vectors such as DOS-attacks on honest participants.

### D3: Consider slashing conditions for lack of participation

**User Journey**: A researcher or protocol implementer can understand the impact of slashing conditions for lack of participation. And whether it is necessary to introduce such conditions.

**Justification**: It has been proposed to slash participants for lack of participation. This could be a way to prevent inactivity, however such extreme slashing conditions come with their own risks.

**Recommendations**:
With the introduction of slashing conditions for lack of participation, a malicious actor could aim to partition the network, such that a subset of nodes struggle to provide their commitments (DOS-attack). See, for example, [Peer Attack in RFC-29](https://github.com/movementlabsxyz/rfcs/pull/29). Excessive penalization could lead to slashing of honest actors. It also could lead to an increase of the attackers proportion of total stake, further reducing the security. Introduction of such slashing conditions should be considered with caution.

### D4: Research Commitment Tolerance Window

It has been proposed that a tolerance window to commitment arrivals would soften the impact on validators for delays they experience.

**User Journey**: A researcher or protocol implementer can understand why a commitment tolerance window is necessary and why a particular design for this window was chosen.

**Justification**: Allowing participants to receive a reward after the required stake has already committed to a given block height could prevent centralization and DOS-attacks.

**Recommendations**:
Consider the following parameters for the commitment tolerance window:

- Commitment happens only after some time has passed, forcing some degree of synchronization.
- Reward decay: a function describing the diminishing returns of rewards later in the window.

## Changelog
