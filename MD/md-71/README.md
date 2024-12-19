# MD-71: Informer service for the Lock/Mint-based Native Bridge
- **Description**: Provide a component that informs about the total circulating supply of \$MOVE across L1 and L2.
- **Authors**: [Author](mailto:andreas.penzkofer@movementlabs.xyz)

## Overview

Several components should react if the bridge is under attack or faulty. In particular, the considered components are the Insurance Fund, see [MIP-50](https://github.com/movementlabsxyz/MIP/pull/50) and the Rate Limiter, see [MIP-56](https://github.com/movementlabsxyz/MIP/pull/56), and more generally the governance operator.

The Operator that controls these components requires knowledge about the states of minted or locked tokens on L1 and L2. The Operator is an entity (e.g. multisig human) that has the ability to sign transactions and send funds from the Security Fund. Moreover, the operation of these components may also be handled via a governance, which could also rely on state information.

This MD requests to provide an informing service that satisfies the above.

## Desiderata

### D1: Provide information about the circulating supply on L2

On the L2 the bridge contract mints \$MOVE token when token should be transferred to L2. When tokens are transferred to L1, the user burns provably some tokens on L2. The Informer should learn about those two supplies and provide information about the current circulating \$MOVE supply on L2.

### D2: Provide information about the locked supply on L1

On the L1 the L1 bridge contract locks any \$MOVE token that should be transferred to L2 in a bridge pool. When \$MOVE token should be transferred to L1 the L1 bridge contract releases tokens held by the bridge pool. The operator should be informed about the locked amount.

### D3: Optional: Provide information about the inflight tokens

Provide information about the inflight tokens. This includes tokens that are not yet processed by the relayer, as well as tokens that are processed (i.e. the `complete` transaction is in a block on the target chain) but not yet finalized.

### D4: Define what it means for the Native Bridge to be secure

Based on the variables above the informer should derive a metric that can provide a warning if the metric seems incorrect. It has to be defined what means incorrect.

### D5: Explore implications if relayer does not utilize postconfirmations

The postconfirmation process is a synchronization mechanism for L2 to L1, see [MIP-37](https://github.com/movementlabsxyz/MIP/pull/37).

If the Relayer completes transfers from L2 to L1 without awaiting postconfirmation of the L2 `initiate` transaction, synchronization guarantees are reduced. The postconfirmation is an anchoring mechanism that binds the L2 to a certain L2 block height and hash, and hinders reorgs beyond a certain depth on L2.

We need to check the implications for the Informer if the Relayer ignores postconfirmations.

## Errata
