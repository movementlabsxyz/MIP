# MIP-25: Proxy Aptos Framework for stage 0 governance
- **Description**: Proxy aptos framework signing for stage 0 of the Movement network governance
- **Authors**: [Andy Bell](mailto:andy.bell@movementlabs.xyz)
- **Desiderata**: [MD-0](../MD/md-0)

## Abstract
This MIP describes a means by which during Stage 0 of the Movement network a signing key, single or multi, is able to manage the aptos framework without relying on the governance module included in the aptos framework.  This facilitating an agile manner in which aptos framework updates and modifications can be executed rapidly during this stage of the network.   

## Motivation
During Stage 0 of the Movement network Movement Labs would hold centralised control of the node and aptos framework.  In order to update or modify the aptos framework this would involve the deployment of new node binaries to operators in the network who would then upgrade.  One option to facilitate aptos framework upgrades is of the use of the governance module which forms part of the aptos framework.  This, however, is not optimal for stage 0 of the network and the proposal here is to include a new module in the framework which proxies functions executed with the priviledges of the aptos framework.  Following a similiar technique as the governance module but allowing voting to be circumvented with the use of a trusted multisignature wallet held and managed by Movement Labs. 

## Specification

## Reference Implementation

## Verification

## Errata

## Appendix
