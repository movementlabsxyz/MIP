# Primitive
The Primitive stage of the roadmap is focused on the development and testing of implementations of FFS which are decoupled from Movement Lab's full node logic or any particular VM. This primarily means cleaning up existing proof of concept implementations, proving their correctness, and designing a more modular API. The initial implementation [Baker Confirmations (ZK-FFS)](../README.md) also begins under this stage.

## Key Deliverables

### contract-based `ffs`
1. MCR
1. Acceptor Features Upgrade:
    - **Acceptor Stake Feature:** Adds a stake requirement to the acceptor role.
    - **Volunteer Acceptor Feature:** Determines whether volunteers can perform the acceptor role.
    - **Acceptor Election Feature:** Performs on-chain election of the acceptor per epoch.
    - **Acceptor Client:** Adds dedicated logic for the acceptor role to the client.
1. MCR Client Distribution