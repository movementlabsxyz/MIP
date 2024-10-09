# MIP-25: Proxy Aptos Framework for Stage 0 governance
- **Description**: Proxy Aptos Framework signing for stage 0 of the Movement network governance
- **Authors**: [Andy Bell](mailto:andy.bell@movementlabs.xyz)
- **Desiderata**: [MD-0](../MD/md-0)

## Abstract
This MIP describes a means by which during Stage 0 of the Movement network a signing key, single or multi, is able to manage the Aptos Framework without relying on the governance module included in the Aptos Framework.  This facilitating a more agile method in which Aptos Framework updates and modifications can be executed rapidly during this stage of the network.  This method would be deprecated in favour of decentralized governance in the future.

## Motivation
During Stage 0 of the Movement network Movement Labs would hold centralized control of the node and Aptos Framework.  In order to update or modify the Aptos Framework this would involve the deployment of new node binaries to operators in the network who would then upgrade.  One option to facilitate Aptos Framework upgrades is the use of the governance module which forms part of the Aptos Framework.  This, however, is not optimal for stage 0 of the network and the proposal here is to include a new module in the framework which proxies functions executed with the priviledges of the Aptos Framework.  Following a similiar strategy as the governance module but allowing voting to be circumvented with the use of a trusted multisig wallet held and managed by Movement Labs. 

## Specification
1. The Proxy module MUST be made available as part of the Aptos Framework.
2. A single or multi-signature MUST be required to temporarily acquire the signing privileges of the Aptos Framework.
3. Only one authorized key MUST be able to operate the Proxy module and acquire the signing privileges.
4. The controller key MUST be rotated, and the Proxy module MUST provide functionality to support key rotation.
5. Updates to the framework MUST use a Move script signed by the controller account to acquire the signing privileges of the Aptos Framework during the script's execution.
6. The controller account SHOULD be multisig, and this MUST be a strict requirement for the Proxy module. For testing purposes, this requirement MAY be relaxed to allow a single account.

## Reference Implementation
```rust
module aptos_framework::proxy {
    use std::signer;
    use aptos_framework::account::{create_signer_with_capability, SignerCapability};
    use aptos_framework::event;
    use aptos_framework::system_addresses;
    use aptos_framework::system_addresses::is_aptos_framework_address;
    friend aptos_framework::genesis;

    struct ProxyController has key {
        controller: address,
        aptos_framework_signer_cap: SignerCapability,
    }

    const EINVALID_CONTROLLER : u64 = 0x1;

    #[event]
    /// An event triggered when the controller is updated
    struct ControllerUpdated has store, drop {
        old_controller: address,
        new_controller: address,
    }

    /// Only called during genesis.
    public(friend) fun initialize(aptos_framework: &signer, aptos_framework_signer_cap: SignerCapability) {
        system_addresses::assert_aptos_framework(aptos_framework);

        move_to(aptos_framework, ProxyController {
            controller: @aptos_framework,
            aptos_framework_signer_cap,
        })
    }

    /// Update the controller of the proxy
    /// Aborts if signed by anyone else except the controller or @aptos_framework
    /// Emits an event on updating the controller
    public fun update_controller(signer: &signer, new_controller: address) acquires ProxyController {
        let proxy_controller = borrow_global_mut<ProxyController>(@aptos_framework);

        assert!(
            proxy_controller.controller == signer::address_of(signer) ||
            is_aptos_framework_address(signer::address_of(signer)),
            EINVALID_CONTROLLER);

        let old_controller = proxy_controller.controller;
        proxy_controller.controller = new_controller;

        event::emit(
            ControllerUpdated {
                old_controller,
                new_controller,
            },
        );
    }

    #[view]
    /// Return the controller of the proxy
    public fun get_controller(): address acquires ProxyController {
        borrow_global<ProxyController>(@aptos_framework).controller
    }

    /// Delegate Aptos Framework's signing cap to proxy
    public fun delegate_to_proxy(controller: &signer) : signer acquires ProxyController {
        let proxy_controller = borrow_global<ProxyController>(@aptos_framework);
        assert!(signer::address_of(controller) == proxy_controller.controller, EINVALID_CONTROLLER);
        create_signer_with_capability(&proxy_controller.aptos_framework_signer_cap)
    }
}
```

## Verification

## Errata

## Appendix
