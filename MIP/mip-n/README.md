# MIP-15: AB-FFS Gas Pool AMM
- **Description**: Introduces an Automated Market Maker (AMM) to satisfy the needs of the AB-FFS Decoupled Gas Pool.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Reviewer**: Andreas Penzkofer
- **Desiderata**: [MD-15](../MD/md-15/README.md)

## Abstract
We propose an Automated Marked Maker using the StableSwap invariant to satisfy the requirement of the AB-FFS Decoupled Gas Pool. We discuss primarily the curve that will be used to purchase and sell the gas tokens to and from the intermediary bridge token. We suggest this satisfies both recirculation and also creates a natural sell-pressure which correlates gas token to intermediary bridge token and so on to the L1 staking token.

In the event of an AB-FFS Partially Decoupled Gas Pool, we suggest identifying an appropriate bonding curve is more difficult and that instead direct deposits to the bridge pool may be more appropriate.

## Motivation

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

1. The AB-FFS Decoupled Gas Pool AMM MUST contain a swap of L2 gas tokens to the intermediary bridge token at genesis.
2. The AB-FFS Decoupled Gas Pool AMM MUST be implemented using the [StableSwap invariant](https://docs.curve.fi/references/whitepapers/stableswap/#how-it-works). The StableSwap invariant is a generalization of the constant product invariant used in Uniswap and Balancer, and is suitable for conditions where the price between two assets should be stable. The StableSwap invariant is defined as:
    ```math
    A \cdot n \cdot \left( \sum x_i \right) + D = A \cdot D + \frac{D^{n+1}}{\prod x_i}
    ```
    where:
    - $ A $ is the **amplification coefficient**, which controls the "stretch" of the curve. Higher values of $ A $ make the curve behave more like a constant sum, while lower values make it behave more like a constant product.
    - $ n $ is the number of assets in the pool (usually 2 in a two-asset pool).
    - $ x_i $ represents the quantity of each token in the pool.
    - $ D $ is the **StableSwap invariant**, representing the overall balance of the pool.
    - This formula combines both constant sum and constant product behaviors:
    - **Low-Slippage Region**: Around the equilibrium (e.g., a 1:1 price ratio), the formula approximates constant sum behavior, minimizing slippage for small trades.
    - **Transition to Constant Product**: For larger trades, as the price moves away from equilibrium, the formula shifts toward constant product behavior, allowing larger trades with appropriate price adjustment.
3. The AB-FFS Decoupled Gas Pool AMM MUST initialize a 1:1 price ratio between the L2 gas token and the intermediary bridge token.
4. The supply of intermediary bridge tokens MUST be initialized to the total supply of L2 gas tokens.
5. 

### Token Correlation

#### Normal Market and Network Conditions
Generally, under normal market conditions, we assume co-linearity between the price of two tokens in a StableSwap pair and likewise the two tokens on either side of the bridge.

Given any two collinear relationships:

```math
A = \alpha B \quad \text{and} \quad C = \beta B
```

for constants $ \alpha $ and $ \beta $, we want to compute $ \text{Cov}(A, C) $ in terms of $ \text{Cov}(A, B) $, $ \text{Cov}(B, C) $, and $ \text{Var}(B) $.

Since $ A = \alpha B $ and $ C = \beta B $, we can express the covariance $ \text{Cov}(A, C) $ as:

```math
\text{Cov}(A, C) = \text{Cov}(\alpha B, \beta B)
```

Using the property of covariance for scaled random variables, we get:

```math
\text{Cov}(\alpha B, \beta B) = \alpha \beta \cdot \text{Cov}(B, B)
```

Since $ \text{Cov}(B, B) $ is the variance of $ B $, denoted $ \text{Var}(B) $, we have:

```math
\text{Cov}(A, C) = \alpha \beta \cdot \text{Var}(B)
```

Now, let’s express $ \alpha $ and $ \beta $ in terms of $ \text{Cov}(A, B) $, $ \text{Cov}(B, C) $, and $ \text{Var}(B) $:

```math
\alpha = \frac{\text{Cov}(A, B)}{\text{Var}(B)}
```
```math
\beta = \frac{\text{Cov}(B, C)}{\text{Var}(B)}
```

Substituting these values of $ \alpha $ and $ \beta $ into the equation for $ \text{Cov}(A, C) $:

```math
\text{Cov}(A, C) = \left( \frac{\text{Cov}(A, B)}{\text{Var}(B)} \right) \left( \frac{\text{Cov}(B, C)}{\text{Var}(B)} \right) \cdot \text{Var}(B)
```

Simplifying, we get:

```math
\text{Cov}(A, C) = \frac{\text{Cov}(A, B) \cdot \text{Cov}(B, C)}{\text{Var}(B)}
```
Thus, under the assumption of collinearity, the covariance $ \text{Cov}(A, C) $ is given by:

```math
\text{Cov}(A, C) = \frac{\text{Cov}(A, B) \cdot \text{Cov}(B, C)}{\text{Var}(B)}
```

This result shows that the covariance between $ A $ and $ C $ depends on the product of their individual covariances with $ B $, scaled by the variance of $ B $.

Thus, for a system involving the L2 gas token $G$, the L2 intermediary bridge token $B$, the L1 intermediary bridge token $B'$, and the L1 staking token $S$, we can express the covariance between $G$ and $S$ in terms of the covariances between $G$ and $B$, $B$ and $B'$, and $B'$ and $S$, scaled by the variance of $B$.

First, we compute the covariance between $G$ and $B'$:

```math
\text{Cov}(G, B') = \frac{\text{Cov}(G, B) \cdot \text{Cov}(B, B')}{\text{Var}(B)}
```


Thus, the covariance between $G$ and $S$ is given by the product of the covariance between $G$ and $B'$ and the covariance between $B'$ and $S, scaled by the variance of $B'$:

```math
\text{Cov}(G, S) = \frac{\text{Cov}(G, B) \cdot \text{Cov}(B, B') \cdot \text{Cov}(B', S)}{\text{Var}(B) \cdot \text{Var}(B')}
```

This lends to the intuitive conclusion that the covariance between $G$ and $S$ is predicted positively by the covariance between any two pairs and negatively by the variance of the intermediary bridge tokens. 

Tautologically, StableSwap maintains high covariance between the two tokens in the pool, so we can expect under normal market conditions that the terms $ \text{Cov}(G, B) $ and $ \text{Cov}(B', S) $ are all positive and close to 1.

The bridge itself, while fallible, should maintain a scalar conversion rate between $B$ and $B'$ under normal operating conditions, so we can expect $ \text{Cov}(B, B') $ to be positive and close to 1.

It is thus the variance of the intermediary bridge tokens that we expect to be the primary determinant of the covariance between the L2 gas token and the L1 staking token under normal market conditions.

#### Adverse Market and Network Conditions
Under adverse market conditions or network conditions, the covariance between the L2 gas token and the L1 staking should weaken temporarily. 

Should this occur on behalf of fallibility of the bridge, which would contribute to the variance of the intermediary bridge tokens, this would be a natural and expected outcome of the system--providing sell pressure against misuse of the bridge.

Should this occur on behalf of market shifts, e.g., speculative trading of the intermediary bridge tokens, the covariance between the L2 gas token and the intermediary bridge token would weaken. To recover the covariance between the L2 gas token and the L1 staking token, pegging methods, such as adding a token voucher, may be necessary.

## Reference Implementation


## Verification


## Errata


## Appendix
