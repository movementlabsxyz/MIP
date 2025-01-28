# MD-3: MCR under Network Partitions and Asynchrony

- **Description**: Provide a model for MCR and suggest a mechanism for handling network partitions and asynchrony.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)

## Overview
MCR is an implementation of the Postconfirmation protocol [MIP-37](https://github.com/movementlabsxyz/MIP/blob/mip/MCR/MIP/mip-37/README.md), which is a stake-based settlement protocol on L1.

In it's current form, it does not take any steps to account for network partitions or, more generally, asynchrony.
Here we will only consider network partitions, as all forms of asynchrony with which we are concerned can be modeled as such. For example, a node that is not technically offline but that cannot commit to the current block height, could just be exposed to asynchronous delays. However we can model this by assuming a partition.

### Example

In the following we describe an example of where network partition is relevant.

In the initial implementation (see, e.g., at this [commit](https://github.com/movementlabsxyz/movement/tree/baa83356a14d44fd4e8346e1eddfc184cebc17d3/protocol-units/settlement/mcr)), a **race is run** to reach $\frac{2}{3}$ of the network's stake, after which the state is committed.

Currently, there is no model for slashing or rewarding. Thus, not being successful in that race to $\frac{2}{3}$ of the network's stake is not punished (neither directly for inactivity nor lack of rewards).

First, with **rewards for participating** (but no punishment for lack of participation) well connected nodes may have a higher rate of participation, which could lead to a rapid centralization of the network. Moreover, forced network partitions could lead to further centralization.

Second, with the introduction of **slashing conditions** for lack of participation, a malicious actor could aim to partition the network, such that a subset of nodes struggle to provide their commitments (DOS-attack). See, for example, [Peer Attack in RFC-29](https://github.com/movementlabsxyz/rfcs/pull/29). Excessive penalization could lead to slashing of honest actors. It also could lead to an increase of the attackers proportion of total stake, further reducing the security.

These and other phenomena are listed in the desiderata below.

## Desiderata


### D1: Model for Network Partitions as Absent Commitments to MCR

**User Journey**: A researcher or protocol implementer can refer to a formal model for network partitions in MCR, ultimately deriving from it the logic necessary to implement slashing and rewarding. 

**Justification**: Network partitions effectively result in absent commitments to the current block height. While not changing the stake needing to agree on the current height, the slashing or rewarding based on this absent commitment should be expected to impact behavior in the repeated game of MCR.

**Recommendations**:
- A simple way to approach would be to model the value of a node's commitment or absenteeism to honest-agreeing, honest-disagreeing, dishonest-agreeing, and dishonest-disagreeing participants. This could then be adapted into a more complex model with shifting preferences. 
- The literature on absenteeism in repeated games is generally a bit sparse and particularly so--on first review--for topics in computer science.

### D2: Research and Design for Commitment Tolerance Window

**User Journey**: A researcher or protocol implementer can understand why or why not a commitment tolerance window is necessary for MCR and why a particular design for this window was chosen.

**Justification**: It has been proposed that a commitment tolerance window would soften network partitions. That is, allowing participants to receive a reward or penalty after the needed stake has committed to the current block height could prevent the kind kind of stake drift and attacks described above.

**Recommendations**:
- Consider the following parameters for the commitment tolerance window: 
  - Reward decay: the function describing the diminishing returns of rewards later in the window.
  - Penalty decay: the function describing the increasing returns of penalties later in the window.
  - Vote decay: the function describing the diminishing returns of votes later in the window. This would only be useful if previous rounds of voting are considered in the current round.

### D3: Address Asynchronous Upgrades, Fork Creation, and Fork Stake Problems

**User Journey**: A researcher or protocol implementer can understand the [Asynchronous Upgrades, Fork Creation, and Fork Stake Problems](./asychronous-upgrades-problem.md) and how they are addressed in MCR.

**Justification**: These are problems encountered under asynchrony and systems addressing asynchrony which if not addressed would bring down the network.

**Recommendations**:
- Start by reviewing the [Asynchronous Upgrades, Fork Creation, and Fork Stake Problems](./asychronous-upgrades-problem.md).

## Changelog