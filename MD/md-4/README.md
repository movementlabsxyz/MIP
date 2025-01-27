# MD-4: MCR Offsetting Gas Costs

- **Description**: Provide models for the game theory of offsetting gas costs in MCR.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)


## Overview
In the current MCR implementation, the last attester which trips the `rollOverEpoch` function may pay large gas fees, as they perform roll-over work for previous participants, see also [this document](./rollover-gas.md). This would create a disincentive for the last attester to participate in the game, potentially not doing so at all. It has been presumed that the implementation would be updated s.t. the last attester would be specially rewarded for their work. This also creates a game-theoretic problem, as the last attester could be incentivized to wait until the last moment to participate.

To combat this, round-robin rewarding and commitment schemes such as Pedersen Commitments have been suggested. However, these have not been formalized.

## Desiderata

### D1: Model for Gas Costs in MCR without Offset
**User Journey**: A researcher or protocol implementer can understand the game theory of gas costs in MCR **without** cost offsetting.

**Justification**: The current implementation of MCR does not offset gas costs for the last attester. This could lead to a disincentive to participate in the game. We require a model which allows to study this.

**Recommendations**:
- Start with [Rollover Gas](./rollover-gas.md) to understand the current state of the problem.

### D2: Model for Gas Costs in MCR with Offset
**User Journey**: A researcher or protocol implementer can understand the game theory of gas costs in MCR **with** cost offsetting.

**Justification**: Naive proposals suggest offsetting the gas cost by rewarding the last attester transparently can alleviate some of the issue. Provide a model which demonstrates the game theory of this.

### D3: Models for Information Incomplete Gas Cost Offset
**User Journey**: A researcher or protocol implementer can understand the game theory of gas costs in MCR with incomplete information.

**Justification**: Information incompleteness may improve the game theory of offsetting gas costs. Provide models which demonstrate this for incompleteness derived from (1) general network latency, (2) a round-robin rewarding scheme, and (3) a Pedersen Commitment scheme.

## Changelog
