# Rollover Gas
The current suggestion for the implementation of MCR is to offset the gas costs for the last attester. This would be done transparently, by rewarding the last attester for their work in additional compensation for this gas cost. This would be a simple solution to the problem of disincentivizing the last attester. However, this solution is naive as it may incentivize an attempt to be the last attester--introducing an incentive for latency to the chain.

## Base Model
We model the utility of the offset as follows...

```math
\begin{align}
&U_{n} = -E[G_{\mu}] \\
&U_{l} = \delta(|\mathcal{V}|)U_{o} - E[G_{\mathcal{V}}] \\
\end{align}
```
$U_{n}$ is the utility of any attester that is not last.

$U_{l}$ is the utility of the last attester.

$E[G]$ is the expected gas cost modeled as a random variable $G$.

$\delta(|\mathcal{V}|)$ is reward rate determined by the number of validators in the set $\mathcal{V}$.

Note that $E[G] \not\!\perp\!\!\!\perp \delta(|\mathcal{V}|)$, as the gas cost is a function of the number of validators in the set. This will be addressed in later sections.

For an attester with complete information not to attempt to be last, $E[U_{n}] > E[U_{l}]$ which would imply that the $\delta(|\mathcal{V}|) < g(|\mathcal{V}|)$ where $g$ the gas algebra applied be Ethereum. 

## Incomplete Information
However, an attester would not have complete information about whether the would be last. In general, this is unknowable because of FLP impossibility.

To model this, we will say an attester can play two strategies $L$ and $N$ where $L$ is the strategy to be last and $N$ is the strategy to not be last. The utility of these strategies is given by...

```math
\begin{align}
& U_{N} = P[W = 0] U_{n} + P[W = 1] U_{l} + E[P_{N}] \\
& U_{L} = P[W = 0] U_{n} + P[W = 1] U_{l} + E[P_{L}] \\
\end{align}
```
$W$ is a random variable indicating whether the attester is last.

$P_{N}$ is a random variable representing the price of attempting to commit as soon as possible. It can be implemented by the smart contract by giving greater rewards to those who commit earlier.

$P_{L}$ is the price of the strategy $L$ which is the price of attempting to be last. It can fall under the same mechanism as the above, in which case its expectation can be computed over a narrower range of the same distribution as $P_{N}$.

Under this model as long as $E[P_{N}] > E[P_{L}]$ the attester will choose the strategy $N$. Introspectively, this would be satisfied if $E[P_{N}] > \delta(|\mathcal{V}|)U_{o}$. 

However, the attester will really play a repeated game where she may either play $U_{N}$ or $U_{L}$ and end the game or wait for more information. Generally, the more rounds of this game the attester plays the larger the value of $P[W = 1]$. This is could result in sub-game perfect Nash Equilibria (SPNE) to play $U_{L}$ the precise implications of which are outside of the scope of this document. However, generally, these equilibria can be avoided by holding $P[W = 1]$ constant. 

In practice holding $P[W = 1]$ constant is difficult. 

Via mechanisms such as Pedersen Commitments, information about whether the attester would have a matching commitment to those already made could be concealed--thereby reducing $P[W = 1]$. However, under a well functioning chain, $P[W = 1]$ would still generally increase with added commitments as we would expect there will ultimately be at least $\frac{2}{3}$ of all voting power eventually represented.

If noisy commitments and attempts to hide stake were also introduced, that would further reduce $P[W = 1]$. However, again, the overall assumption is that $E[W = 1]$ is inherent to the voting process itself.
