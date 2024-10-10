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
    use aptos_std::smart_table;
    use aptos_std::smart_table::SmartTable;
    use aptos_framework::account::{create_signer_with_capability, SignerCapability};
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::coin;
    use aptos_framework::coin::Coin;
    use aptos_framework::event;
    use aptos_framework::system_addresses;
    use aptos_framework::system_addresses::is_aptos_framework_address;
    use aptos_framework::transaction_context;
    friend aptos_framework::genesis;

    struct ProxyController has key {
        controller: address,
        aptos_framework_signer_cap: SignerCapability,
        next_proposal_id: u64,
        proposals: SmartTable<u64, Proposal>,
    }

    struct Proposal has store {
        creator: address,
        proposal_id: u64,
        execution_hash: vector<u8>,
        stake: Coin<AptosCoin>,
        approved: bool,
    }

    #[event]
    struct ProposalCreated has store, drop {
        creator: address,
        proposal_id: u64
    }

    #[event]
    struct ProposalRejected has store, drop {
        proposal_id: u64,
    }

    #[event]
    struct ProposalApproved has store, drop {
        proposal_id: u64,
    }

    const EINVALID_CONTROLLER : u64 = 0x1;
    const ENOT_APPROVED : u64 = 0x2;
    const EEXECUTION_HASH_INVALID : u64 = 0x3;

    #[event]
    /// An event triggered when the controller is updated
    struct ControllerUpdated has store, drop {
        old_controller: address,
        new_controller: address,
    }

    /// Only called during genesis.
    public(friend) fun initialize(aptos_framework: &signer, aptos_framework_signer_cap: SignerCapability) {
        system_addresses::assert_aptos_framework(aptos_framework);

        move_to(
            aptos_framework,
            ProxyController {
                controller: @aptos_framework,
                aptos_framework_signer_cap,
                next_proposal_id: 1,
                proposals: smart_table::new(),
            }
        )
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

    /// Propose a script to be executed providing its hash and a stake
    /// Stake is returned on approval and execution or rejection
    public entry fun propose(caller: &signer, execution_hash: vector<u8>) acquires ProxyController {
        let proxy_controller = borrow_global_mut<ProxyController>(@aptos_framework);
        let stake: Coin<AptosCoin> = coin::withdraw<AptosCoin>(caller, 10_000_000);

        let creator = signer::address_of(caller);
        let proposal_id = proxy_controller.next_proposal_id;
        let proposal = Proposal {
            creator,
            proposal_id,
            execution_hash,
            stake,
            approved: false,
        };

        proxy_controller.next_proposal_id = proxy_controller.next_proposal_id + 1;

        smart_table::add(&mut proxy_controller.proposals, proposal_id, proposal);

        event::emit(ProposalCreated {
            creator,
            proposal_id,
        });
    }

    /// Approve proposal
    public entry fun approve(caller: &signer, proposal_id: u64) acquires ProxyController {
        let proxy_controller = borrow_global_mut<ProxyController>(@aptos_framework);
        assert!(signer::address_of(caller) == proxy_controller.controller, EINVALID_CONTROLLER);
        smart_table::borrow_mut(&mut proxy_controller.proposals, proposal_id).approved = true;

        event::emit(ProposalApproved {
            proposal_id,
        });
    }

    /// Reject proposal
    public entry fun reject(caller: &signer, proposal_id: u64) acquires ProxyController {
        let proxy_controller = borrow_global_mut<ProxyController>(@aptos_framework);
        assert!(signer::address_of(caller) == proxy_controller.controller, EINVALID_CONTROLLER);

        let Proposal {
            creator,
            proposal_id: _,
            execution_hash: _,
            stake,
            approved: _ } = smart_table::remove(&mut proxy_controller.proposals, proposal_id);

        coin::deposit(creator, stake);
        event::emit(ProposalRejected {
            proposal_id,
        });
    }

    /// Delegate Aptos Framework's signing cap to proxy providing proposal id for approved proposal and calling from
    /// the proposed script
    public fun delegate_to_proxy(proposal_id: u64) : signer acquires ProxyController {
        let proxy_controller = borrow_global_mut<ProxyController>(@aptos_framework);
    
        let Proposal {
            creator,
            proposal_id: _,
            execution_hash,
            stake,
            approved } = smart_table::remove(&mut proxy_controller.proposals, proposal_id);

        assert!(approved, ENOT_APPROVED);
        assert!(transaction_context::get_script_hash() == execution_hash, EEXECUTION_HASH_INVALID);

        coin::deposit(creator, stake);
        create_signer_with_capability(&proxy_controller.aptos_framework_signer_cap)
    }

    #[view]
    /// Return the controller of the proxy
    public fun get_controller(): address acquires ProxyController {
        borrow_global<ProxyController>(@aptos_framework).controller
    }
}
```
**Steps:**
1. Create the Move script you want to execute.  An example can be found below.
2. With the hash of the script call `proxy::propose(execution_hash)` to initiate the request to proxy the script providing a refundable stake.  On off chain mechanism would track the newly created `proposal_id`
3. The controller would call `proxy::approve(proposal_id)` which would approve the proposal
4. Alternatively the controller would call `proxy::reject(proposal_id)` to reject the proposal resulting in the return of the stake to the `creator`
5. With a proposal being approved the proposed script can now be executed and will be delegated proxy, `proxy::delegate_to_proxy` to the signing capabilities of the Aptos Framework.
6. On receiving the proxy the proposal is removed with the stake being returned to the `creator`

```rust
script {
    use aptos_framework::proxy;
    use aptos_framework::atomic_bridge_configuration;

    // Called by anyone with an approved proposal id to be delegated proxy to the framework to 
    // update the bridge operator
    fun main(proposal_id: u64, new_operator: address) {
        let framework_signer = proxy::delegate_to_proxy(proposal_id);
        atomic_bridge_configuration::update_bridge_operator(&framework_signer, new_operator);
    }
}
```

## Verification

The verification process ensures that any modifications to the Aptos Framework through the Proxy module are valid, secure, and follow the intended workflow for updates.

**Signature Verification:**
The Proxy module MUST verify the signature of any incoming transactions attempting to acquire the signing privileges of the Aptos Framework. Only the authorized multisig account, or the single account for testing purposes, MUST be allowed to execute these operations. Any invalid signatures or unauthorized attempts MUST be rejected by the Proxy module.

**Key Rotation Validation:**
When a key rotation occurs, the Proxy module MUST verify that the new key is properly registered and authorized before allowing any further actions. The rotation process MUST be logged and monitored to ensure traceability and that only approved keyholders have control.

**Script Execution Auditing:**
Every Move script signed by the Proxy account to modify or update the Aptos Framework MUST be audited and logged. The logs SHOULD include information about the account that executed the script, the changes made, and the time of execution. This ensures that any modifications can be traced back and verified for accountability.

**Multisig Approval Process (When Applicable):**
If the multisig account is in use, all transactions MUST meet the approval threshold defined by the multisig wallet. The Proxy module MUST verify that the required number of signatures is provided before proceeding with any action. This process MUST also be logged for review and validation.

**Testing Exceptions:**
During Stage 0 testing, if a single account is used instead of multisig, additional verifications MUST be in place to ensure that the single account is correctly configured and has not been compromised. This MAY involve requiring additional manual reviews or monitoring to mitigate the risks associated with a non-multisig setup.

**Security Audits:**
Movement Labs MUST conduct periodic security audits of the Proxy module, especially after key rotations or framework updates. These audits SHOULD include reviewing logs, verifying signatures, and ensuring that no unauthorized access has occurred. Any issues discovered during the audit MUST be addressed immediately to maintain the integrity of the Aptos Framework.

By following these verification steps, the integrity and security of the Aptos Framework are maintained throughout Stage 0 of the Movement Network, even while centralized control is held by Movement Labs.

## Errata

## Appendix
