# MIP-54: The Bilbao Model
- **Description**: Proposes an AB-FFS L2 model that features a Gas Deficit Minter, Bridge Insurance Account, low-cost DA and settlement, high centralized control, and ultimately high operational assumptions.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Reviewer**: Andreas Penzkofer
- **Desiderata**: $\emptyset$

## Abstract

We defined the Bilbao Model as an AB-FFS L2 model that features a Gas Deficit Minter, Bridge Insurance Account, low-cost DA, high centralized control, and ultimately high operational assumptions. At the core of this model is the highly controlled use of trusted signers with high liquidity to replace components proposed in the [Biarritz Model](https://github.com/movementlabsxyz/MIP/pull/54).

## Motivation

The Bilbao Model is a intended as a complete response to [MD-38](https://github.com/movementlabsxyz/MIP/pulls).

## Specification

We acknowledge and apply the conventions of [MIP-53: Conventions for Proposing Progressive L2 Models](https://github.com/movementlabsxyz/MIP/pull/53).

| Category | Criterion | Evaluation |
|-----------|-----------|------------|
| **General** | | |
|X| When to use | - During a genesis period after which the resulting state is intended to be accepted as canonical by a more decentralized network. |
|X| Suitable preceding models.<br> - The benefits to the network of an immediate release against early technology outstrip the potential costs of failing to correctly resolve vulnerabilities introduce in genesis state. | NONE |
|X| Suitable succeeding models | - [MIP-54: The Biarritz Model](https://github.com/movementlabsxyz/MIP/pull/54) |
|X| Technological motivations | - Contends with bridge fallibility under high operational assumptions.<br> - Allows for building genesis state which can be altered prior to open launch. |
|X| Usership motivations | - Allows for early release of network. |
| **Components** | | |
|X| Gas Deficit Minter | We recognize the role of the Governed Gas Pool as one which can be replaced by simply computing and minting the burned gas to a governed account ex post facto. The Gas Deficit Minter thus takes on the role of allowing for the manual capture of gas fees. |
|X| Bridge Insurance Account | We recognize the role of the Bridge Insurance Fund as similar to that of a singular account which can replace bridge losses. While the guarantees are weaker than those proposed under [MIP-54: The Biarritz Model](https://github.com/movementlabsxyz/MIP/pull/54), this can be sufficient to insure safe liquidity invariance under the presumed Right to Rollback or Right to Invalidate and Migrate |
|X| Right to Rollback | Operators may revert or roll back ledger versions prior to the Bilbao Model concluding its role as a genesis stage  |
|X| Right to Invalidate and Migrate | Operators may invalidate or migrate elements of state prior to the Bilbao Model concluding its role as a genesis stage. |
|X| Low-cost DA | The model assumes that the cost of the DA is low, for example that in internal or testnet environment is used for the genesis DA. This allows for concerns about gas fees to be deferred until the network is more stable, i.e., for immediate financial risks to the network to be regarded as negligible. |
|X| Low-cost Settlement | The model assumes that the cost of settlement is low, for example that in internal or testnet environment is used for the genesis settlement. This allows for concerns about gas fees to be deferred until the network is more stable, i.e., for immediate financial risks to the network to be regarded as negligible. |
|X| Signers Whitelist (Optional) | The model assumes that the signers are whitelisted and that the whitelist can be updated by the governing body. This increases the trustedness of the genesis ceremony and can be used to ensure that the network is not compromised by a malicious actor. |
| **Operational Assumptions** | | |
|X| **Low Availability Requirements** | Crashes are allowed to occur frequently. The state of the network is critical; its liveness is not. |
|X| **Fixes Can be Introduced Prior to Relinquishing Rights** | Once the Right to Rollback and the Right to Invalidate and Migrate are relinquished, all ability to fix vulnerabilities introduced in genesis state will be lost. To this end, it is assumed that outstanding concerns at the time of transition to the next stage, or else the network would forever remain under the Bilbao Model. |
|X| **Trust of Governance** | Users are willing to trust governing body with the operations described.  |

### Pros
1. **Delayed calculation of rewards to cover centralized expenses**: because fees are held in the gas pool, the governing body need not calculate rewards which would be used to cover their own operating expenses until control of the governance is transferred to the community. The governing body can, for example, decide to use a percentage of captured gas to pay the centralized operators when a more stable token price is known some time after the L2 has been operational.
2. **Usable but recoverable period of network liveness**: the model allows for an early-stage network to be introduced with a high level of control over the network's state. This allows for the network to be introduced with the potential for long-term implications which is critical to network utility, while at the same time minimizing the implication of early misuse.

### Cons
1. **Highest trust in governance**: the model requires complete trust in the governing body. 
2. **1:1 token correlation**: the model asserts a 1:1 token correlation between the L1 staking and L2 gas tokens. This may not be desirable in all cases as exploits on the bridge may compromise the security of staking on the L1 or sybil resistance on the L2.

## Verification
