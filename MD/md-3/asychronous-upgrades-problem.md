# Asynchronous Upgrades, Fork Creation, and Fork Stake Problems
The Asynchronous Upgrades Problem is an issue with the current implementation of MCR that arises when a partition of the network upgrades to a new version of the protocol while another partition remains on the old version. This can lead to failure to agree upon the current block height and currently would require the deployment of a new settlement contract to resolve. 

This state of MCR can arise in other contexts than upgrades. The use of the upgrade scenario is merely illustrative and used for naming. 

It is resolvable by allowing network forks in a partial synchronous manner. However, this leads to a series of questions of when rewards and penalties should be applied to commitments on these forks. These questions are the crux of the Fork Creation and Fork Stake Problem.

The conclusion drawn from the Fork Creation Problem is that penalties for creating a new fork cannot be implemented synchronously with block commitments.

## Asynchronous Upgrades Problem
Consider two honest partitions of the network A and B. At a given block height $h$, Partition A upgrades to a new version of the chain containing a state derivation $S_A(h)$. At the same block height, Partition B remains on the old version of the chain containing a state derivation $S_B(h)$ s.t. $S_A(h) \neq S_B(h)$.

Because a fixed proportion of the stake is needed to agree on the current block height $h$, the network will not be able to agree on $h$. 

The network may be able to provisionally agree on $h' > h$ within the block tolerance $\tau$ of the network. However, these agreements are never realized because $h$ remains undecided. 

## Solving the Problem with Partially Synchronous Forks
The Asynchronous Upgrades Problem can be resolved by allowing the network to fork in a partially synchronous manner. That is, the network can agree at a defined point in time $t_{h - 1} + \epsilon$ to fork into two chains w.l.o.g., one with state derivation $S_A(h)$ and the other with state derivation $S_B(h)$.

Within the current epoch, stake weights would then be split between the two chains, Fork A and Fork B, w.l.o.g. based on the votes represented at the fork point at the time of splitting. In other words, the votes are deemed unanimous at the fork point.

In the literal case of an upgrade, the Partition B may then rejoin its stake in Partition A in the next epoch. This effectively means, however, that Partition B would not have any staked motivation to complete its upgrade, instead preferring to continue to commit to the fork it created until the next epoch.

In the event a long-lived fork is intended by Partition B, MCR will have provided a usable means to facilitate this fork. 

## Fork Creation Problem
Assume towards definition of the problem that rewards issued on Fork B are non-zero in perpetuity and that slashing only occurs at the fork point owing to the initial disagreement. 

For a continued Fork B to be rational for Partition B, we state that $U_B = U_{B, s} + \frac{U_{B, r}}{1 - \gamma} + U_{B, p} \geq U_{A, s} + \frac{U_{A, r}}{1 - \gamma} = U_A$. That is, the utility of the state represented by Fork B $U_{B, s}$ plus the discounted repeated utility of the rewards $\frac{U_{B, r}}{1 - \gamma}$ must be greater than or equal to the utility of the state represented by Fork A $U_{A, s}$ plus the discounted repeated utility of the rewards $\frac{U_{A, r}}{1 - \gamma}$. (Note the utility of the state could also be assigned a discounting model, however, this is considered extrinsic to the model of the problem provided herein.)

Since rewards on Fork B are non-zero and Partition B is in agreement with Fork B, it follows that $\frac{U_{B, r}}{1 - \gamma} > 0$

Because there was an initial disagreement at the fork point leading to a slash of Partition B's stake, it follows that $U_{B, p} < 0$

Because Partition B disagrees with Fork A, it follows that $\frac{U_{A, r}}{1 - \gamma} < 0$. 

Assuming $U_{B, s} = U_{A, s}$, i.e., Partition B is indifferent between the states, it follows that $U_B < U_A$ iff $U_{B, p} < \frac{U_{A, r}}{1 - \gamma} - \frac{U_{B, r}}{1 - \gamma}$. That is, only if initial penalty of Fork B exceeds the difference between disagreeing on the Fork A and the benefit of agreeing on Fork B.

However, in the current MCR slashing model, the initial penalty would only be assigned in the disagreement, i.e., $U_{B, p} = U_{A, r} \rightarrow U_{B, p} > \frac{U_{A, r}}{1 - \gamma} > \frac{U_{A, r}}{1 - \gamma} - \frac{U_{B, r}}{1 - \gamma}$. This would imply that Partition B would always be better off disagreeing with Fork A--even in the event where it is indifferent between the states.

This means that penalties for creating a new fork cannot be implemented synchronously with block commitments if we want to incentivize agreement on the current block height while allowing forking. The fork point needs to be known s.t. a heftier penalty can be assigned to the initial disagreement $U_{B, p}$. In other words, an initial fee must be paid to create a fork.

## Fork Stake Problem
The allowance of long-lived forks presents another problem for MCR. That is, currently MCR only rewards in one token. However, if this continues whilst allowing forking, network would be incentivized to create spurious forks to use the minting capabilities of MCR to create more tokens.

If you attempt to account for this by creating minimum stake requirements for a new fork, you will reintroduce the Asynchronous Upgrades Problem for some partitions of the network.

You may attempt to account for this by discounting the rewards for Fork B for as long as it is not the heaviest staked fork, i.e., $W_B < W_A$. However, you must reconsider the Fork Creation problem to ensure it is only $U_{B, s}$, i.e., extrinsic utility, that rationalizes the continued existence of Fork B. In other words, you must ensure there are no short-term payoffs for creating a spurious fork within the reward system itself.

A safer, however, to handle the Fork Stake problem generally is to simply create new coins a Fork Points. This would likely however require a rewrite and rearchitecting of the MCR contracts, as this is a difficult feature to implement in ETH. 