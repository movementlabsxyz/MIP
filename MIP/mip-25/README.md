# MIP-25: Proxy Aptos Framework for stage 0 governance
- **Description**: Proxy aptos framework signing for stage 0 of the Movement network governance
- **Authors**: [Andy Bell](mailto:andy.bell@movementlabs.xyz)
- **Desiderata**: [MD-0](../MD/md-0)

## Abstract
This MIP describes a means by which during Stage 0 of the Movement network a signing key, single or multi, is able to manage the aptos framework without relying on the governance module included in the aptos framework.  This facilitating an agile manner in which aptos framework updates and modifications can be executed rapidly during this stage of the network.   

## Motivation
During Stage 0 of the Movement network Movement Labs would hold centralised control of the node and aptos framework.  In order to update or modify the aptos framework this would involve the deployment of new node binaries to operators in the network who would then upgrade.  One option to facilitate aptos framework upgrades is of the use of the governance module which forms part of the aptos framework.  This, however, is not optimal for stage 0 of the network and the proposal here is to include a new module in the framework which proxies functions executed with the priviledges of the aptos framework.  Following a similiar technique as the governance module but allowing voting to be circumvented with the use of a trusted multisignature wallet held and managed by Movement Labs. 

## Specification
1. Proxy module is made available as part of the aptos framework
2. A single or multi signature would be required to acquire temporarily the signing priviledges of aptos framework
3. Only one authourised key would be able to operate the proxy module and acquire the signing priviledges
4. The key would be rotated and functionality would be provided in the proxy module to do so
5. Updates to the framework would use a Move script signed by the approved proxy account to acquire signing priviledges of aptos framework during the scripts execution
6. Ideally the controlling account would be multisig and this would be a strict requirement for the proxy module.  For test purposes this would be relaxed to a single account

## Reference Implementation

## Verification

## Errata

## Appendix
