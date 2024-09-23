# MIP-20: Bridge Swap Mechanism

- **Description**: This MIP outlines the mechanics for the swap step in the lock-mint-swap Bridge Transfer process.
- **Authors**: [Richard Melkonian]
- **Desiderata**: [MD-20](https://github.com/movementlabsxyz/MIP/blob/c81cfe0f433354461332b13897b5335849223da3/MD/md-20/README.md)

## Abstract

This MIP proposes the swap mechanics in the lock-mint-swap Bridge Transfer process for Movement technologies. The focus is on swapping L2 $MOVE as part of a bridge transfer, while the lock and mint phases have already been proposed in RFC40.

## Motivation

The lock-mint-swap process allows users to convert L1 ERC20 $MOVE to L2 native $MOVE seamlessly. However, the swap step requires formalization to ensure security, price efficiency, gas efficiency, and consistency across bridge transactions.

## Specification

### L1 to L2 Flow

1. **Lock -> Mint -> Swap**:
    - The user MUST lock their L1 ERC20 $MOVE via `AtomicBridgeCounterpartyMOVE.sol`.
    - The L2 bridge module MUST mint BRIDGE-FA tokens.
    - The BRIDGE-FA tokens MUST be swapped for L2 $MOVE on a decentralized exchange (DEX) on L2. This ensures that the price of L2 $MOVE remains aligned with the price of L1 ERC20 $MOVE.
    - The swap MUST be facilitated via a DEX to ensure price parity between L1 and L2 MOVE tokens.

2. **L2 to L1 Flow**:
    - For the transfer from L2 back to L1, the user SHOULD initiate the process by swapping L2 $MOVE for BRIDGE-FA tokens.
    - On L1, a DEX SHOULD be used to swap the wrapped $MOVE back to ERC20 $MOVE, ensuring price efficiency between the L1 and L2 MOVE markets.

### Trusted Relayer Service

- The Bridge Relayer service MUST be a trusted service responsible for calling the necessary contract functions to complete the swap.
As a trusted service, it MUST ensure security and consistency, and thus transaction verification SHOULD NOT be required. The relayer MUST have restricted permissions and can only call certain functions on the contracts, mitigating potential security risks.
Fraudulent transactions would NOT be executed due to the restricted, only-owner functions, ensuring that only the designated trusted relayer has the authority to interact with the critical swap and bridge logic.

### Gas Sponsorship and Security Considerations

- The Bridge Relayer service MUST sponsor gas for the L2 swap transaction. It SHOULD provide a small amount of L2 $MOVE to the user, if the user has none, ensuring they can execute the swap on the DEX.

### Fallback Mechanism

- In cases where the swap fails due to network or relayer issues, a fallback mechanism MUST retry the transaction or issue a refund if multiple attempts fail.

## Reference Implementation

1. Implement `swap_asset` function in the `atomic_bridge_counterparty.move` contract for the L2 DEX swap.
2. Implement a similar `swap_asset` function on the L1 side to swap the wrapped MOVE for ERC20 $MOVE using a DEX.
3. Fork an Aptos DEX like liquidswap, deploy it, and provide liquidity for both sides of the swap MOVE and BRIDGE-FA.
4. Fork an ETH DEX like sushiswap (or a simpler alternative), provide liquidity for both sides of the swap BRIDGE-TOKEN and ERC20-MOVE.

## Verification

- The bridge transfer process SHOULD NOT require additional transaction verification due to the use of a trusted relayer service.
- Price efficiency between L1 and L2 MOVE MUST be maintained by using decentralized exchanges on both layers.

## Errata

None at this time.

## Appendix

- [RFC40](https://github.com/movementlabsxyz/rfcs/tree/main/0040-atomic-bridge)
- [MD-17](https://github.com/movementlabsxyz/MIP/blob/6722c67a8434de07c6612e46b5a023b63ad8dcbd/MD/md-17/README.md)
