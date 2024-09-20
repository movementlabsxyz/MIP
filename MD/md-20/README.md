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

### 1. Seamless aquisition of L2 $MOVE on completion of Transfer 

- **User Journey**: After a transfer is initiated and the secrets are revealed, the Bridge Relayer calls `complete_bridge_transfer`. At this point the bridge move module mints the `BRIDGE-FA`. 
This is a temporary holding asset that is used to SWAP for the L2 $MOVE.
- **Justification**: Using the BRIDGE FA provides a clean API and audited safety features. Furthermore it has already been implemented, the prior implementation was called `MOVETH`, but the Source Code is the same.
[MOVETH.move source code](https://github.com/movementlabsxyz/movement/blob/main/protocol-units/bridge/move-modules/sources/MOVETH.move)

### 2. Safe and Secure access of L2 $MOVE pool 

- **User Journey**: Movement will include an oracle service that checks gas prices on Ethereum every 5 seconds and updates the fee structure accordingly. The system should read from multiple node RPCs to ensure accurate and reliable data, with a fallback mechanism in case of node failure.
- **Justification**: The Bridge Relayer keys should not have access to the $MOVE pool. If it were to, then it would be able to arbitrarily mint L2 $MOVE, effecitvely off-setting the balance between L1 ERC20 $MOVE  and L2 £$MOVE. 
Thereby incurring potentially huge loss for Movement Labs.

### 3. Gas Sponsorship for the L2 Swap  

- **User Journey**: The oracle service will query a batch of nodes to get the current gas price. If a primary node fails, the system will automatically switch to a fallback node to maintain continuity in fee updates.
- **Justification**: At the zeroth step of the swap (when the transfer has completed on Movement L2), the user requires some L2 $MOVE, in order to execute the swap transaction. 

### 4. Fallback mechanism for failed swaps 

- **User Journey**: The oracle will expose `eth_gas` and `eth_priority_gas` in Movement blocks as part of the block properties.
- **Justification**: The swap could fail for a number of reasons for exanmple: connectivity, liveness. In these cases a suitable mechanism should be implemented in order to retry or refund.   

## Guidance and Suggestions

### Ethereum Contracts

```solidity
uint256 public bridgeFee;
uint256 public baseFee;

function initiateBridge(uint256 currentBridgeFee) external onlyOwner {
    if (currentBridgeFee < baseFee) {
        bridgeFee = baseFee;
    } else {
        bridgeFee = currentBridgeFee * 12 /10;
    }
}
```

### Movement Modules

```move
struct BridgeConfig has key {
    moveth_minter: address,
    bridge_module_deployer: address,
    signer_cap: account::SignerCapability,
    timelock: u64,
    base_eth_gas: u64,
    base_eth_priority_gas: u64,
}

move_to(resource, BridgeConfig {
    moveth_minter: signer::address_of(resource),
    bridge_module_deployer: signer::address_of(resource),
    signer_cap: resource_signer_cap,
    timelock: 12 hours,
    eth_gas: base_eth_gas,
    eth_priority_gas: base_eth_priority_gas
});

// initiate bridge calls charge the user based on the fee using block data
block.eth_gas
block.eth_priority_gas
```

## Errata
