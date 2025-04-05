# MD-118: Describe the implications of L1 assumptions for the Postconfirmation protocol

- **Description**: Postconfirmations are an anchoring mechanisms for the L2 protocol. Safety and liveness assumptions depend thus on the L1. This desideratum requests to explain the implications of L1 assumptions for the Postconfirmation protocol.
- **Authors**: [Andreas Penzkofer]()
- **Approval**: <!--Either approved (:white_check_mark:) or rejected (:x:) by the governance body. To be inserted by governance. -->

## Overview

The L1 provides several properties, such as synchrony, safety, liveness, censorship resistance. However, these properties are subject to the correctness of certain assumptions. If these assumptions are violated, the L1 may not provide the desired properties and the Postconfirmation protocol may fail.

Protocols should describe, what are the assumptions on the L1, and how it behaves given these assumptions DO NOT hold.

## Desiderata

### D1: The properties of the L1 must be clearly stated

**User journey (Operator)**: An operator wants to deploy a Postconfirmation protocol. It must understand, what properties the L1 provides and under what conditions these properties hold.

**Recommendations**:
Consider the following properties of the L1:

- Synchrony
- Safety
- Liveness
- Censorship resistance

### D2: The properties that derive from the L1 for the Postconfirmation protocol must be clearly stated, IF the L1 does fulfill the assumptions

**User journey (Operator)**: An operator wants to deploy a Postconfirmation protocol. They must understand, what properties are derived from the L1 for the Postconfirmation protocol, if the L1 does fulfill the assumptions.

**Recommendations**:
Consider the following properties that derive from the L1:

- Broadcast guarantees, such as when is a message from protocol participants considered broadcast and when delivered.
- Finality guarantees, such as when a message is considered final.

### D3: The properties that derive from the L1 for the Postconfirmation protocol must be clearly stated, IF the L1 does NOT fulfill the assumptions

**User journey (Operator)**: An operator wants to deploy a Postconfirmation protocol. They must understand, how the protocol behaves if the L1 does NOT fulfill one of the assumptions for the L1 holds.

**Recommendations**:

- address how the guarantees explored in #D2 are impacted by the violation of the assumptions.
- what happens if the finality of the L1 is violated and the ledger reverts to a previous state.

## Changelog
