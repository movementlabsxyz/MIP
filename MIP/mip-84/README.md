# MIP-84: Lock-Mint Native Bridge: Basics of Relayer trust assumptions

- **Description**: This MIP clarifies the trust assumptions for the Relayer, and what consequences should be drawn from these.
- **Authors**: Andreas Penzkofer
- **Desiderata**: [MD-74](https://github.com/movementlabsxyz/MIP/blob/mip/rate-limiter-lock-mint-bridge/MD/md-74/README.md)
- **Approval**: :white_check_mark:

## Abstract

The lock/mint-type bridge has the following core actors and components: a user who initiates a transfer, a bridge operator, bridge contracts that facilitate the transfer, and a Relayer that submits the completion of the transfer to the bridge contracts.

The trust assumptions on the Relayer component have significant implications for the security of the bridge and they can introduce the need for additional components.

---
![alt text](image.png)

**Figure 1**: _The Relayer is in charge of _relaying_ bridge transactions. If a user initiates a bridge transfer request on the L2 with a transaction $T(s,r,a)$ with a sender $s$, recipient $r$, for an amount $a$, we expect the Relayer to relay the request to the L1 with a matching transaction $T'(s,r,a)$. However, a compromised or buggy Relayer may tamper with the bridge transfer data and relay $s', r', a'$ where $s', r', a'$ may differ from $s, r,a$. A fraudulent or buggy Relayer may also create a transaction $T'(s'',r'',a'')$, without a corresponding transaction $T(s'',r'',a'')$._

---

In a scenario based approach we clarify minimally required components and why they are needed. We distinguish between a trusted, partially trusted, and untrusted Relayer (with proofs).

## Motivation

We need to clarify the trust assumptions for the Relayer and what consequences should be drawn from these. In many cases a rate limitation may be necessary, see also the Appendix [A1: Eigenlayer AVS](#a1-background-eigenlayer).

This addresses the following desiderata in [MD-74](https://github.com/movementlabsxyz/MIP/blob/mip/rate-limiter-lock-mint-bridge/MD/md-74/README.md#D1):

- D1 : Specify the actors and their trust assumptions
- D2 : Specify the risks and threats from components

#### Base assumptions

We make the following base assumption:

1. All contracts are secure and reliable.
1. The bridge operator is trusted.

## Specification

_The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174._

We define the following terms:

- **Trusted** : A component is trusted if it is assumed to be secure and reliable. No errors in the component can occur. Nor keys can get compromised.
- **Untrusted** : A component is untrusted if it can have bugs, or misconfigurations, or worst case gets compromised (i.e., become byzantine). The component can stop/crash or tamper with messages, results of computations. It means an entity is not assumed to be reliable, necessitating verification or safeguards.
- **Insurance-based Untrusted** : We assume that faults or compromise is extremely unlikely. Under normal operations the component is secure and reliable. The rarity of these events permits that the operator takes care of resulting hardship. Protective measures are taken to reduce the maximally caused damage that the component can cause incase it becomes faulty / Byzantine by providing an insurance fund.
- **Approval/proof-based Untrusted** : Faults or compromise could happen frequently and at any point in time. Any action should be approved by a trusted party or require a proof of correctness.

#### Soundness and Completeness

1. **Sound Relayer** : the Relayer generates an appropriate event $(s,r,a)$ on the destination chain, only when the corresponding event $(s,r,a)$ on the source chain occurred.
1. **Complete Relayer** : the Relayer does not fail to produce the event $(s,r,a)$ on the destination chain when the corresponding event $(s,r,a)$ on the source chain occurs.

### Trusted Relayer

**Assumption**: The Relayer is fully trusted to submit the completion of the transfer to the bridge contracts.

**Soundness / Completeness**: There is no formal argument as to why the Relayer would be complete or sound, other than it being capable of performing the actions of listening for and generating $(s,r,a)$ events.

**Risks**: We assume the Relayer is safe.

**Consequence**:
The Relayer always submits the correct completion transaction, i.e. without tampering with the sender, receiver and amount. The Relayer can transfer without any restrictions. Since the Relayer is trusted, no additional components are needed. Furthermore, no additional protective measures are needed.

### Insurance-based untrusted Relayer

**Assumption**: The Relayer is insurance-based untrusted. The completion of the transfer to the bridge contracts is expected to operate correctly. However, in case of an error, the bridge operator can compensate for the error.

**Soundness / Completeness**: We don't entirely trust the relaying mechanism, but we provide insured bounds. The value of the insurance fund is greater than the value that can be transferred within a certain time frame. The latter requires a rate limitation. This mechanism permits eventual soundness and completeness. See below the solution parts.

**Risk**: The Relayer may be erroneous, misconfigured, or compromised. The Relayer may submit the completion of the transfer to the bridge contracts with errors.

1. Abuse of Mint/Release: The Relayer may transfer tokens without a respective initiation on the source chain.
2. Miscalculation: The Relayer may transfer the wrong amount of tokens.
3. Misallocation: The Relayer may transfer tokens to the wrong address.
4. Censorship: The Relayer may never transfer certain tokens.
5. Error: The Relayer may submit invalid transfers leading to failed transfers.

**Consequence**:
User is affected: A complaint by the user should be individually handled. A mechanism to accept complaints MAY be provided. The complaint should be handled by a trusted party, such as a governance component.

Abuse / Miscalculation: The Relayer may release (mint) excessively tokens on the L1 (L2). Any token that is released (minted) on the target chain without a corresponding burn (lock) on the source chain will increase the total circulating supply across L1 and L2. However, the Bridge Operator MUST ensure that the total circulating supply of the token remains constant.

**Solution Part 1:**
The bridge operator MUST learn about the excessive minting (unlocking) through some monitoring system. The monitoring service MAY be only an initial warning system that informs the bridge operator to take action. This action could involve halting the bridge or starting an investigation.

The Informer, see [MIP-71](https://github.com/movementlabsxyz/MIP/pull/71), addresses this part.

**Solution Part 2:**
The bridge operator MUST have the ability to halt the bridge. This is necessary to prevent further excessive minting (unlocking) of tokens.

**Solution Part 3:**
The bridge operator MUST compensate for the excessive minting (unlocking) by burning (locking) the excessive minted tokens on the target chain. This requires the provision of a fund from which the bridge operator can burn (lock) the excessive minted tokens.

The Insurance Fund, see [MIP-50](https://github.com/movementlabsxyz/MIP/pull/50), addresses this part.

**Solution Part 4:**
In a system with low latency, or unbounded transfer size the Relayer may be able to mint (release) tokens that far exceed the Insurance Fund `value_insurance`. To prevent this a rate limitation is necessary, which limits the maximum amount of tokens that can be transferred with a certain reaction time `time_react` of the bridge operator.

Since the Relayer operates on the target chain, the rate limitation MUST be implemented on the target chain. Furthermore, it MUST consider `time_react` and `value_insurance`.

Furthermore, since the Relayer is limited by the rate limitation, the intake of transfers on the source chain MUST be limited by the rate limitation. The rate limitation on the source chain MUST consider the rate limitation on the target chain.

Since this is a symmetrical problem, this rate limitation MUST be implemented in both directions.

The Rate Limiter, see [MIP-74](https://github.com/movementlabsxyz/MIP/pull/74) addresses this part.

### Approval/proof-based untrusted Relayer

**Assumption**: The Relayer is untrusted to submit the completion of the transfer to the bridge contracts. A proof or approval is required.

**Risk**: The source chain may be faulty or reorg. Hence only finalized proofs or approvals should be accepted (finalized with respect to the source chain).

**Consequence**: The transfer has to consider the finality on the source chain. The transfer may also take a long time to complete. For example in optimistic rollups the finality is reached after 1 week.

**Solution with ZK Chains**:

- L2-->L1 direction:

The Relayer submits a proof on L1 that the transfer was initiated successfully on the L2 chain and is part of the L1 verified ZK proof of the commitment of the L2 chain.

- L1 --> L2 direction:

Not clear.

- Timing:

The expected time for the completion of the transfer is the time it takes is in the range of ZK proofs.

**Solution with Optimistic Chains**:

- L2-->L1 direction:

The Relayer submits a proof on L1 that the transfer was initiated successfully on L2 and is part the commitment on L1.

Since the finality is crypto-economically protected by watchtower nodes, a rate limitation may have to be applied that ensures, that the value that can be transferred is crypto-economically protected. Otherwise the watchtower nodes may be incentivized to collude and finalize invalid transfers.

- L1 --> L2 direction:

Not clear.

- Timing:

The expected time for the completion of the transfer is the time it takes is in the range of optimistic proofs.

**Solution with FFS Chains**:

!!! warning The following is only a first sketch and should be updated once an MIP specifically for this solution exists.

- L2-->L1 direction:

The Relayer submits a proof on L1 that the transfer was initiated successfully and is within the commitment on L1 (e.g. via Merkle).

- L1 --> L2 direction:

Option 1: Each FFS validator node MUST run a service that can read the L1 chain for successful initiate transfers. Thus they would be able to discover invalid transfers and reject them.
Option 2: Each FFS validator node MUST run a service that obtains (or gets from a trusted source) Transaction Merkle roots from the L1 blocks. The Relayer provides a proof that the transfer was initiated successfully and is finalized.

- Rate Limiting:

Since the finality is crypto-economically protected by the FFS nodes with `value_FFS_stake`, a rate limitation may have to be applied that ensures, that the value that can be transferred within a given time is crypto-economically protected by the FFS validator set. Otherwise the FFS validator nodes may be incentivized to collude and include invalid transfers that could drain the locked L1 token pool (or equivalently mint until a possible supply limit on the L2).

However, compared to the optimistic chains there is no watchtower service that can invalidate malicious checkpoints (i.e. checkpoint produced by collusion) and thus FFS validator nodes may have nothing at stake, raising the question whether there needs to be some operator with reaction time `time_react` that can halt the bridge and possibly slash the FFS validator nodes.

For a solution on a rate limitation see Section [Insurance-based untrusted Relayer](#insurance-based-untrusted-relayer). Replace `value_insurance` by `value_FFS_stake`.

- Timing:

The expected time for the completion of the transfer is the time it takes is in the range of Postconfirmations and L1 finality time.

## Reference Implementation

## Verification

## Changelog

## Appendix

### A1: Background EigenLayer

In order to protect the protocol from exploits and potential losses, rate limiting is essential. For comparison the white paper [EigenLayer: The Restaking Collective](https://docs.eigenlayer.xyz/assets/files/EigenLayer_WhitePaper-88c47923ca0319870c611decd6e562ad.pdf) proposes that AVS (Actively Validated Services) can run for a bridge and the stake of validators protects the transferred value crypto-economically through slashing conditions. More specifically section 3.4 Risk Management mentions

> [...] to restrict the Profit from Corruption of any particular AVS [...] a bridge can restrict the value flow within the period of slashing.

Eigenlayer provides the following definition on strong economic security in their [white paper (EIGEN: The Universal Intersubjective Work Token)](https://docs.eigenlayer.xyz/assets/files/EIGEN_Token_Whitepaper-0df8e17b7efa052fd2a22e1ade9c6f69.pdf):

> *Formal Definition of Strong crypto-economic Security*
If [a bridge] acquires more [crypto-economic] security than the harm it can suffer from an attack within the interval $T_{redeem}$ slots, then it achieves strong crypto-economic security, i.e.<br>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*[Economic]-security ≥ Harm-from-corruption [..] in $T_{redeem}$ slots*

> [..] consider a [..] bridge [..] for a rollup, which has a $(X, T)$-rate-limit [..]. Now if [$T<T_{redeem}$,] the total value transacted by the bridge is less than $X$ during any attack period, and therefore the harm from corruption for the $T$ period is less than or equal to $X$. If the [crypto-economic] security is greater than X then this [bridge] works correctly.

In essence this boils down to rate limit the bridge by considering

- how long does it take to finalize transfers (ZK, optimistic)
- how much value can be protected crypto-economically

In our setting we trust the bridge operator, and thus we replace

- finalization by the reaction time of the operator
- the staked value by the insurance fund

---
## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).
