# MD-20: Bridge Swap Mechanism 

Description: This MD outlines a proposes the mechanics for the swap to take place, as part of the lock-mint-swap Bridge Transfer. 

## Overview

The Bridge uses a lock-mint-swap process in order to give our users native gas paying L2 $MOVE for their locked L1 ERC20 $MOVE. This transfer happens for the user in one sequence, within the timelock period.
The Lock and Mint phases of the sequence have already been implemented and were proposed in [RFC40](https://github.com/movementlabsxyz/rfcs/tree/main/0040-atomic-bridge).
Therefore, these parts of the sequence will not be discussed here, but only referenced. 

The total Gas required on the initiator side and the computation of this amount will also not be discussed here and has already been explored as part of [MD-17](https://github.com/movementlabsxyz/MIP/blob/6722c67a8434de07c6612e46b5a023b63ad8dcbd/MD/md-17/README.md)
This MD deals only with the swap step of L2 $MOVE. When a user transfers from the L2 back to the L1, the [AtomicBridgeCounterpartyMOVE.sol](https://github.com/movementlabsxyz/movement/blob/andygolay/atomic-bridge-initiator-move/protocol-units/bridge/contracts/src/AtomicBridgeCounterpartyMOVE.sol) simply withdraws the ERC20 $MOVE from the pool and issues 
it back to the user. Because the ERC20 is not native gas paying ETH no swap on the L1 needs to occur in this direction. However, a swap will occur on the L2.

To summarise:
L1 -> L2 : Lock->Mint->Swap 
L2 -> l1 : Swap->Lock->Mint

It is worth highlighting, that the term Mint on the L1 is slightly innacurate. The L1 ERC20 MOVE is already minted prior to any transfers, no L1 mint transaction ever takes place during a bridge transfer. However, a mint _does_ occur on the L2. 
The L2 ERCO Move is only ever ether _locked in the pool_ or _withdrawn from the pool_. But, we can continue with this language as its used across the org.

## Definitions

- **Bridge Relayer**: Infrastructure used to maintain the synchronicity of bridge request states.
- **Initiator Contract**: Contract that a user uses to initiate a bridge transfer .
- **Counterparty Contract**: Contract on the opposite chain used to complete a bridge transfer. 
- **L2 $MOVE**: For the sake of clarity, the MOVE on the L2. This token is equivalent in functionality and ability than the the $APT token. It is the native token of the L2 and used to pay gas for transactions.
- **BRIDGE-FA** This is the asset that is minted and deposited in the user's account before the swap occurs. It is an Aptos [Fungible Asset](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/fungible_asset.move).
- **L1 ERC20 $MOVE**: The ERC20 Move on Ethereum, The L1.
- **Pool** A holding place for assets, state data in the contract on either the L1 or the L2.

## Desiderata

### 1. Seamless acquisition of L2 $MOVE on completion of Transfer 

- **User Journey**: After a transfer is initiated and the secrets are revealed, the Bridge Relayer calls `complete_bridge_transfer`. At this point the bridge move module mints the `BRIDGE-FA`. 
This is a temporary holding asset that is used to SWAP for the L2 $MOVE.
- **Justification**: Using the BRIDGE FA provides a clean API and audited safety features. Furthermore it has already been implemented, the prior implementation was called `MOVETH`, but the Source Code is the same.
[MOVETH.move source code](https://github.com/movementlabsxyz/movement/blob/main/protocol-units/bridge/move-modules/sources/MOVETH.move). The [atomic_bridge_counterparty.move](https://github.com/movementlabsxyz/movement/blob/main/protocol-units/bridge/move-modules/sources/atomic_bridge_counterparty.move) module makes calls to the FA module. 

### 2. Safe and Secure access of L2 $MOVE pool 

- **Justification**: The Bridge Relayer keys should not have access to the $MOVE pool. If it were to, then it would be able to arbitrarily mint L2 $MOVE, effecitvely off-setting the balance between L1 ERC20 $MOVE  and L2 £$MOVE. 
Thereby incurring potentially huge loss for Movement Labs.

### 3. Gas Sponsorship for the L2 Swap  

- **User Journey**: After a transfer from the L1 -> L2 is completed the user exepcts L2 $MOVE equivalent to the ERC20 $MOVE that was transferred in their Movement Wallet. 
- **Justification**: At the zeroth step of the swap (when the transfer has completed on Movement L2), the user requires some L2 $MOVE, in order to execute the swap transaction. 

### 4. Fallback mechanism for failed swaps 

- **User Journey**: The user is await for their transfer to complete. There is an AWS outage and our relayer goes down. This happens after a transfer was completed. But the Swap TX was never called. 
- **Justification**: The swap could fail for a number of reasons for exanmple: connectivity, liveness. In these cases a suitable mechanism should be implemented in order to retry or refund.   

## Guidance and Suggestions

At the earliest stage of the L1 -> L2 transfer the Bridge Relayer service should transfer some of its owned L2 $MOVE to the user associated with recipient on the `bridgeTransferId` **IF** the user does not already acquire L2 $MOVE.
This is the sponsored transaction. This should be a very low and nominal amount. 

The safest and securest way to implement the swap step of the Transfer sequence is to maintain the pattern already implemented in the atomic bridge contacts. Namely, the bridge counterparty module mints an `FA` and gives that to the user. 

Currently in the `atomic_bridge_counterparty.move` module, the FA asset is given to the user and that is the end of the Transfer. This is where the Swap step occurs. 

### Example Cases 

L1 -> l2

1. The User transferred 10 L1 ERC20 $MOVE. 
2. Upon calling `lock_bridge_transfer` on `atomic_bridge_counterparty.move` 0.42 L2 $MOVE is deposited _from_ Bridge Relayer Account _to_ the User Account. 
2. The transfer was initiated and the lock and secret reveal steps complete.
3. `complete_bridge_transfer` has been called on `atomic_bridge_counterparty.move` by the Bridge Relayer serivce. 
4. The user now has 10 BRIDGE-FA token  and 0.42 L2 $MOVE. 
5. A new funcion `swap_asset` on `atomic_bridge_counterparty.move` is called. 
  - The `swap_asset` swaps the 10-BRIDGE-FA token for L2 $MOVE paying for the tx with their 0.42 L2 $MOVE. 
  - the `swap_asset` must make a call to _an_external_pool_ of L2 $MOVE.
  - After withdrawal of L2 $MOVE the 10-BRIDGE-FA is _burned_.
6. The user has 10 $MOVE

L2 -> L1

1. The User transfers 10 L2 $MOVE
2. NOTE: The User **must** have enough extra L2 $MOVE to pay for the swap tx. In other words, we sponsor transaction only _on to the L2_ not _on to the L1_.
3. A new function `swap_asset` on `atomic_bridge_initiator.move`.is called.
  - The `swap_asset` swaps the 10 L2 $MOVE for 10-BRIDGE-FA 
  - 10 BRIDGE-FA is minted.
4. The `initiate_bridge_transfer` on `atomic_bridge_initiator.move` can now be called.
5. The rest of the transfer sequence is carried out as it is currently implemnted. 
6. The User acquires 10 L1 ERC20 MOVE on Ethereum. 

## Open Questions
How the user pays for L1 Gas (ETH) in the L2 -> L1 case is still open and has been proposed in in [MD-17](https://github.com/movementlabsxyz/MIP/blob/6722c67a8434de07c6612e46b5a023b63ad8dcbd/MD/md-17/README.md)

