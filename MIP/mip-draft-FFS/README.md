# MIP-0: MIPs
- **Description**: Movement Improvement Proposals standardize and formalize specifications for Movement technologies.
- **Authors**: [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)

## Abstract

Fast-Finality Settlement (FFS) is a mechanism that allows for fast settlement of transactions with crypto-economic security. This MIP outlines the specifications for implementing FFS on the Movement blockchain.

## Definitions

- FFS - Fast Finality Settlement
- MCR - Multi-commit Rollup : an implementation of FFS
- Validator - a node that is responsible for validating transactions and producing blocks
- Postconfirmation - a finality guarantee related to L1
- L2-finality - a finality guarantee related to L2

## Motivation

This MIP introduces a mechanism that provides crypto-economical guarantees on the finality level of transactions. 

The mechanism can be deployed independently for a chain, or in combination with existing settlement mechanisms, such as ZK and optimistic settlement. The main goal of the mechanism is to provide fast-finality settlement, which is crucial for reducing transaction costs and enabling new use cases for which existing finality times are not sufficient.

A more detailed description on the security of the mechanism can be found at [this blog post on Fast-Finality Settlement](https://blog.movementlabs.xyz/article/security-and-fast-finality-settlement). A description of a (partial) implementation of the mechanism is available at [this blog post on Postconfirmations](https://blog.movementlabs.xyz/article/postconfirmations-L2s-rollups-blockchain-movement).

## Specification

The Fast-Finality Settlement mechanism consists of the following components/mechanisms and which should be addressed separately in their own MIPs:

- A set of validators that are responsible for validating transactions and producing blocks, and how they communicate with each other.
- A mechanism for validators to stake tokens as collateral.
- A mechanism for validators to be penalized for misbehavior.
- A mechanism for validators to be rewarded for correct behavior.
- Postconfirmations, a mechanism for a user to obtain a confirmation for a transaction that it has been attested to on L1 by a validator.
- L2-finality, a mechanism for validators to confirm transactions after they have been included in an L2-block AND a quorum of validators has confirmed the state that is created by that L2-block.
- A fast bridge that allows for the transfer of tokens between L1 and L2, and vice versa.

## Reference Implementation

n/a

## Verification



1. **Correctness**: 


2. **Security Implications**: 

The security of this approach is discussed in [this blog post on Fast-Finality Settlement](https://blog.movementlabs.xyz/article/security-and-fast-finality-settlement). 

3. **Performance Impacts**: 

The mechanism provides fast finality.

Performance concerns are
- the time it takes for a transaction to be confirmed
- the time it takes for aggregation of signatures
- the time it takes for issuing a postconfirmation and getting included in an L1-block
- the time it takes for issuing an L2-finality and getting 
- the impact of the validator set size
- bridge volume capacity and time

4. **Validation Procedures**: 

n/a

5. **Peer Review and Community Feedback**: 

n/a

## Errata

n/a

## Appendix

n/a