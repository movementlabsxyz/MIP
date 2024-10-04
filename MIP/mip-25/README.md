# MIP-25: Proxy Aptos Framework for Stage 0 governance
- **Description**: Proxy aptos framework signing for stage 0 of the Movement network governance
- **Authors**: [Andy Bell](mailto:andy.bell@movementlabs.xyz)
- **Desiderata**: [MD-0](../MD/md-0)

## Abstract
This MIP describes a means by which during Stage 0 of the Movement network a signing key, single or multi, is able to manage the aptos framework without relying on the governance module included in the aptos framework.  This facilitating a more agile method in which aptos framework updates and modifications can be executed rapidly during this stage of the network.  This method would be deprecated in favour of decentralized governance in the future.

## Motivation
During Stage 0 of the Movement network Movement Labs would hold centralised control of the node and aptos framework.  In order to update or modify the aptos framework this would involve the deployment of new node binaries to operators in the network who would then upgrade.  One option to facilitate aptos framework upgrades is the use of the governance module which forms part of the aptos framework.  This, however, is not optimal for stage 0 of the network and the proposal here is to include a new module in the framework which proxies functions executed with the priviledges of the aptos framework.  Following a similiar strategy as the governance module but allowing voting to be circumvented with the use of a trusted multisig wallet held and managed by Movement Labs. 

## Specification
1. Proxy module is made available as part of the aptos framework
2. A single or multi signature would be required to acquire temporarily the signing priviledges of aptos framework
3. Only one authourized key would be able to operate the proxy module and acquire the signing priviledges
4. The key would be rotated and functionality would be provided in the proxy module to do so
5. Updates to the framework would use a Move script signed by the approved proxy account to acquire signing priviledges of aptos framework during the scripts execution
6. Ideally the controlling account would be multisig and this would be a strict requirement for the proxy module.  For test purposes this would be relaxed to a single account

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

    /// Delegate aptos framework's signing cap to proxy
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
