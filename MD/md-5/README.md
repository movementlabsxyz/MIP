# MD-5: Fast Finality Settlement - Long Range Attacks

- **Description**: Consider and model long-range attacks in the Fast Finality Settlement protocol.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz), Andreas Penzkofer


## Overview

Long-range attacks are an inherent vulnerability to Proof-of-Stake (PoS) systems. Without an anchoring mechanisms blockchains are exposed to the risk of these.

The Fast Finality Settlement ([MIP-34](https://github.com/movementlabsxyz/MIP/pull/34)) is a PoS based settlement mechanism and separates into 

- a Fastconfirmation protocol ([MIP-64](https://github.com/movementlabsxyz/MIP/pull/65)) on L2. Fastconfirmations confirm L2Blocks.
- a Postconfirmation protocol ([MIP-37](https://github.com/movementlabsxyz/MIP/pull/37)) on L1. Postconfirmations confirm superBlocks, which are a sequence of L2Blocks. Postconfirmations act as an anchoring mechanism.

**Postconfirmation**
The stake and finality of Postconfirmations is protected by the underlying L1 finality. However, since the L1 is itself is a PoS system it may be susceptible to reorgs. Consequently, in combination with a reorg on L1,  Postconfirmations may be reverted, and the anchoring invalidated. The invalidation of anchors can permit long-range attacks on superBlocks.

Albeit unlikely due to the high security of L1, long-range attacks in the Postconfirmation protocol should be considered and modeled.

**Fastconfirmation**
Fastconfirmation on L2 are anchored through Postconfirmations on L1. An anchoring mechanism can protect against long-range attacks on L2Blocks. However, Fastconfirmations should consider the Postconfirmations.

L2Blocks that are not postconfirmed are susceptible to long-range attacks.

### Introduction

[This reference](https://blog.positive.com/rewriting-history-a-brief-introduction-to-long-range-attacks-54e473acdba9) categorizes long-range attacks into

1. **Simple Attack**:
The attacker forges an alternative blockchain branch from some earlier block, bypassing timestamp checks to produce blocks ahead of time and overtake the main chain.
2. **Posterior Corruption**:
A retired validator is bribed or hacked to sign blocks on an alternate chain, allowing the attacker to increase their block production and potentially surpass the main chain.
3. **Stake Bleeding**:
The attacker stalls the main chain by skipping block production while accumulating stake and rewards on a hidden branch, eventually overtaking the main chain.

## Desiderata

### D1: Evaluate the opportunity for "simple" long-range attacks and detection thereof

**User Journey**: A researcher or protocol implementer can understand how a simple long-range attack could be executed and detected.

**Justification**: Providing a model which demonstrates how a simple long-range attack could be executed and detected could enable us to derive preventative measures.

### D2: Evaluate the opportunity for "posterior corruption" long-range attacks and detection thereof

**User Journey**: A researcher or protocol implementer can understand how a posterior corruption long-range attack could be executed and detected.

**Justification**: Posterior corruption long-range attacks are a known vulnerability to PoS networks. Providing a model which demonstrates how a posterior corruption long-range attack could be executed and detected could enable us to derive preventative measures.

### D3: Evaluate the opportunity for "stake-bleeding" long-range attacks and detection thereof

**User Journey**: A researcher or protocol implementer can understand how a stake-bleeding long-range attack could be executed and detected.

**Justification**: Stake-bleeding long-range attacks are a known vulnerability to PoS networks. Providing a model which demonstrates how a stake-bleeding long-range attack could be executed and detected could enable us to derive preventative measures.

## Changelog
