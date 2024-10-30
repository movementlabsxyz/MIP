# MIP-15: AB-FFS Decoupled Demurrage
- **Description**: 
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Reviewer**: Andreas Penzkofer
- **Desiderata**: [MD-15](../MD/md-15/README.md)

## Abstract
We propose AB-FFS Decoupled Demurrage as a variant of [AB-FFS Decoupled](https://github.com/movementlabsxyz/MIP/pull/40) which issues a demurrage token as an LP Token reward. This approach allows the FFS reward mechanism to manipulate the supply of its rewards s.t. a new token generation event is not strictly required. We review demurrage strategies in general, highlighting several approaches which are particularly applicable in the AB-FFS context. 

We also introduce [MG-n](../../MG/mg-n/README.md) which defines the term "demurrage token."

## Motivation

AB-FFS Decoupled Demurrage is an extension to the response to [MD-38](https://github.com/movementlabsxyz/MIP/pull/38). It provides usage of the Atomic Bridge and Fast Finality Settlement with a fixed token supply. This extension allows for greater flexibility in the reward mechanism.


## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

AB-FFS Decoupled Demurrage identifies two primary controls over the LP token with respect to the L1 staking token:

1. The supply of the LP token.
2. Vouchers issued for purchasing the L1 staking token with the LP token.

Other controls are considered market mechanisms and are not considered in this MIP.

### Supply of the LP Token
Simply put, FFS may be increase the supply of the LP token by minting for the purpose of rewarding LPs. This approach allows flexibility in the reward mechanism. But, assuming other market conditions hold, this means LP tokens holders are subject to dilution and the value of the LP token is subject to inflation. This ultimately assigns a negative interest rate to the LP token w.r.t. to the L1 staking token which has a fixed supply.

To formalize this relationship, consider the following.

Let:
- $S_{LP}(t)$ denote the total supply of LP tokens at time $ t $,
- $R_{LP}(t)$ denote the reward rate in LP tokens,
- $P_{L1}$ denote the price or value of the L1 staking token (fixed) in terms of the LP token, and
- $P_{LP}(t)$ denote the price of the LP token in terms of $ P_{L1} $.

1. **Supply Inflation Rate**: $\Delta S_{LP}(t) = S_{LP}(t) \cdot R_{LP}(t)$ where $R_{LP}(t)$ represents the proportional increase in LP tokens over time.

2. **Effective Dilution**:
   - As new tokens are minted, each LP token’s value in terms of the L1 token $P_{L1}$ decreases: $P_{LP}(t+1) = \frac{P_{LP}(t)}{1 + R_{LP}(t)}$
    - Since $R_{LP}(t) > 0$, we have:
```math
1 + R_{LP}(t) > 1 \implies \frac{P_{LP}(t)}{1 + R_{LP}(t)} < P_{LP}(t) \implies P_{LP}(t+1) < P_{LP}(t)
```

3. **Negative Interest Rate**:
   - The "negative interest rate" on LP holdings with respect to L1 can be approximated as
   $\text{Interest Rate} \approx -R_{LP}(t)$
   where the LP token depreciates due to the supply increase.

### Vouchers
The governing body can issue vouchers to purchase the L1 staking token with the LP token. Voucher MUST contain a known value of the L1 staking token which can be purchased with the LP token.

This is a form of demurrage, as the LP token is subject to a negative interest rate w.r.t. the L1 staking token. The voucher system, however, allows the governing body to influence the rate at which the LP token depreciates. This is critical to the success of the demurrage token as a reward which appropriately incentivizes FFS staking.

### Demurrage Strategies
There are several categories of general demurrage strategies which may be applied to the LP token. These include:

1. **Supply Only**:
   - The governing body may choose to only increase the supply of the LP token. This is the simplest form of demurrage and is equivalent to a negative interest rate on LP holdings.
   - This approach does not require the issuance of vouchers. The market will determine the rate at which the LP token depreciates.
   - Because the supply will increase with rewards and rewards will increase with honest FFS participation, this approach essentially applies diminishing returns to FFS staking directly in proportion to honest participation. That is, FFS cannot adjust rewards rates without have an immediate negative impact on the value of the LP token.
2. **Voucher Curves**:
    - The governing body supplies vouchers with a defined curve for purchasing the L1 staking token with the LP token.
    - This approach allows the governing body to transparently adjust the rate at which the LP token depreciates.
    - An asymptotic curve may be used to ensure that the LP token retains some value even as the supply increases indefinitely.
    - Ultimately, the voucher curve must be defined in terms of the available supply of the L1 staking token granted to the voucher otherwise an overdraft could occur. 
    - The area under the voucher curve represents the total value of the L1 staking token that can be purchased with the LP token. The voucher curve need not be non-decreasing nor non-increasing, but must respect this constraint.
    - The voucher curve can consider other input parameters so long as the area under the curve is bounded by the available supply of the L1 staking token.
    - Because the voucher-curve can be increasing, FFS can adjust its rewards rates without an immediate negative impact on the value of the LP token. This allows FFS to adjust rewards rates in response to market conditions or participation without immediately devaluing the LP token.
3. **Governed Voucher**:
    - A voting mechanism can be used to set the voucher curve. This allows the governing body to adjust the rate at which the LP token depreciates in response to market conditions or participation.
    - The curve selected by the voting mechanism must respect the constraint that the area under the curve is bounded by the available supply of the L1 staking token.
    - The electorate generally should not be the participants in the FFS system, as this would incentivize participants to vote for vouchers which benefit themselves in the short-term at the expense of the long-term value of the LP token.
4. **Participation Voucher**:
    - The voucher defines its curve in terms of some inverse of the participation rate of FFS. 
    - Participation can be measured in terms of variables such as stake and throughput.
    - Generally, tying voucher curves to participation results in conditions which may incentivize inducing unfavorable participation rates to reap greater benefits of the voucher.
    - If rewards are freely tradeable and not marked with an epoch, LP token holders may wait to redeem their rewards until participation is low, preventing actual low-participation committee members from benefitting from this incentive. For this reason, in most cases, FFS itself should handle low-participation incentives rather than the LP token, i.e., by issuing greater rewards during periods of low participation.
5. **LP Token Futures Voucher**:
   - Let $\alpha$ represent the future multiplier for the LP token in the voucher. The governing token issues vouchers redeemable for $\alpha \cdot \text{LP}$ at a future time $t_f$.
   - Users can either claim the L1 staking token immediately or wait to claim the LP token later, with the future multiplier.
   - When L1 price appreciation outpaces $\alpha$, it incentivizes LP token holding, as users anticipate a higher future payoff. Because LP token then has a greater market value, FFS can reward LP token holders with a smaller number of LP tokens. FFS need only look-up the volume of futures held to determine the appropriate reward rate.
   - This dynamic strengthens the correlation between LP and L1 values, stabilizing LP token depreciation and aligning incentives around L1’s future value. Importantly, it also allows the reward rate to capture market effects that counteract the negative interest rate on LP holdings.


### Standard Demurrage Strategy
We propose a standard demurrage strategy for AB-FFS Decoupled Demurrage consisting of three key components:

1. **Step-down to Asymptotic (SDA) Voucher Curve**: 
    - The governing body issues vouchers with a step-down curve. This curve is defined by a series of steps, each with a fixed value of the L1 staking token that can be purchased with the LP token.
    - After a fixed number of steps, the voucher curve becomes asymptotic. This ensures that the LP token retains some value even as the supply increases indefinitely.
    - This removes complexities associated with governance and participation-based vouchers, as the voucher curve is fixed and transparent.
    - The periods of fixed rate introduce stability in the LP token value, while the asymptotic curve ensures that the LP token retains some value even as the supply increases indefinitely.
2. **Inverse Future Multiplier**:
    - A futures contract is issued for the LP token wherein the multiplier is the inverse of the SDA voucher curve.
    - In addition to the market-alignment benefits of a general futures voucher, the inversion with the SDA voucher curve ensures allows for:
        1. The early portion of demurrage period to incentivize rapid divestment from the LP token into the L1 staking token.
        2. The later portion of the demurrage period to relying on market effects to slow LP token depreciation.
3. **FFS Reward Minting**:
    - FFS mints LP tokens to reward LPs.
    - FFS uses the futures contract to determine the appropriate reward rate for LPs, minting fewer LP tokens when the volume of futures held is high.

```math
\begin{tikzpicture}
    \begin{axis}[
        width=12cm,
        height=8cm,
        xlabel={Redeemed LP Token},
        ylabel={L1 Staking Token Value},
        title={Step-Down to Asymptotic (SDA) Voucher Curve with Tail Approaching 0},
        xmin=0, xmax=10,
        ymin=0, ymax=1.2,
        grid=both,
        legend pos=north east,
        every axis plot/.append style={ultra thick}
    ]
    
    \addplot [
        domain=0:2,
        samples=100,
        blue
    ] {1.0};
    
    \addplot [
        domain=2:5,
        samples=100,
        blue
    ] {0.7};
    
    \addplot [
        domain=5:8,
        samples=100,
        blue
    ] {0.5};
    
    \addplot [
        domain=8:10,
        samples=100,
        blue
    ] {0.5 / (x - 7.5)};
    
    \legend{SDA Voucher Curve}
    \end{axis}
\end{tikzpicture}
```

## Reference Implementation


## Verification



## Errata


## Appendix
