# MIP-74: Rate limiter for the Lock/Mint-type Native Bridge

- **Description**: A rate limitation mechanism for the Lock/Mint-type Native Bridge.
- **Authors**: Andreas Penzkofer, Primata
- **Desiderata**: [MD-74](../../MD/md-74/README.md)

## Abstract

We propose a rate limitation mechanism to protect the Lock/Mint-type Native Bridge, hereafter called the _Native Bridge_, see [MIP-58](https://github.com/movementlabsxyz/MIP/pull/58), against faulty or compromised behavior of the Native Bridge components. It limits the volume of assets that can be transferred within a time window. This MIP proposes a solution to mitigate attacks and limit damages, and if paired with an insurance fund it may cover the potential losses incurred by our users.

## Motivation

There are several components and actors in control of the behavior of the Native Bridge including contracts (we may assume they are trusted), our Relayer and of course the network. If an attacker can control one these components they can potentially mint and transfer assets thereby compromising the Native Bridge.

The Rate Limiter can help to protect the Native Bridge against faulty components (Relayer or network) or attacks. It can limit the volume of transferred value per time interval, the maximum value transferred with a given transfer, or the number of transactions within a time window.

**Background**
In order to protect the protocol from exploits and potential losses, rate limiting is essential. For comparison the white paper [EigenLayer: The Restaking Collective](https://docs.eigenlayer.xyz/assets/files/EigenLayer_WhitePaper-88c47923ca0319870c611decd6e562ad.pdf) proposes that AVS (Actively Validated Services) can run for a bridge and the stake of validators protects the transferred value crypto-economically through slashing conditions. More specifically section `3.4 Risk Management` mentions

> [...] to restrict the Profit from Corruption of any particular AVS [...] a bridge can restrict the value flow within the period of slashing.

In essence this boils down to rate limit the bridge by considering

- how long does it take to finalize transfers (ZK, optimistic)
- how much value can be protected economically

In our setting we trust the bridge operator, and thus we replace

- finalization by the reaction time of the operator
- the staked value by the insurance fund

## Specification

_The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174._

### Actors and components

The Native Bridge is operated via contracts, key holders and a relayer. More precisely the following actors and components are involved:

1. **User**: this is the entity that interacts with the Native Bridge. The user can be a contract or an external account.
1. **L1 Native Bridge contract**: this is the contract that is deployed on the L1 chain. It is responsible for locking and releasing (unlocking) assets on the L1 chain.
1. **L2 Native Bridge contract**: this is the contract that is deployed on the L2 chain. It is responsible for minting and burning assets on the L2 chain.
1. **Governance contract**: this is an L2 contract on L2 that is used to adjust the parameters of the Native Bridge components on L2.
1. **Governance Operator**: this is the entity that can adjust the parameters of the Native Bridge via the governance contract or directly.
1. **Relayer**: this is the software component that is responsible for transferring assets between the L1 and L2 Native Bridge contracts by completing transfers initiated by the user.

In addition to protect the Native Bridge against faulty components, the Rate Limiter and the Insurance Fund are introduced. Figure 1 shows the architecture of the Native Bridge including the following components:

1. **Insurance Fund**: The Insurance Fund is a pool of tokens held in a contract that is used to cover potential losses in case of a faulty component, see [MIP-50](https://github.com/movementlabsxyz/MIP/pull/50).
1. **Rate Limiter**: The Rate Limiter is a set of contracts (one on the L1 and one on the L2) that is used to limit the volume of transferred value per time window.

![alt text](overview.png)
_Figure 1: Architecture of the Rate Limitation system_

### Trust assumptions

We assume the following _trust assumptions_:

Contracts:

1. The Governance contract is implemented correctly.
1. The Native Bridge contracts (L1 and L2) are implemented correctly.
1. The Insurance Fund is implemented correctly.
1. The Rate Limiter contract parts are implemented correctly.

Other:

1. The Governance Operator is trusted. For example, it COULD be a multisig human.
1. The Relayer is a partially trusted software component. We trust it to a certain extent, but we want to limit its power to mint or release assets.

### Risks and mitigation strategies

The following attack vectors are considered:

1. The trusted Relayer is compromised or faulty. We thus want to ensure that the Relayer has not unlimited power to release or mint assets. For this we MUST implement the Rate Limiter on the target chain.
1. In order to rate-limit the Native Bridge (e.g. stop the Native Bridge transfers entirely) there should be a higher instance than the Relayer in setting rate limits. Thus the rate limit on the target chain SHOULD be set by the Governance Operator.
1. If the target chain is rate limited but the source chain is not, users could request for more transfers on the source chain than the Relayer could complete on the target chain. This could lead to a situation where the Relayer is not able to process all transactions. To mitigate this the Relayer or the Governance Operator MUST rate limit the source chain as well. The rate limits on both chains SHOULD be consistent.
1. The Relayer may go down, while the number of transactions and requested transfer value across the Native Bridge still increases on the source chain. Due to the rate limit on the target chain the Relayer may struggle or be incapable to process all initiated transfers. Thus the Relayer or the Governance Operator MUST be able to rate limit the source chain temporarily or permanently lower than the target chain rate limit.

To elaborate on the last point, consider that the Native Bridge operates at the maximum rate continuously and both source and target chain have the same rate limit. Then, if the Relayer goes down for some time $\Delta$, the Relayer will start to process transactions at the maximum rate. Consequently, all transactions would be delayed by $\Delta$ time units as long as the rate limit on the target chain is entirely exhausted.

### Expected Properties of the Rate Limiter

The objectives of the Rate Limiter are to guarantee the following properties:

1. the value of assets being transferred across the Native Bridge, within a configurable time window $\Delta$, MUST always be less than the insurance funds.
1. the Governance Operator MUST be able to adjust the rate limit on the source and target chain.
1. the Relayer MUST be able to catch up with the transfers in case it has been down for some time.
1. the Relayer MAY adjust the rate limit on the source chain.

The guiding principles of the design of the Rate Limiter are:

1. The Governance Operator monitors the Native Bridge, and in case of an attack or fault, it SHOULD take at most $\Delta$ time units to detect the issue and pause the Native Bridge.
2. We want to make sure that the total amount that is transferred within $\Delta$ time units (and that could potentially result from malicious behaviors) is ALWAYS covered by the insurance fund.

### Rate limitation

The Rate Limiter limits the volume of assets that can be transferred within a time window. The assets are managed by the smart contracts on L2 and L1, and we MAY build the rate limiter logics directly as part of the L1 Native Bridge contract and the L2 Native Bridge contract.

#### Insurance funds

We assume there is a Insurance Fund on both L1 and L2, with values `insurance_fund_L1` and `insurance_fund_L2`, respectively.

!!! warning These values are considered constant in the sequel. There may be updated if needed or if new funds are added to the pools.

The Insurance Fund indirectly rate-limits the transfers i.e., for a given transfer from source chain to target chain the Insurance Fund on the _target chain_ is responsible for the rate limit, and thus we will refer to the `insurance_fund_target`.
For a transfer from L1 (L2) to L2 (L1) the `insurance_fund_target = insurance_fund_L2` (`insurance_fund_L1`) is responsible for the rate limit.

#### Rate limit on the target chain

The rate limit is dependent on the fund size in the Insurance Fund. In particular the maximum rate limit is defined by

`max_rate_limit_target = insurance_fund_target / reaction_time`,

where the `reaction_time` is the time it takes for the Governance Operator to react to a faulty or compromised component. The `reaction_time` is a parameter that is set by the Governance Operator. 

_Implementation recommendation #1_: The default value is 24h. In the initial implementation this value is fixed to avoid complications in gas.

_Implementation recommendation #2_: The target Native Bridge contract checks at every transfer first, whether the relevant Insurance Fund size has changed before calculating the current rate limit and whether the budget is exceeded.

**(Optional) Direct adjustment of rate limit by Governance Operator**
The rate limit MAY also be adjusted by the Governance Operator directly by a parameter `rate_reduction_target`. However the Rate Limiter MUST NOT set the rate limit higher than the `max_rate_limit_target`. In equation

`rate_limit_target = rate_reduction_target * max_rate_limit_target`,

where `rate_reduction_target` $\in$ `[0,1]` is a parameter that is set by the Governance Operator. As mentioned the `rate_limit_target` MUST not be larger than `max_rate_limit_target`.

**Summary of Adjustment mechanisms**
The following are possible ways to adjust the rate limit:

1. The Governance Operator indirectly adjusts the rate limit by adding or removing funds from the Insurance Fund.
1. The Governance Operator indirectly MAY adjust the rate limit by changing the `reaction_time`. 
1. The Governance Operator MAY adjust the rate limit by changing the `rate_reduction_target`.

#### Rate limit on the source chain

On the source chain the rate limit MUST be limited by the Governance Operator to match the rate limit on the target chain. if only the target chain would be rate limited users could successfully continue to request transfers on the source chain while the budget on the target chain is already consumed. Consequently the  Relayer would not be capable to complete the transfers.

On the source chain the rate limit MAY be lowered by the Relayer. This is to ensure that the rate limit on the target chain is not exceeded. It also permits the Relayer to catch up in case of the Relayer has been down for some time.

`rate_limit_source = min{rate_reduction_source * rate_limit_target, rate_limit_operator_source}`,

where `rate_reduction_source` $\in$ `[0,1]` is a parameter that is set by the Relayer. `rate_limit_operator_source` is a parameter that is set by the Governance Operator. Note the `rate_limit_source` SHOULD not be larger than `rate_limit_operator_source`.

### Rate limitation adjustment algorithm

The rate limitation works as follows:

!!! warning I can convert the following into pseudo code, after we have discussed the algorithm and it makes sense.

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

## Reference Implementation

## Verification

Needs discussion.

We may add a formal model?

---

## Changelog

## Appendix

### A1: Alternative designs

This MIP proposes a rate limiting mechanism for the Lock/Mint-type Native Bridge with symmetrical design. Below we discuss how we got here and which alternatives exist. The version discussed in this MIP is option C.

A. **Single-sided rate limiting (on source chain)**

- Rate limiting should be implemented on the L1 and maps each day to a budget, for each direction. Once the budget is reached on one of the directions, no more tokens can be transferred on that direction.
- The bridge is financially secured by an Insurance Fund, see [MIP-50](https://github.com/movementlabsxyz/MIP/pull/50), which determines  the maximum amount of tokens to be transferred per day, called the budget. The insurance fund is maintained by Movement Labs.
- The budget is one quarter of the Insurance Fund balance. This is meant to account for the insurance fund to be able to insure all current funds already transferred and all tokens inflight, per direction.
- The Insurance Fund maintains the rate limit budget by adjusting its own \$MOVE balance. It should be either the Movement Labs multisig or a new multisig 1/3 if we choose to adopt an approach that requires more direct ability by the personnel.
- Once the rate limit budget is reached, if no issues have been observed, operators should simply wait for the next day.
- If an issue has been observed, an operator should simply transfer to the bridge contract the sum of the exploit size, being the result of additional supply on L1, outside of the bridge address, and the additional supply on L2. This action covers both cases where tokens were extracted from the bridge contract on L1 or over-minted on L2. Movement Foundation should evaluate the amount of tokens that should be held by the Insurance Fund after the incident and transfer to it the amount to reach that amount.
- This approach is open to exploits where the Relayer key is compromised. It would enable the exploiter to freely mint on L2.

B. **Two-sided partial rate limiting (target chain only)**

- Rate limiting should be implemented on both L1 and L2 for inbound transactions only. It maps a daily budget of inbound transactions and once it's reached, the Relayer cannot complete more transactions. The bridge is financially secured by two Insurance Funds, one on each side, maintained by Movement Labs, and the maximum amount of tokens to be transferred per day, per direction is half of each of its Insurance Funds balances. This is meant to account for all tokens already transferred and inflight, per direction.
- The Insurance Funds determine the rate limit budgets. Thus the rate limit can be adjusted by changing the \$MOVE balance. They should be either Movement Labs multisigs or new multisigs 1/3 if we choose to adopt an approach that requires more direct ability by the personnel.
- Once the rate limit budget is reached, if no issues have been observed, operators should simply wait for the next day.
- If an issue has been observed, operators should transfer to the bridge address the exploit amount on the L1 and burn the exploit amount on the L2. Movement Foundation should evaluate the amount of tokens that should be held by the Insurance Funds and operators should receive those tokens and bridge tokens if an exploit occurred on L2.
- This approach is more susceptible to issues on the frontend because the frontend has to acknowledge rate limit budget and inflight tokens and inform users if the rate limit is about to be reached, not only if it has been reached.

C. **Two sided full rate limiting**

This proposal is discussed in this MIP.

- The previous approaches may break the rate limit if users can directly initiate the bridge transfer via the bridge contracts. Since we MUST guarantee the completion of transfers the rate limit on the source chain could get exceeded, leading to ever increasing backlog of transfers.
- Therefore, rate limiting should be implemented on both L1 and L2 for inbound and outbound transactions.
- This approach extends the previous approach.
- It protects against exploits of the Relayer.
- Initiating transfers get rejected on the source chain, which improves safety and fulfills rate limit requirements on the source chain.
- On the source chain the rate limit is not related to the Insurance Fund. This opens the question who sets the rate limit on the source chain. We answer this in this MIP.

---

## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).
