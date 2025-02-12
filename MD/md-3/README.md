# MD-3: MCR under Network Partitions and Asynchrony

- **Description**: Provide a model for MCR and suggest a mechanism for handling network partitions and asynchrony.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Approval**: :white_check_mark:

## Overview
MCR provides a stake-based settlement mechanism used in Movement Lab's Suzuka Network. In it's current form, it does not take any steps to account for network partitions or, more generally, asynchrony.

Henceforth, we will simply refer to network partitions, as all forms of asynchrony with which we are concerned can be modeled as such. Even if a node is not technically offline, the remainder of this desiderata will be concerned with the case in which it is not able to commit meaningfully to the current block height.

It is important to account for network partitions in a manner consistent with the game theory of MCR. In the current implementation, a simple race is run to $\frac{2}{3}$ of the network's stake. Currently, there is no model for slashing or rewarding. So, not participating in that race to $\frac{2}{3}$ of the network's stake is not a meaningfully punished. Presuming there would be a reward for participating, this may create an incentive to run an unreliable node which may often fail to commit to the current block height.

The same condition could also be seen as an attack vector if rewards and punishments were in place. A malicious actor could aim to partition the network via generating conditions for fast commitment amongst certain nodes--perhaps via something similar to the [Peer Attack described in RFC-29](https://github.com/movementlabsxyz/rfcs/pull/29). This would allow their stake to increase via rewards while the targeted minority stake would be slashed. The attacker may be able to keep apply this attack until they have a majority of stake. 

These and other phenomena are listed in the desiderata below.

## Desiderata

<!--
  List out the specific desiderata. Each entry should consist of:

  1. Title: A concise name for the desideratum.
  2. User Journey: A one or two-sentence statement focusing on the "user" (could be a human, machine, software, etc.) and their interaction or experience.
  3. Description (optional): A more detailed explanation if needed.
  4. Justification: The reasoning behind the desideratum. Why is it necessary or desired?
  5. Recommendations (optional): Suggestions or guidance related to the desideratum.

  Format as:

  ### Desideratum Title

  **User Journey**: [user] can [action].

  **Description**: <More detailed explanation if needed (optional)>

  **Justification**: <Why this is a significant or required desideratum>

  **Recommendations**: <Any specific guidance or suggestions (optional)>

  TODO: Remove this comment before finalizing.
-->
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