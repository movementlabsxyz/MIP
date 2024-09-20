# MD-20: Bridge Swap Mechanism

**Description**: This MD outlines and proposes the mechanics for the swap to take place, as part of the lock-mint-swap Bridge Transfer.

## Overview

The Bridge uses a lock-mint-swap process to provide our users with native gas-paying L2 $MOVE for their locked L1 ERC20 $MOVE. This transfer occurs in one sequence for the user, within the timelock period. The Lock and Mint phases of the sequence have already been implemented and were proposed in [RFC40](https://github.com/movementlabsxyz/rfcs/tree/main/0040-atomic-bridge). Therefore, these parts of the sequence will not be discussed here, only referenced.

The total gas required on the initiator side and the computation of this amount will also not be discussed here, as it has already been explored in [MD-17](https://github.com/movementlabsxyz/MIP/blob/6722c67a8434de07c6612e46b5a023b63ad8dcbd/MD/md-17/README.md). This MD focuses solely on the swap step of L2 $MOVE. When a user transfers from L2 back to L1, the [AtomicBridgeCounterpartyMOVE.sol](https://github.com/movementlabsxyz/movement/blob/andygolay/atomic-bridge-initiator-move/protocol-units/bridge/contracts/src/AtomicBridgeCounterpartyMOVE.sol) simply withdraws the ERC20 $MOVE from the pool and issues it back to the user. Since ERC20 is not a native gas-paying asset like ETH, no swap is needed on L1 in this direction. However, a swap will occur on L2.

To summarize:
- **L1 -> L2**: Lock->Mint->Swap
- **L2 -> L1**: Swap->Lock->Mint

It is worth noting that the term "Mint" on L1 is slightly inaccurate. The L1 ERC20 MOVE is already minted before any transfers occur, so no L1 mint transaction takes place during a bridge transfer. However, a mint _does_ occur on L2. The L2 ERC20 MOVE is either _locked in the pool_ or _withdrawn from the pool_. We can continue using this language as it is common across the organization.

## Definitions

- **Bridge Relayer**: Infrastructure used to maintain the synchronization of bridge request states.
- **Initiator Contract**: Contract a user uses to initiate a bridge transfer.
- **Counterparty Contract**: Contract on the opposite chain used to complete a bridge transfer.
- **L2 $MOVE**: For clarity, the MOVE on L2. This token is equivalent in functionality and ability to the $APT token. It is the native token of L2 and is used to pay for transactions.
- **BRIDGE-FA**: The asset that is minted and deposited into the user's account before the swap occurs. It is an Aptos [Fungible Asset](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/fungible_asset.move).
- **L1 ERC20 $MOVE**: The ERC20 Move token on Ethereum (L1).
- **Pool**: A holding place for assets or state data in the contract on either L1 or L2.

## Desiderata

### 1. Seamless Acquisition of L2 $MOVE on Completion of Transfer

- **User Journey**: After a transfer is initiated and the secrets are revealed, the Bridge Relayer calls `complete_bridge_transfer`. At this point, the bridge move module mints the `BRIDGE-FA`, a temporary holding asset used to swap for L2 $MOVE.
- **Justification**: Using the BRIDGE-FA provides a clean API and audited safety features. Furthermore, it has already been implemented. The prior implementation was called `MOVETH`, but the source code is the same. [MOVETH.move source code](https://github.com/movementlabsxyz/movement/blob/main/protocol-units/bridge/move-modules/sources/MOVETH.move). The [atomic_bridge_counterparty.move](https://github.com/movementlabsxyz/movement/blob/main/protocol-units/bridge/move-modules/sources/atomic_bridge_counterparty.move) module makes calls to the FA module.

### 2. Safe and Secure Access to L2 $MOVE Pool

- **Justification**: The Bridge Relayer keys should not have access to the $MOVE pool. If they did, they could arbitrarily mint L2 $MOVE, effectively offsetting the balance between L1 ERC20 $MOVE and L2 $MOVE, potentially incurring huge losses for Movement Labs.

### 3. Gas Sponsorship for the L2 Swap

- **User Journey**: After a transfer from L1 to L2 is completed, the user expects to receive L2 $MOVE equivalent to the ERC20 $MOVE that was transferred into their Movement Wallet.
- **Justification**: At the initial step of the swap (when the transfer is completed on Movement L2), the user requires some L2 $MOVE to execute the swap transaction.

### 4. Fallback Mechanism for Failed Swaps

- **User Journey**: The user is waiting for their transfer to complete. There is an AWS outage, and our relayer goes down. This happens after the transfer is completed, but the Swap TX was never called.
- **Justification**: The swap could fail for several reasons, such as connectivity or liveness issues. In such cases, a suitable mechanism should be implemented to retry or refund the swap.

## Guidance and Suggestions

At the earliest stage of the L1 to L2 transfer, the Bridge Relayer service should transfer some of its owned L2 $MOVE to the user associated with the recipient on the `bridgeTransferId`, **IF** the user does not already possess L2 $MOVE. This is the sponsored transaction, and it should be a very nominal amount.

The safest and most secure way to implement the swap step of the Transfer sequence is to maintain the pattern already implemented in the atomic bridge contracts. Namely, the bridge counterparty module mints an `FA` and gives it to the user.

Currently, in the `atomic_bridge_counterparty.move` module, the FA asset is given to the user, and that is the end of the Transfer. This is where the Swap step occurs.

### Example Cases

#### L1 -> L2

1. The user transfers 10 L1 ERC20 $MOVE.
2. Upon calling `lock_bridge_transfer` on `atomic_bridge_counterparty.move`, 0.42 L2 $MOVE is deposited _from_ the Bridge Relayer Account _to_ the User Account.
3. The transfer is initiated, and the lock and secret reveal steps are completed.
4. `complete_bridge_transfer` is called on `atomic_bridge_counterparty.move` by the Bridge Relayer service.
5. The user now has 10 BRIDGE-FA tokens and 0.42 L2 $MOVE.
6. A new function `swap_asset` on `atomic_bridge_counterparty.move` is called:
    - The `swap_asset` swaps the 10 BRIDGE-FA tokens for L2 $MOVE, paying for the transaction with the user's 0.42 L2 $MOVE.
    - The `swap_asset` must make a call to _an_external_pool_ of L2 $MOVE.
    - After the withdrawal of L2 $MOVE, the 10 BRIDGE-FA tokens are _burned_.
7. The user now has 10 $MOVE.

#### L2 -> L1

1. The user transfers 10 L2 $MOVE.
2. NOTE: The user **must** have enough extra L2 $MOVE to pay for the swap transaction. In other words, we sponsor transactions only _onto the L2_, not _onto the L1_.
3. A new function `swap_asset` on `atomic_bridge_initiator.move` is called:
    - The `swap_asset` swaps the 10 L2 $MOVE for 10 BRIDGE-FA tokens.
    - 10 BRIDGE-FA tokens are minted.
4. The `initiate_bridge_transfer` on `atomic_bridge_initiator.move` can now be called.
5. The rest of the transfer sequence is carried out as currently implemented.
6. The user acquires 10 L1 ERC20 MOVE on Ethereum.

### Required components and functions 

1. `swap_asset` on `atomic_bridge_counterparty.move`
2. `swap_asset` on `atomic_bridge_initiator.move`
3. `TopUp` component on Bridge Relayer. A CLI addition, that allows the bridge operator to Top Up $MOVE for sponsored transactions. This can be a manual
step for now, to automate it will be trivial. 
4. `RetryOrRefund` In the case that a swap failed, the Bridge Relayer needs the logic to decide whether it is necessary to Retry or Refund. I would suggest: Try 3 times. If fail, refund to L1.

## Open Questions

How the user pays for L1 Gas (ETH) in the L2 to L1 case is still open and has been proposed in [MD-17](https://github.com/movementlabsxyz/MIP/blob/6722c67a8434de07c6612e46b5a023b63ad8dcbd/MD/md-17/README.md).

