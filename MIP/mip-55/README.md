# MIP-55: The Bilbao Model

- **Description**: Proposes an L2 model with Native Bridge and Postconfirmation protocol that features a Gas Deficit Minter, Native Bridge Insurance Account, low-cost DA and settlement, high centralized control, and ultimately high operational assumptions.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Desiderata**: [MD-38](https://github.com/movementlabsxyz/MIP/pull/38)

## Abstract

We define the Bilbao Model as L2 (Level 2) model with Native Bridge (**NB**) and Postconfirmation protocol that features a Gas Deficit Minter, Native Bridge Insurance Account, low-cost DA, high centralized control, and ultimately high operational assumptions. At the core of this model is the highly-controlled use of trusted signers with high liquidity to replace components proposed in the [Biarritz Model](https://github.com/movementlabsxyz/MIP/pull/54).

The model may be extended beyond postconfirmation to feature a full Fast Finality Settlement (FFS), in which case we could refer to main characteristics also as **NB-FFS**.

## Motivation

The Bilbao Model is intended as a complete response to [MD-38](https://github.com/movementlabsxyz/MIP/pull/38) and a reduction of the [Biarritz Model](https://github.com/movementlabsxyz/MIP/pull/54).

## Specification

_The conventions of [MIP-53: Conventions for Proposing Progressive L2 Models](../mip-53) are applied._

| Category / _Criterion_ | Evaluation |
|-----------|------------|
| **General** | |
| _When to use_ | During a genesis period and after after which the resulting state is intended to be accepted as canonical entry point for a progressive more decentralized network. |
|| The benefits to the network of an immediate release against early technology outstrip the potential costs of failing to correctly resolve vulnerabilities introduced in a genesis state. |
| _Suitable preceding models_ | NONE |
| _Suitable succeeding models_ | [MIP-54: The Biarritz Model](https://github.com/movementlabsxyz/MIP/pull/54) |
| _Technological motivations_ | Contends with bridge fallibility under high operational assumptions. |
|| Allows for building genesis state which can be altered prior to launch. |
| _Usership motivations_ | Allows for early release of network. |
| **Components** | |
| _Gas Deficit Minter_ | We recognize the role of the Governed Gas Pool as one which can be replaced by simply computing and minting the burned gas to a governed account retroactively. The Gas Deficit Minter thus takes on the role of allowing for the manual capture of gas fees. |
| _Bridge Insurance Account_ | We recognize the role of the Bridge Insurance Fund as similar to that of a singular account which can replace bridge losses. While the guarantees are weaker than those proposed under [MIP-54: The Biarritz Model](https://github.com/movementlabsxyz/MIP/pull/54), this can be sufficient to insure safe liquidity invariance under the presumed Right to Rollback or Right to Invalidate and Migrate |
| _Right to Rollback_ | Operators may revert or roll back ledger versions prior to the Bilbao Model concluding its role as a genesis stage  |
| _Right to Invalidate and Migrate_ | Operators may invalidate or migrate elements of state prior to the Bilbao Model concluding its role as a genesis stage. |
| _Low-cost DA_ | The model assumes that the cost of the DA is low, for example that an internal or testnet environment is used for the genesis DA. This allows for concerns about gas fees to be deferred until the network is more stable, i.e., for immediate financial risks to the network to be regarded as negligible. |
| _Low-cost Settlement_ | The model assumes that the cost of settlement is low, for example that an internal or testnet environment is used for the genesis settlement. This allows for concerns about gas fees to be deferred until the network is more stable, i.e., for immediate financial risks to the network to be regarded as negligible. |
| _Signers Whitelist (Optional)_ | The model assumes that the signers are whitelisted and that the whitelist can be updated by the governing body. This increases the trustedness of the genesis ceremony and can be used to ensure that the network is not compromised by a malicious actor. |
| **Operational Assumptions** | |
| _Low Availability Requirements_ | Crashes are allowed to occur frequently. The state of the network is critical; its liveness is not. |
| _Fixes Can be Introduced Prior to Relinquishing Rights_ | Once the Right to Rollback and the Right to Invalidate and Migrate are relinquished, all ability to fix vulnerabilities introduced in genesis state will be lost. To this end, it is assumed that outstanding concerns at the time of transition to the next stage are resolved, or else the network would forever remain under the Bilbao Model. |
| _Trust of Governance_ | Users are willing to trust governing body with the operations described.  |

### Pros

1. **Delayed calculation of rewards to cover centralized expenses**: because fees are held in the gas pool, the governing body need not calculate rewards which would be used to cover their own operating expenses until control of the governance is transferred to the community. The governing body can, for example, decide to use a percentage of captured gas to pay the centralized operators when a more stable token price is known some time after the L2 has been operational.
2. **Usable but recoverable period of network liveness**: the model allows for an early-stage network to be introduced with a high level of control over the network's state. This allows for the network to be introduced with the potential for long-term implications which is critical to network utility, while at the same time minimizing the implication of early misuse.

### Cons

1. **Highest trust in governance**: the model requires complete trust in the governing body.
2. **1:1 token correlation**: the model asserts a 1:1 token correlation between the L1 staking and L2 gas tokens. This may not be desirable in all cases as exploits on the bridge may compromise the security of staking on the L1 or sybil resistance on the L2.

## Verification

## Changelog
