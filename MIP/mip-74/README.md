# MIP-74: Rate-Limiter for the Lock/Mint-type Native Bridge

- **Description**: A rate limitation mechanism for the Lock/Mint-type Native Bridge.
- **Authors**: [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)
- **Desiderata**: [MD-74](../../MD/md-74/README.md)

## Abstract

We propose a Rate-Limiter to protect the Lock/Mint-type Native Bridge, hereafter called the _Native Bridge_^[see [MIP-58](https://github.com/movementlabsxyz/MIP/pull/58)] against faulty or compromised behavior of the bridge components. It limits the volume of assets that can be transferred within a time window. This MIP proposes a solution to mitigate attacks and limit damages, and if paired with an insurance fund it may cover the potential losses incurred by our users.

## Motivation

There are several components and actors in control of the behavior of the Native Bridge including contracts, relayer that we assume trusted and of course the network. If an attacker can control one these components they can potentially mint and transfer assets thereby compromising the bridge.

A Rate-Limiter can help to protect the Native Bridge against faulty components or attacks. It can limit the volume of transferred value per time interval, the maximum value transferred with a given transfer, or the number of transactions.

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

### Actors and components

The Native Bridge is operated via contracts, actors and components. The following actors and components are involved:

1. **User**: The user is the entity that interacts with the Native Bridge. The user can be a contract or an external account.
1. **L1 Native Bridge contract**: The L1 Native Bridge contract is the contract that is deployed on the L1 chain. It is responsible for locking and releasing assets on the L1 chain.
1. **L2 Native Bridge contract**: The L2 Native Bridge contract is the contract that is deployed on the L2 chain. It is responsible for minting and burning assets on the L2 chain.
1. **L2-Minter**: The L2-Minter is an L2-contract that is responsible for minting assets on the L2 chain.
1. **Governance contract**: The governance contract is an L2 contract on L2 that is used to adjust the parameters of the Native Bridge components on L2.
1. **Governance Operator**: The governance operator is the entity that can adjust the parameters of the Native Bridge via the governance contract or directly. Hereafter we simply refer to the Operator.

In addition to protect the Native Bridge against faulty components, the Rate-Limiter and the Insurance Fund are introduced. Figure 1 shows the architecture of the Native Bridge including the following components:

1. **Insurance fund**: The insurance fund is a contract that is used to cover potential losses in case of a faulty component, see [MIP-50](https://github.com/movementlabsxyz/MIP/pull/50).
1. **Rate Limiter**: The Rate Limiter is a set of contracts (one on the L1 and one on the L2) that is used to limit the volume of transferred value per time interval.

![alt text](overview.png)
_Figure 1: Architecture of the Rate Limitation_

### Actors, components and Trust assumptions

We assume the following trust assumptions:

1. The Governance contract is implemented correctly.
1. The Bridge contract and the L2-Minter contract are implemented correctly.
1. The Governance Operator is trusted. For example it COULD be a multisig human.
1. The Relayer is trusted and automated.

### Risks and mitigation strategies

The following risks are associated with the Native Bridge:

1. The trusted relayer is compromised or faulty. We thus want to ensure that the relayer has not unlimited power to release or mint assets. For this we MUST implement a rate limiter on the target chain.
1. In order to rate limit the bridge (e.g. stop the bridge transfers entirely) there should be a higher instance than the relayer in setting rate limits. Thus the rate limit on the target chain SHOULD be set by the Operator.
1. The Relayer may go down, while the number of transactions and requested transfer value across the bridge still increases on the source chain. Due to rate limit on the target chain the Relayer may struggle to process all initiated transfers. Thus the Relayer or the Operator MUST rate limit the source chain as well.

### Rate-Limiter

In the Native Bridge, the Rate-Limiter MUST be implemented as part of the L1 Native Bridge contract and the L2 Native Bridge contract.

**Rate limit on the target chain**
 We assume there is a Insurance Fund on both L1 and L2, with values `insurance_fund_L1` and `insurance_fund_L2`, respectively.

The Insurance Fund rate limits the outbound transfers, i.e. for a given transfer from source chain to target chain the Insurance Fund on the target chain is responsible for the rate limit, and thus we will refer to the `insurance_fund_target`. I.e. for a transfer from L1 to L2 the `insurance_fund_target = insurance_fund_L2` is responsible for the rate limit. While for a transfer from L2 to L1 the `insurance_fund_target = insurance_fund_L1` is responsible for the rate limit.

The rate limit is dependent on the fund size in the Insurance Fund. In particular the maximum rate limit

`max_rate_limit_target = insurance_fund_target / reaction_time`,

where the `reaction_time` is the time it takes for the Operator to react to a faulty or compromised component. The `reaction_time` is a parameter that is set by the Operator. The Operator MAY set the actual rate limit lower than the `max_rate_limit_target`. However the Rate Limiter MUST NOT set the rate limit higher than the `max_rate_limit_target`.

The rate limit MAY also be adjusted by the Operator.

`rate_limit_target = rate_reduction_target * max_rate_limit_target`,

where `rate_reduction_target \in {0,1}` is a parameter that is set by the Operator. Note the `rate_limit_target` MUST not be larger than `max_rate_limit_target`.

The following are possible ways to adjust the rate limit:

1. The Operator can adjust the rate limit by adding or removing funds from the Insurance Fund.
1. The Operator may adjust the rate limit by changing the `reaction_time`.
1. The Operator may adjust the rate limit by changing the `rate_reduction_target`.

**Rate limit on the source chain**

On the source chain the rate limit MAY be lowered by the Relayer. This is to ensure that the rate limit on the target chain is not exceeded. It also permits the Relayer to catch up in case of the Relayer has been down for some time.

`rate_limit_source = min{rate_reduction_source * rate_limit_target, rate_limit_operator_source}`,

where `rate_reduction_source \in {0,1}` is a parameter that is set by the Relayer. `rate_limit_operator_source` is a parameter that is set by the Operator. Note the `rate_limit_source` SHOULD not be larger than `rate_limit_operator_source`.

### Rate limitation algorithm

The rate limitation works as follows:

[!NOTE]
I can convert the following into pseudo code, after we have discussed the algorithm and it makes sense.

**Algorithm for the Native Bridge contract on the source chain**

1. A user wants to transfer value from source to target chain.
1. The user sends a transaction to the source chain Native Bridge contract.
1. The source chain Native Bridge contract checks if the rate limit `rate_limit_source` is exceeded if it would apply the transaction.
    1. If the rate limit is exceeded the transaction is rejected.
    1. Else the transaction is accepted.
  
**Algorithm for the Native Bridge contract on the target chain**

1. The target chain Native Bridge contract checks if the rate limit `rate_limit_target` is exceeded if it would apply the transaction.
    1. If the rate limit is exceeded the transaction is rejected.
    1. If the rate limit is not exceeded the transaction is accepted.

The following algorithm is a recommendation for the operation of the Relayer:

**(Optional) Algorithm for the Relayer**

1. The Relayer receives an event that a transaction was accepted.
1. The Relayer checks if the rate limit `rate_limit_target` is exceeded if it would apply the transaction. (The Relayer may keep locally the budget on the target chain, or it could read the contract state).
    1. If the rate limit is exceeded the transaction has to be put on hold.
    1. Else the Relayer sends a transfer transaction to the target chain.

## Reference Implementation

## Verification

Needs discussion.

---

## Change Log

---

## Appendix

### A1

Nothing important here.

---

## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).
