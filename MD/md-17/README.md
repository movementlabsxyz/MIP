# MD-17: Bridge Fees

Description: Bridges requires fees to assure it's not drained and can self-sustain its operations.

## Overview

Bridges require a sustainable fee mechanism to prevent abuse and ensure they can self-sustain operations. This proposal outlines a dynamic fee structure for both the Ethereum and Movement chains. On the Ethereum side, fees will adjust according to gas price volatility, while on the Movement side, an oracle service will monitor and update gas prices in real time.

## Definitions

- **Bridge Relayer**: Infrastructure used to maintain the synchronicity of bridge request states. A single point of failure.
- **Initiator Contract**: Contract that a user uses to initiate a bridge transfer, with the Bridge Relayer either completing or refunding the transfer.
- **Counterparty Contract**: Contract on the opposite chain used to complete a bridge transfer, with the Bridge Relayer locking or canceling the bridge transfer.
- **Gas**: The fee required to execute a transaction on the Ethereum or Movement network.
- **Priority Gas**: Additional gas fee paid to prioritize a transaction for faster processing on the Ethereum or Movement network.

## Desiderata

### 1. Dynamic Fee Adjustment on Ethereum

- **User Journey**: The Bridge Relayer checks the base gas cost on Movement every 30 seconds. If the cost increases by 20%, the fee will increase by an additional 20% of the current price. If the cost decreases, it either decreases to the current price by an additional 20% of current price or reverts to the base cost.
- **Justification**: A dynamic adjustment mechanism is crucial for handling gas volatility on Ethereum, ensuring the fee structure remains fair while avoiding undercharging during high gas periods.

### 2. Oracle-Based Fee System on Movement

- **User Journey**: Movement will include an oracle service that checks gas prices on Ethereum every 5 seconds and updates the fee structure accordingly. The system should read from multiple node RPCs to ensure accurate and reliable data, with a fallback mechanism in case of node failure.
- **Justification**: Movement gas fees are expected to be relatively stable, but an oracle ensures that changes in gas prices on Ethereum are reflected promptly, preventing undercharging or overcharging.

### 3. Fallback Mechanism for Oracle Data

- **User Journey**: The oracle service will query a batch of nodes to get the current gas price. If a primary node fails, the system will automatically switch to a fallback node to maintain continuity in fee updates.
- **Justification**: Reducing reliance on a single node prevents potential disruptions in fee updates, enhancing the system’s robustness and reliability.

### 4. Gas and Priority Gas Property Exposure in Movement Blocks

- **User Journey**: The oracle will expose `eth_gas` and `eth_priority_gas` in Movement blocks as part of the block properties.
- **Justification**: Including gas properties in the block allows for easier tracking and adjustment of gas fees by other modules or smart contracts, ensuring transparency and real-time fee updates.

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
