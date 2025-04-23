# MIP-48: `aptos_governance` for Goverened Gas Pool
- **Description**: Use the `aptos_governance` framework for the Governed Gas Pool
- **Authors**: [Richard Melkonian](mailto:richard@movementlabs.xyz)

## Abstract

The Goverened Gas Pool design presented in [MIP-44](../mip-44/) is required to be subject to onchain governance by a governing body that holds the
`$L2-MOVE` token. In [MIP-44] governance mechanisms and roles are proposed, such as `Proposers` and `Executors` so that the collected gas can be used 
for the good of the network.

The Governed Gas Pool may be used to provide liquidity for different network needs, such as L1 Reward Tokens, or to enable the "Trickle-back", where the `$L2-MOVE` would be paid 
directly to attestors as `$L1-MOVE` for rewards. For all these activities a dispersal of funds is required, this MIP proposes concrete ways to manage dispersal events 
in a safe immutable and secure manner. 

To decide on how acrued `$L2-MOVE` in the Governed Gas Pool should be used, a robust and thorough implementation of governance should be proposed. 

## Motivation

This MIP proposes an implementation of the governance mechanism proposed in [MIP-44] by using the `aptos_governance.move` module. We think this has several benefits. 
1. `aptos_governance.move` is fully audited and battle tested.
2. `aptos_governance.move` is currently in use on the Aptos Blockchain. 
3. Using aptos governance prepares us for extendeding it and using it for future proposals to upgrade or migrate the network, this will be a fairly common necessity post-mainnet.
4. It strenghtens the utility of `$L2-MOVE` as this becomes the governance token. 

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

## Reference Implementation

The `governed_gas_pool.move` would interact with `aptos_framework.move`, seperating the roles of actual governance, voting and storing of gas and dispersing those funds.

```rust
//pseudocode
module GovernedGasPool::goverened_gas_pool {
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::coin;
    use aptos_framework::signer;
    use aptos_framework::aptos_governance;
    use aptos_framework::aptos_governance::{self, GovernanceProposal};
    use aptos_std::vector;
    use aptos_std::option::{self, Option};

    // Address of the governance framework module
    const GOVERNANCE_ADDRESS: address = @0x1;

    struct GovernedPool has key {
        funds: coin::Coin<AptosCoin>,                // holds the pool of funds in AptosCoin
        passed_proposals: vector::Vector<Proposal>,  // list of proposals that passed governance
        admin: address                               // address with permission to execute proposals
    }

    struct DispersalAction has copy, drop, store {
        recipient: address,
        amount: u64
    }

    struct Proposal has key {
        id: u64,
        dispersal_action: Option<DispersalAction>, // Only one type of action at a time
        executed: bool,
    }

    /// Initialize the Governed Pool
    public fun initialize_governed_pool(admin: &signer, authorized_admin: address): address {
        let governed_pool = GovernedPool {
            funds: coin::zero<AptosCoin>(),
            passed_proposals: vector::empty<Proposal>(),
            admin: authorized_admin
        };
        let addr = signer::address_of(admin);
        move_to(admin, governed_pool);
        addr
    }

    /// Add a proposal that has passed governance
    /// Only callable by the governance module at address 0x1
    public fun add_passed_proposal(
        pool: &mut GovernedPool,
        governance_signer: &signer,
        id: u64,
        dispersal_action: DispersalAction
    ) {
        // Ensure only the governance framework can call this function
        assert!(signer::address_of(governance_signer) == GOVERNANCE_ADDRESS, 1);

        // Verify that the proposal is approved in aptos_governance
        assert!(aptos_governance::is_proposal_approved<GovernanceProposal>(id), 2);

        let proposal = Proposal {
            id,
            dispersal_action: option::some(dispersal_action),
            executed: false,
        };
        vector::push_back(&mut pool.passed_proposals, proposal);
    }

    /// Execute a proposal that has been approved by governance
    /// Only callable by the designated admin
    public fun execute_passed_proposal(pool: &mut GovernedPool, executor: &signer, proposal_id: u64) {
        // Ensure only the authorized admin can call this function
        assert!(signer::address_of(executor) == pool.admin, 2);

        let proposal_index = find_proposal(&pool.passed_proposals, proposal_id);
        let proposal = &mut vector::borrow_mut(&mut pool.passed_proposals, proposal_index);

        // Ensure the proposal hasn't already been executed
        assert!(!proposal.executed, 3);

        // Execute the dispersal action if present
        if (option::is_some(&proposal.dispersal_action)) {
            let action = option::borrow(&proposal.dispersal_action).unwrap();
            let amount = action.amount;
            assert!(amount <= coin::value(&pool.funds), 4); // Ensure pool has sufficient funds
            coin::withdraw(&mut pool.funds, amount);
            coin::deposit(&signer::create(action.recipient), amount);
        };

        proposal.executed = true;
    }
}
```

Notice the call :
`assert!(aptos_governance::is_proposal_approved<GovernanceProposal>(id), 2);`

## Verification


## Errata


## Appendix

---
## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).
