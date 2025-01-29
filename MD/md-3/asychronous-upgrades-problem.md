# Asynchronous Upgrades, Fork Creation, and Fork Stake Problems

The _Asynchronous Upgrades Problem_ is an issue with the current implementation of MCR that arises when a partition of the network upgrades to a new version of the protocol while another partition remains on the old version. This can lead to failure to agree upon the current block height and currently would require the deployment of a new settlement contract to resolve.

This state of MCR can arise in other contexts than upgrades. The use of the upgrade scenario is merely illustrative.

It is resolvable by allowing network forks in a partial synchronous manner. However, this leads to a series of questions of when rewards and penalties should be applied to commitments on these forks. These questions are the crux of the [Fork Creation Problem](#fork-creation-problem) and [Fork Stake Problem](#fork-stake-problem).

The conclusion drawn from the Fork Creation Problem is that penalties for creating a new fork cannot be implemented synchronously with the block commitments constituting that fork as well.

The Fork Stake Problem suggests that rewards also cannot be implemented synchronously with their commitments, in order to ensure temporary forks do not have stake-based incentives.

## Asynchronous Upgrades Problem

Consider two honest partitions of the network A and B. At a given block height $h$, Partition A upgrades to a new version of the chain containing a state derivation $S_A(h)$. At the same block height, Partition B remains on the old version of the chain containing a state derivation $S_B(h)$ s.t. $S_A(h) \neq S_B(h)$.

Because a fixed proportion of the stake is needed to agree on the current block height $h$, the network will not be able to agree on $h$.

The network may be able to provisionally agree on $h\' > h$ within the block tolerance $\tau$ of the network. However, these agreements are never realized because $h$ remains undecided.

## Solving the Problem with Partially Synchronous Forks

The Asynchronous Upgrades Problem can be resolved by allowing the network to fork in a partially synchronous manner. That is, the network can agree at a defined point in time $t_{h - 1} + \epsilon$ to fork into two chains w/o loss of generality, one with state derivation $S_A(h)$ and the other with state derivation $S_B(h)$.

Within the current epoch, stake weights would then be split between the two chains, Fork A and Fork B, w/o loss of generality based on the votes represented at the fork point at the time of splitting. In other words, the votes are deemed unanimous at the fork point.

In the literal case of an upgrade, the Partition B may then rejoin its stake in Partition A in the next epoch. This effectively means, however, that Partition B would not have any stake-based incentive to complete its upgrade, instead preferring to continue to commit to the fork it created until the next epoch.

In the event a long-lived fork is intended by Partition B, MCR will have provided a usable means to facilitate this fork.

## Fork Creation Problem

Assume rewards issued on Fork B are non-zero and continue to be meaningful and that slashing only occurs at the fork point owing to the initial disagreement.

**Rationale**: for a continued Fork B to be rational for Partition B, we state that

```math
U_B = U_{B, s} + \frac{U_{B, r}}{1 - \gamma} + U_{B, p} \geq U_{A, s} + \frac{U_{A, r}}{1 - \gamma} = U_A
```

That is, the utility of the state represented by Fork B $U_{B, s}$ plus the discounted repeated utility of the rewards $\frac{U_{B, r}}{1 - \gamma}$ plus some penalty $U_{B, p} < 0$ must be greater than or equal to the utility of the state represented by Fork A $U_{A, s}$ plus the discounted repeated utility of the rewards $\frac{U_{A, r}}{1 - \gamma}$. (Note the utility of the state could also be assigned a discounting model, however, this is considered extrinsic to the model of the problem provided herein.)

**Positive Rewards for Fork B**: since rewards on Fork B are non-zero and Partition B is in agreement with Fork B, it follows that $\frac{U_{B, r}}{1 - \gamma} > 0$

**Initial Penalty for Fork B**: because there was an initial disagreement at the fork point leading to a slashing of Partition B's stake, it follows that $U_{B, p} < 0$

**Should Partition B Recover**: we assume Partition B disagrees with Fork A and should not recover, it follows tautologically that $\frac{U_{A, r}}{1 - \gamma} < 0$.

In cases where Partition B can recover--e.g., can reset its state, perform an appropriate upgrade, or similar--we should expect the fork with greater rewards should appropriately align the behavior of the Partitions. 

**State Indifference**: assuming $U_{B, s} = U_{A, s}$, i.e., Partition B is indifferent between the states, it follows that $U_B < U_A$ iff $U_{B, p} < \frac{U_{A, r}}{1 - \gamma} - \frac{U_{B, r}}{1 - \gamma}$. That is, only if initial penalty of Fork B exceeds the difference between disagreeing on the Fork A and the benefit of agreeing on Fork B.

**Individualism**: however, in the current MCR slashing model, the initial penalty would only be assigned in the disagreement, i.e., $U_{B, p} = U_{A, r} \Rightarrow U_{B, p} > \frac{U_{A, r}}{1 - \gamma} > \frac{U_{A, r}}{1 - \gamma} - \frac{U_{B, r}}{1 - \gamma}$. This would imply that Partition B would always be better off disagreeing with Fork A--even in the event where it is indifferent between the states.

This means that penalties for creating a new fork cannot be implemented synchronously with block commitments if we want to incentivize agreement on the current block height while allowing forking. The fork point needs to be known s.t. a heftier penalty can be assigned to the initial disagreement $U_{B, p}$ after the fork point is known. In other words, an initial fee must be paid to create a fork.

Note that this holds even when separate tokens are issues on separate forks. The new token will have some value relative to the old token and utility in the game more broadly. That is, even the stake-based portions of this model can have extrinsic interpretations.

## Fork Stake Problem

The allowance of long-lived forks presents another problem for MCR. That is, currently MCR only rewards in one token. However, if this continues whilst allowing forking, network would be incentivized to create spurious forks to use the minting capabilities of MCR to create more tokens.

### Minimum Stake Requirements

If you attempt to account for this by creating minimum stake requirements for a new fork, you will reintroduce the Asynchronous Upgrades Problem for some partitions of the network.

### Discounting Rewards by Fork Weight

You may attempt to account for this by discounting the rewards for Fork B for as long as it is not the heaviest staked fork, i.e., $W_B < \max W$ where $W$ is the set of stake weights of all forks at their tip. However, you must reconsider the Fork Creation problem to ensure it is only $U_{B, s}$, i.e., extrinsic utility of state, that rationalizes the continued existence of Fork B. In other words, you must ensure there are no short-term payoffs for creating a spurious fork within the reward system itself.

A safer approach, however, to handle the Fork Stake problem generally is to simply create new coins a Fork Points. This would likely however require a rewrite and rearchitecting of the MCR contracts, as this is a difficult feature to implement in ETH.

### Temporary Forks

Finally, in many BFT protocols, temporary forks are allowed before they are reconciled by selecting the appropriate fork by a fork choice rule. The rewards earned by contributing to the temporary fork are represented only along this fork and thus $\frac{U_{B, r}}{1 - \gamma} = 0$ if the fork is indeed temporary.

Unfortunately, MCR is restricted by representation and synchronicity problems in this regard. Because there is only one canonical replica of the chain decided upon by the base layer's, ETH's, BFT and because rewards need to be issued synchronously on this base layer, we would be unable to ensure $\frac{U_{B, r}}{1 - \gamma} = 0$ if rewards are issued immediately.

The solution is thus to issue rewards at some height $h + \zeta$ where $\zeta$ is the maximum lifetime of a temporary fork.

While temporary forks can be used to properly align incentives for short-term asynchrony, it is does not allow for the situation where long-lived $U_{B, s}$ is considered honest under chain governance and properly incentivized. That is, we can not expect that every fork should be reconciled.
