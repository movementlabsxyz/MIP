# MD-118: Implications of L1 assumptions for the Postconfirmation protocol

- **Description**: Postconfirmations are an anchoring mechanisms for the L2 protocol. Safety and liveness assumptions depend thus on the L1. This desideratum requests to explain the implications of L1 assumptions and requirements on the L1 for the Postconfirmation protocol.
- **Authors**: [Andreas Penzkofer]()
- **Approval**: <!--Either approved (:white_check_mark:) or rejected (:x:) by the governance body. To be inserted by governance. -->

## Overview

The L1 provides several properties, such as synchrony, safety, liveness, censorship resistance. However, these properties are subject to the correctness of certain assumptions such as running a node on the L1. If these assumptions are violated, the L1 may not provide the desired properties and the Postconfirmation protocol may fail.

Protocols should describe, what are the assumptions on the L1, and how it behaves given these assumptions DO NOT hold.

## Desiderata

### D1: The properties of the L1 must be clearly stated

**User journey (Operator)**: An operator wants to deploy a Postconfirmation protocol. They must understand, what properties the L1 provides.

**Recommendations**:
Consider the following properties of the L1:

- Synchrony: at what intervals are messages broadcasted and finalized?
- Safety: under what conditions is the L1 safe?
- Liveness: is the protocol always live? What delays should be considered?
- Censorship resistance: can the L1 censor voting messages of the Postconfirmation protocol?

### D2: The requirements on the participants must be clearly stated

**User journey (Operator)**: An operator wants to deploy a Postconfirmation protocol. They must understand, what requirements the operator must fulfill to use the Postconfirmation protocol.

**Recommendations**:

- The operator must run a full node on the L1. The delay of reading the L1 state must be known and considered.
- The operator must run a full node on the L2. The delay of reading the L2 state must be known and considered.

### D3: Broadcast and finality assumptions

**User journey (Operator)**: An operator wants to deploy a Postconfirmation protocol. They must understand, when a message is considered broadcast, when delivered, when finalized.

**Recommendations**:

- Broadcast guarantees, such as when is a message from protocol participants considered broadcast and when delivered. It should be distinguished between 
  - the delivery to a validator set
  - the delivery to the L1
- Finality guarantees, such as when a message is considered final, see [A1](#a1-message-delivery-and-finality).

### D4: Behavior of protocol if L1 assumptions are violated.

**User journey (Operator)**: An operator wants to deploy a Postconfirmation protocol. They must understand, how the protocol behaves if the L1 does NOT fulfill one of the assumptions for the L1 holds.

**Recommendations**:

- What happens if the finality of the L1 is violated and the ledger reverts to a previous state. How does the Postconfirmation protocol behave? Are votes resubmitted?

## Appendix

### A1: L1 and Total Order Broadcast of votes

The Postconfirmation protocol is run as a smart contract on the L1. Messages from validators are only considered for the state transition once they are executed on the L1. Since the L1 guarantees broadcast to all participants, accepted votes have total order broadcast properties, provided the L1 is safe.

Votes from validators SHOULD not be considered as long as they are only in the mempool of the L1. They impact the state of the postconfirmation protocol after they are included in a block.

Postconfirmations should not be counted until they are finalized. Finalization typically occurs when more than 2/3 of the validators of the L1 protocol have finalized the block that contains the vote. Since we only account for postconfirmations that are finalized, votes really only matter once postconfirmations are finalized.

> [!NOTE] We may consider that the votes have total order broadcast properties.

Note that here we specifically mean finalization, which is stronger than confirmations in Ethereum, where a confirmation can be inclusion in a block and which could get reverted.

## Changelog
