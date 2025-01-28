# MD-3: MCR : Commitment Delay, Network Partitions, and Asynchrony

- **Description**: Provide a model for MCR and suggest a mechanism for handling delayed commitments, network partitions and asynchrony.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)

## Overview

[MCR](https://github.com/movementlabsxyz/movement/tree/main/protocol-units/settlement/mcr) is an implementation of the Postconfirmation protocol [MIP-37](https://github.com/movementlabsxyz/MIP/blob/mip/MCR/MIP/mip-37/README.md), which is a stake-based settlement protocol on L1.

In it's [current form](https://github.com/movementlabsxyz/movement/tree/baa83356a14d44fd4e8346e1eddfc184cebc17d3/protocol-units/settlement/mcr), it does not account for commitment delays, network partitions, or asynchrony.

Here we will consider commitment delays and network partitions, as all forms of asynchrony with which we are concerned can be modeled as such. For example, a node that is not technically offline but that cannot commit to the current block height, could just be exposed to asynchronous delays. However we can model this by assuming a partition.

### Challenges with the current model

In the initial implementation (see, e.g., at this [commit](https://github.com/movementlabsxyz/movement/tree/baa83356a14d44fd4e8346e1eddfc184cebc17d3/protocol-units/settlement/mcr)), once $\frac{2}{3}$ of the active stake is reached the state gets commited. Currently, there is no model for slashing or rewarding. Thus, not being successful in this type of race is not disadvantageous (neither directly for inactivity nor lack of rewards). However, obviously rewards (and slashing) are necessary to incentivize participation.

With the introduction of rewards well connected nodes may have a higher rate of rewarded commitments, which could lead to a rapid centralization of the network. Moreover, network partitions forced by an adversary could lead to further centralization.


These and other phenomena are listed in the desiderata below.

## Desiderata

### D1: Assess impact of network partitions and delays

**User Journey**: A researcher or protocol implementer can understand the impact of delays and network partitions.

**Justification**: It is important to understand the impact on the protocol from delays in commitments and network partitions. Network partitions can also describe a variety of asynchrony problems, such as DOS-attacks, network upgrades, and other forms of asynchrony.

### D2: Slashing conditions for lack of participation

**User Journey**: A researcher or protocol implementer can understand the impact of slashing conditions for lack of participation.

**Justification**: It has been proposed to slash participants for lack of participation. This could be a way to prevent inactivity, however such extreme slashing conditions come with their own risks.

**Recommendations**:
With the introduction of slashing conditions for lack of participation, a malicious actor could aim to partition the network, such that a subset of nodes struggle to provide their commitments (DOS-attack). See, for example, [Peer Attack in RFC-29](https://github.com/movementlabsxyz/rfcs/pull/29). Excessive penalization could lead to slashing of honest actors. It also could lead to an increase of the attackers proportion of total stake, further reducing the security. Introduction of such slashing conditions should be considered with caution.

### D3: Model Absent Commitments

**User Journey**: A researcher or protocol implementer can refer to a formal model for network partitions in MCR. This should support the derivation of the logic necessary to implement rewarding (and potentially slashing).

**Justification**: Network partitions effectively result in absent commitments to a given block height. While not changing the stake needed to agree on the height, rewards (and slashing) based on this absent commitment should be expected to impact behavior in the protocol.

**Recommendations**:

- Model the value of a node's commitment or absenteeism to the available voting options. This could then be adapted into a more complex model with shifting preferences.
- Model byzantine attack vectors such as DOS-attacks on honest participants.

### D4: Research and Design for Commitment Tolerance Window

It has been proposed that a tolerance window to commitment arrivals would soften the impact of delays.

**User Journey**: A researcher or protocol implementer can understand why a commitment tolerance window is necessary for MCR and why a particular design for this window was chosen.

**Justification**: Allowing participants to receive a reward (or omit) penalty) after the required stake has already committed to a given block height could prevent centralization and DOS-attacks.

**Recommendations**:
Consider the following parameters for the commitment tolerance window:

- Reward decay: a function describing the diminishing returns of rewards later in the window.
- Penalty decay: a function describing the increasing returns of penalties later in the window.

### D5: Address Asynchronous Upgrades, Fork Creation, and Fork Stake Problems

**User Journey**: A researcher or protocol implementer can understand the [Asynchronous Upgrades, Fork Creation, and Fork Stake Problems](./asychronous-upgrades-problem.md) and how they are addressed in MCR.

**Justification**: These are problems encountered under asynchrony and systems addressing asynchrony which if not addressed could bring down the network.

**Recommendations**:
Start by reviewing the [Asynchronous Upgrades, Fork Creation, and Fork Stake Problems](./asychronous-upgrades-problem.md).

## Changelog
