# MIP-24: Removal of redundant functionality from framework
- **Description**: The removal of redundant modules from the movement branch of the aptos-core fork
- **Authors**: [Andy Bell](mailto:andy.bell@movementlabs.xyz)
- **Desiderata**: [MD-0](../MD/md-0)

## Abstract
The use of Movement's fork of aptos core for the Movement Network is a subset of its total.  There are significant areas in this repository which are not used from a node, tooling and framework perspective.  Due to the size of the repository this MIP will only consider the redundancy inherited from the aptos framework.

## Motivation
With the Movement network only using a subset Movement's fork of aptos core we are introducing technical debt and opening the framework to attack vectors for functionality not used in the context of Movement's network fork.  Large areas of code can be removed to alleviate this issue and provide more security assurances

## Specification
With closer inspection of the Movement fork of aptos core we are able to quickly identify areas of functionality that are not required in the context of the Movement network.  The following would be modules which would be strong candidates to be removed.

- `aptos_governance.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/aptos_governance.move

- `aptos_governance.spec.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/aptos_governance.spec.move

- `governance_proposal.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/governance_proposal.move

- `governance_proposal.spec.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/governance_proposal.spec.move

- `delegation_pool.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/delegation_pool.move

- `delegation_pool.spec.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/delegation_pool.spec.move

- `stake.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/stake.move
- `stake.spec.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/stake.spec.move
- `staking_contract.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/staking_contract.move
- `staking_contract.spec.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/staking_contract.spec.move
- `staking_proxy.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/staking_proxy.move
- `staking_proxy.spec.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/staking_proxy.spec.move
- `validator_consensus_info.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/validator_consensus_info.move
- `validator_consensus_info.spec.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/validator_consensus_info.spec.move
- `vesting.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/vesting.move
- `vesting.spec.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/vesting.spec.move
- `sources/voting.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/voting.move
- `voting.spec.move` https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/voting.spec.move

The initialisation and functioning of these modules are coupled with the VM directly and hence would require decoupling of this functionality at the VM level.

## Reference Implementation

## Verification

With the removal of these modules we would expect the tests for Node, VM and framework would pass

## Errata

## Appendix
