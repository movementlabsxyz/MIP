# MD-14: Bridge Should Use A More Secure Timelock
- **Description**: Provide formal structure for proposing non-trivial improvements to Movement.
- **Authors**: [Primata](mailto:primata@movementlabs.xyz)

## Overview

The Bridge is arguably the most important feature of an L2 and lately we have had a confusing approach to it. We might want to solidify our understanding of how it is to be used and the assumptions we rely on. Off-loading the Bridge Relayer from securing timestamps might be important here in terms of security and preventing it from being an attack vector.

## Definitions

* Timelock - Time delta between the current block time and the end-of-lock time.
* Bridge Relayer - formerly referred as the bridge service, it's the infrastructure utilized to have some form of synchronicity of the bridge request state. Single point of failure.
* Initiator Contract - Contract the user utilizes to initialze the bridge and the bridge relayer completes or refunds the user. Exists both on Ethereum and Movement.
* Counterparty Contract - Contract the user completes the bridge and the bridge relayer locks or cancels the bridge. Exists both on Ethereum and Movement.


## Desiderata

1. 
2.  Because it has to be lower than the Initiator Contract Timelock, whenever Timelock is consumed, it is consumed as `timelock`.
3. Definitely use timestamps for the sake of synchronicity between Ethereum and Movement.
4. Remove dependency of the Bridge Relayer on processing the desired timelock.

### D1: Initiator Contract Timelock is a constant or a modifiable state with a minimum time
**User Journey**: Whenever Timelock is consumed, it is consumed as `timelock * 2`. If a modifiable state, it should be at least 12 hours.

**Justification**: Because it has to be higher than the Counterparty Contract Timelock, `timelock * 2` is reasonable. A modifiable state should have some form to prevent malicious attacks. If lowering becomes a necessity, an upgrade to the contract will solve the issue. `timelock * 2` consumption also introduces a requirement from the design which stipulates that the initiator timelock has to be significantly higher than the counterparty to assure that a bridge transfer cannot be completed on the target chain and cancelled on the origin chain.

### D2: Counterparty Contract Timelock is a constant or a modifiable variable with a minimum time
**User Journey**: Bridge Relayer locks the bridge transfer on the Counterparty side. It does not specify the timelock. The timelock is specified by the timelock state or constant in the Ethereum Initiator Contract or Movement Initiator Contract.

**Justification**: Because it has to be higher than the Counterparty Contract Timelock, `timelock` is reasonable. A modifiable state should have some form to prevent malicious attacks. If lowering becomes a necessity, an upgrade to the contract will solve the issue. 

### D3: Use timestamps instead of block number
**User Journey**: This has already been agreed, but by using timestamp, there is no necessity to handle block.number parity between chains.

**Justification**: For cross bridge synchronocity between Ethereum and Movement which have very distinct block numbers and block settlement speed.

### D4: Remove dependency of the Bridge Relayer on processing the desired timelock.
**User Journey**: Bridge Relayer stops having any decision how the timelock timestamp. It is fully provided by the contracts and modules variables.

**Justification**: We are heavily relying on the Bridge Relayer's capabilities to not fail and this should make the Bridge Relayer less error prone.


**Guidance and suggestions**:

Ethereum contracts:
```
uint256 public timelock = 1 days;
...
function setTimelock (uint256 newTimelock) external onlyOwner {
  if (newTimelock < 12 hours) revert MinimumTimelockError();
  timelock = newTimelock;
}
```
Movement Modules:
```
struct BridgeConfig has key {
        moveth_minter: address,
        bridge_module_deployer: address,
        signer_cap: account::SignerCapability,
        timelock: u64
    }
...
move_to(resource,BridgeConfig {
            moveth_minter: signer::address_of(resource),
            bridge_module_deployer: signer::address_of(resource),
            signer_cap: resource_signer_cap,
            timelock: 12 hours
        });
```

handle consumption depending on the condition on if it's an initiator or a counterparty

## Errata
