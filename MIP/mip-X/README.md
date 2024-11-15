# MIP-\<number\>: Informer for the Native Bridge 
- **Description**: The Informer collects data from L1 and L2 that is critical to the safe operation of the Native Bridge.
- **Authors**: [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)

## Abstract

The Informer for the Native Bridge is introduced to collect information about the state from L1 and L2 and provide this information to components of the Native Bridge. The provided information is critical to the safe operation of bridge components such as the Rate-Limiter, the Security Fund, and the Bridge Operator.

## Motivation

Several components should react if the bridge is under attack. However these components require knowledge about the states of L1 and L2. In particular, the considered components are the insurance fund, see [MIP-50](https://github.com/movementlabsxyz/MIP/pull/50) and the Rate-Limiter, see [MIP-56](https://github.com/movementlabsxyz/MIP/pull/56). In addition the operation of these components may be handled via a governance, which could also rely on state information.

The Informer is a trusted component that provides this information.

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

![Overview](overview.png)
*Figure 1: Dependencies of components on the Informer mechanism in the Native Bridge.*

The informer collects information about the state of liquid `$L1MOVE` and `$L2MOVE` and provides this information to components of the Native Bridge. The Informer is a trusted component that is critical to the safe operation of the Native Bridge.

1. The Informer is a component that MUST run a node or client on L1 and on L2.
1. On L1 the Informer SHOULD read the liquid supply `L1MOVE_circulating` of `$L1MOVE` token at the $k$-confirmed state. The definition of $k-confirmed$ is given in [Issue-838](https://github.com/movementlabsxyz/movement/issues/838).
1. On L2 the Informer SHOULD read the liquid supply `L2MOVE_circulating` of `$L2MOVE` token at the $m$-confirmed state.
1. The values for $k$ and $m$ MUST be the same as the value of $k$ and $m$ in the bridge parameters.
1. Since L1 blocks have timestamps we say the Informer reads `L1MOVE_circulating(t_L1)`.
1. We assume that L2 blocks acquire timestamps from the sequencing protocol, e.g. Celestia. Thus the Informer reads `L2MOVE_circulating(t_L2)`.

**TLDR: Informer Information and Warnings**

The Informer SHOULD provide the information about the circulating `$L1MOVE` and `$L2MOVE` supply `MOVE_circulating(t)`, [see here](#measuring-circulating-supply). The circulating supply is lowered from the desired maximum circulating supply `MOVE_Max` by the inflight tokens, [see here](#inflight-tokens). 

> ![NOTE] The inflight tokens are in principle known by the Relayer.

The Informer SHOULD provide a warning if the circulating supply exceeds the maximum circulating supply `MOVE_Max`. However, as described [here](#difference-in-layer-timestamps), the measured circulating supply could be above `MOVE_Max` due to the difference in timestamps between L1 and L2, thus any warning has to be taken with caution.

#### Measuring circulating supply

The circulating supply of `$MOVE` token `MOVE_circulating(t) = L1MOVE_circulating(t) + L2MOVE_circulating(t)`.

> [!WARNING] If we do not want to run into the risk that measured circulating supply may become invalidated through reorgs we COULD consider finalized states only, i.e. we would require `t_now - t > max{t_L1finality,t_L2finality}`.


#### Inflight tokens

Inflight tokens are tokens that are locked (burned) on L1 (L2) but that are not yet minted (unlocked) on L2 (L1).

> [!NOTE] The amount of inflight tokens would be known by a trusted centralized relayer.

We refer to the following illustration for a bridge transfer from L1 to L2, which is taken from [MIP-39](https://github.com/movementlabsxyz/MIP/pull/39).

![L1 to L2 Transfer](L1ToL2.png)
*Figure 2: Illustration of L1 to L2 token transfer process. Both the good path (transfer succeeds) and the bad path (transfer fails due to timeout) is shown.*

Assume some `$L1MOVE` is locked (with finalization) at time $t_1$.

- On the **good path** the equivalent `$L2MOVE` token is minted on L2 at time $t_2$, where $\Delta t = t_2 - t_1 \in$`[2 * t_L2finality, t_L2finality + timelock2]`. In other words the total circulating supply of `$MOVE` is decreased by the amount of locked `$L1MOVE` tokens for $\Delta t$.
- On the **bad path** there is no equivalent minted `$L2MOVE` token on L2 minted. Instead, after `timelock1` the locked `$L1MOVE` token is unlocked on L1. The total circulating supply of `$MOVE` is decreased by the amount of locked `$L1MOVE` tokens for `timelock1`.

For the inverse transfer from L2 to L1 the same arguments hold.

The rate limit is determined by the reaction time of the bridge operator `risk_period`, and the value `security_fund` locked in the **Security Fund**, see [MIP-50](https://github.com/movementlabsxyz/MIP/pull/50). We assume that L1->L2 is rate limited by `rate_limit_L1L2` and L2->L1 is rate limited by `rate_limit_L2L1`.
  
Then the maximum amount of tokens that can be inflight is determined by the bad path:

- `inflight_L1L2 = ratelimit_L1L2 * risk_period * inflight_factor` for L1->L2, and
- `inflight_L2L1 = ratelimit_L2L1 * risk_period * inflight_factor` for L2->L1.

where `inflight_factor = 1 + timelock / risk_period`. If we consider only the good path then the maximum amount of tokens that can be inflight is

- `inflight_L1L2 = ratelimit_L1L2 * risk_period * 2` for L1->L2, and
- `inflight_L2L1 = ratelimit_L2L1 * risk_period * 2` for L2->L1.

#### Difference in Layer Timestamps

The timestamps of the two layers are not synchronized. We assume that the difference is negligible, however, for correctness, the implications of a drift between the L1 and L2 clocks should be considered. Moreover, the clocks of the layers progress discretely. This means that the Informer has to read at slightly different times on L1 and L2.

This error in the calculation of circulating token `error_token_circulating` due to difference in timestamps between L1 and L2 can be net positive. Thus the measured circulating supply of `$MOVE` could be above `MOVE_max`.

Since the time difference should be small at most two rate limit intervals should be considered, i.e. `error_token_circulating <= (ratelimit_L1L2 + ratelimit_L2L1 ) * risk_period * 2`.


### Recommendations

1. It is recommended that $k>=32$, i.e. at least one epoch.
1. It is recommended that $m=3$.
On L2 we assume a pBFT-like algorithm for the consensus on transaction-blocks, If the protocol is pipelined, this would indicate that 3 blocks are required to finalize. If all phases of the BFT consensus algorithm are handled within one block, then $m=1$ is sufficient.
With Celestia this would be approximately after $36sec$. (The block time of $12sec$ is taken from the [Celestia documentation](https://docs.celestia.org/tutorials/integrate-celestia) and the [Celestia explorer](https://celestia.explorers.guru/)).

### Optimizations

1. Instead of reading the $k$-confirmed state, the Informer COULD consider the finalized state. The finalized state is achieved approximately after two epochs (one epoch holds 32 blocks if no blocks are missed), see [this tweet](https://x.com/LogarithmicRex/status/1578540111930699778) and [this article](https://ethos.dev/beacon-chain).
1. For security purposes the Informer COULD consider only the state produced by L2 blocks that have been [postconfirmed](https://github.com/movementlabsxyz/MIP/pull/37) on L1.

## Reference Implementation

<!--
  The Reference Implementation section should include links to and an overview of a minimal implementation that assists in understanding or implementing this specification. The reference implementation is not a replacement for the Specification section, and the proposal should still be understandable without it.

  TODO: Remove this comment before submitting
-->

## Verification

<!--

  All proposals must contain a section that discusses the various aspects of verification pertinent to the introduced changes. This section should address:

  1. **Correctness**: Ensure that the proposed changes behave as expected in all scenarios. Highlight any tests, simulations, or proofs done to validate the correctness of the changes.

  2. **Security Implications**: Address the potential security ramifications of the proposal. This includes discussing security-relevant design decisions, potential vulnerabilities, important discussions, implementation-specific guidance, and pitfalls. Mention any threats, risks, and mitigation strategies associated with the proposal.

  3. **Performance Impacts**: Outline any performance tests conducted and the impact of the proposal on system performance. This could be in terms of speed, resource consumption, or other relevant metrics.

  4. **Validation Procedures**: Describe any procedures, tools, or methodologies used to validate the proposal against its requirements or objectives. 

  5. **Peer Review and Community Feedback**: Highlight any feedback from peer reviews or the community that played a crucial role in refining the verification process or the proposal itself.

  TODO: Remove this comment before submitting
-->

Needs discussion.

---

## Errata
<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the proposal in which the error was identified.

  TODO: Maintain this comment.
-->

## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).
