# MD-5: MCR - Long Range Attacks
- **Description**: Provide models for the game theory of long-range attacks in MCR.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)


## Overview
Long-range attacks are an inherent vulnerability to PoS networks. We request that the relevance of these attacks to MCR be formally modeled and considered. 

### Introduction

[This reference](https://blog.positive.com/rewriting-history-a-brief-introduction-to-long-range-attacks-54e473acdba9) categorises Long-Range Attacks into 
1. Simple Attack:
The attacker forges an alternative blockchain branch from the genesis block, bypassing timestamp checks to produce blocks ahead of time and overtake the main chain.
2. Posterior Corruption:
A retired validator is bribed or hacked to sign blocks on an alternate chain, allowing the attacker to increase their block production and potentially surpass the main chain.
3. Stake Bleeding:
The attacker stalls the main chain by skipping block production while accumulating stake and rewards on a hidden branch, eventually overtaking the main chain.



## Desiderata

### D1: Evaluate the Opportunity for "Simple" Long-range Attacks and Detection Thereof
**User Journey**: A researcher or protocol implementer can understand how a simple long-range attack could be executed and detected in MCR.

**Justification**: Long-range attacks are a known vulnerability to PoS networks. Providing a model which demonstrates how a simple long-range attack could be executed and detected in MCR could enable us to derive preventative measures.

### D2: Evaluate the Opportunity for Posterior Corruption Long-range Attacks and Detection Thereof
**User Journey**: A researcher or protocol implementer can understand how a posterior corruption long-range attack could be executed and detected in MCR.

**Justification**: Posterior corruption long-range attacks are a known vulnerability to PoS networks. Providing a model which demonstrates how a posterior corruption long-range attack could be executed and detected in MCR could enable us to derive preventative measures.

### D3: Evaluate the Opportunity for Stake-bleeding Long-range Attacks and Detection Thereof
**User Journey**: A researcher or protocol implementer can understand how a stake-bleeding long-range attack could be executed and detected in MCR.

**Justification**: Stake-bleeding long-range attacks are a known vulnerability to PoS networks. Providing a model which demonstrates how a stake-bleeding long-range attack could be executed and detected in MCR could enable us to derive preventative measures.

## Errata
