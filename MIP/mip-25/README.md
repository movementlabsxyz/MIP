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
7. The Proxy module MUST allow the controller to remove the signing capabilities and render the module inoperable.  This MUST allow an upgrade path to a new governance like module.  This MUST be an irreversible action.

## Reference Implementation
```rust
module aptos_framework::proxy {
    use std::hash::sha3_256;
    use std::signer;
    use std::vector;
    use aptos_std::smart_table;
    use aptos_std::smart_table::SmartTable;
    use aptos_framework::account::{create_signer_with_capability, SignerCapability};
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::coin;
    use aptos_framework::coin::Coin;
    use aptos_framework::event;
    use aptos_framework::system_addresses;
    use aptos_framework::transaction_context;
    use aptos_std::ed25519;
    use aptos_std::from_bcs;
    use aptos_framework::timestamp::now_seconds;

    friend aptos_framework::genesis;

    struct ProxyController has key {
        controller: address,
        next_proposal_id: u64,
        proposals: SmartTable<u64, Proposal>,
        nonce: u64,
    }

    struct ProxySignerCapabilities has key {
        aptos_framework_signer_cap: SignerCapability,
    }

    struct Proposal has store {
        creator: address,
        execution_hash: vector<u8>,
        stake: Coin<AptosCoin>,
        approved: bool,
        expiration: u64,
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

    #[event]
    struct ProposalRemoved has store, drop {
        proposal_id: u64,
    }

    const EINVALID_CONTROLLER : u64 = 0x1;
    const ENOT_APPROVED : u64 = 0x2;
    const EEXECUTION_HASH_INVALID : u64 = 0x3;
    const ENONCE_MISMATCH : u64 = 0x4;
    const EINVALID_SIGNATURE : u64 = 0x5;
    const EINVALID_CHALLENGE : u64 = 0x5;
    const EPROPOSAL_TIMEOUT : u64 = 0x6;
    const ENOT_CREATOR : u64 = 0x7;
    const EAPPROVED : u64 = 0x8;

    const PROPOSAL_LENGTH_IN_SECS : u64 = 2 * 24 * 60 * 60;

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
                next_proposal_id: 1,
                proposals: smart_table::new(),
                nonce: 0,
            }
        );

        move_to(
            aptos_framework,
            ProxySignerCapabilities {
                aptos_framework_signer_cap,
            }
        )
    }

    /// Destroy the proxy and release SignerCapability to the caller
    /// The controller is voided with 0xdead as the new controlling address.
    /// Warning from this point the proxy module will be inoperable
    public fun destroy(caller: &signer) : SignerCapability acquires ProxySignerCapabilities, ProxyController {
        let proxy_controller = borrow_global_mut<ProxyController>(@aptos_framework);
        assert!(signer::address_of(caller) == proxy_controller.controller, EINVALID_CONTROLLER);
        proxy_controller.controller = @0xdead;

        let ProxySignerCapabilities {
            aptos_framework_signer_cap
        } = move_from<ProxySignerCapabilities>(@aptos_framework);

        aptos_framework_signer_cap
    }

    /// Update the controller of the proxy. Requires signature over challenge which is at the moment an abitrary vector
    /// of bytes with a length of 32
    /// Aborts if signed by anyone else except the controller or @aptos_framework
    /// Aborts if nonce invalid
    /// Aborts etc
    /// Emits an event on updating the controller
    public fun update_controller(signer: &signer,
                                 new_controller_pubkey: vector<u8>,
                                 new_controller_signature: vector<u8>,
                                 challenge: vector<u8>,
                                 provided_nonce: u64
    ) acquires ProxyController {
        let proxy_controller = borrow_global_mut<ProxyController>(@aptos_framework);

        assert!(
            proxy_controller.controller == signer::address_of(signer),
            EINVALID_CONTROLLER
        );

        assert!(
            provided_nonce == proxy_controller.nonce,
            ENONCE_MISMATCH
        );

        let new_controller = sha3_256(new_controller_pubkey);

        let public_key = ed25519::new_unvalidated_public_key_from_bytes(new_controller_pubkey);
        let signature = ed25519::new_signature_from_bytes(new_controller_signature);
        assert!(
            ed25519::signature_verify_strict_t(&signature, &public_key, challenge),
            EINVALID_SIGNATURE
        );

        assert!(
            vector::length(&challenge) == 32,
            EINVALID_CHALLENGE
        );

        let new_controller = from_bcs::to_address(new_controller);
        let old_controller = proxy_controller.controller;
        proxy_controller.controller = new_controller;

        proxy_controller.nonce = proxy_controller.nonce + 1;

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
            execution_hash,
            stake,
            approved: false,
            expiration: now_seconds() + PROPOSAL_LENGTH_IN_SECS,
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
        let proposal = smart_table::borrow_mut(&mut proxy_controller.proposals, proposal_id);
        assert!(now_seconds() < proposal.expiration, EPROPOSAL_TIMEOUT);
        proposal.approved = true;

        event::emit(ProposalApproved {
            proposal_id,
        });
    }

    /// Remove proposal to be called by the creator of the proposal and only after the proposal has expired and has not
    /// been approved
    public entry fun remove(caller: &signer, proposal_id: u64) acquires ProxyController {
        let proxy_controller = borrow_global_mut<ProxyController>(@aptos_framework);
        let Proposal {
            creator,
            execution_hash: _,
            stake,
            approved,
            expiration,
        } = smart_table::remove(&mut proxy_controller.proposals, proposal_id);

        assert!(creator == signer::address_of(caller), ENOT_CREATOR);
        assert!(approved == false, EAPPROVED);
        assert!(expiration < now_seconds(), EPROPOSAL_TIMEOUT);

        coin::deposit(creator, stake);
        event::emit(ProposalRemoved {
            proposal_id,
        });
    }

    /// Reject proposal
    public entry fun reject(caller: &signer, proposal_id: u64) acquires ProxyController {
        let proxy_controller = borrow_global_mut<ProxyController>(@aptos_framework);
        assert!(signer::address_of(caller) == proxy_controller.controller, EINVALID_CONTROLLER);

        let Proposal {
            creator,
            execution_hash: _,
            stake,
            approved,
            expiration,
        } = smart_table::remove(&mut proxy_controller.proposals, proposal_id);

        assert!(approved == false, EAPPROVED);
        assert!(expiration < now_seconds(), EPROPOSAL_TIMEOUT);

        coin::deposit(creator, stake);
        event::emit(ProposalRejected {
            proposal_id,
        });
    }

    /// Delegate Aptos Framework's signing cap to proxy providing proposal id for approved proposal and calling from
    /// the proposed script
    public fun delegate_to_proxy(proposal_id: u64) : signer acquires ProxyController, ProxySignerCapabilities {
        let proxy_controller = borrow_global_mut<ProxyController>(@aptos_framework);

        let Proposal {
            creator,
            execution_hash,
            stake,
            approved,
            expiration: _,
        } = smart_table::remove(&mut proxy_controller.proposals, proposal_id);

        assert!(approved, ENOT_APPROVED);
        assert!(transaction_context::get_script_hash() == execution_hash, EEXECUTION_HASH_INVALID);

        let aptos_framework_signer_cap = &borrow_global<ProxySignerCapabilities>(@aptos_framework).aptos_framework_signer_cap;
        coin::deposit(creator, stake);
        create_signer_with_capability(aptos_framework_signer_cap)
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
2. With the hash of the script call `proxy::propose(execution_hash)` to initiate the request to proxy the script providing a refundable stake.  An off chain mechanism would track the newly created `proposal_id`
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

**Proposals**  

Proposals expire 2 days after creation, after which they can no longer be approved or rejected. Only the creator of the proposal can remove it using the `remove(caller, proposal_id)` function.

**Key Rotation**  

The controlling key can be rotated using `update_controller()` by providing the new controller's public key along with a signed challenge, which proves ownership of the private key corresponding to the new public key.

**At Genesis**  

The `proxy` module would be initialized with the `SignerCapability` for the Aptos Framework
https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/genesis.move#L68

```rust
proxy::initialize(&aptos_framework_account, aptos_framework_signer_cap);
```
## Verification

### 1. Correctness:
The reference implementation has been integrated with the Aptos Framework. The `multisig_account.move` module has been verified as a mechanism to allow the proxy controller to be managed by a predefined set of signers. A review of `aptos_governance.move` provided a useful framework for validating and executing approved scripts based on their script hash. Further testing, including integration tests, will be conducted to validate the reference implementation presented here, and this will be supported by specification files for formal verification.

### 2. Security Implications:
The controller’s ability to approve proposals that proxy the signing capabilities of the Aptos Framework introduces certain security risks. These risks are mitigated by ensuring that only the controller can approve or reject proposals. Additionally, cryptographic methods are employed to verify key rotations using a signed challenge, along with a nonce to prevent replay attacks. Malicious scripts are further safeguarded by validating their hash at the time of execution, ensuring that only approved scripts can be executed.
Changes will be required at Genesis to initialize the module, which will involve providing the `SignerCapability` to the module. A potential area of concern is the scope of control the proxy has during script execution. This could be addressed with more granular access control over the modules, but such a solution is beyond the scope of this MIP and would warrant its own proposal. Since this module is designed for upgrading the framework during Stage 0, it is expected to be superseded and made inoperative once the network transitions to a later stage of governance, potentially using Aptos Governance.

### 3. Performance Impacts:
The proxy model offers an efficient way to govern the Aptos Framework through a multisig setup, bypassing the delays and staking requirements typically involved when using the Aptos Governance system.

### 4. Validation Procedures:
Tests were conducted using Move scripts to confirm that they can successfully acquire the `SignerCapability` for the Aptos Framework. These tests were aligned with the existing capabilities provided by the Aptos Governance system.

### 5. Peer Review and Community Feedback:
The proposal is subject to review and feedback from the Movement Labs team and the wider community to ensure that it meets the needs of the ecosystem.  

## Errata

## Appendix
