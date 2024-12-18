# MD-74: Rate-Limiter for the Lock/Mint-type Native Bridge
- **Description**: A rate limitation mechanism for the Lock/Mint-type Native Bridge.
- **Authors**: [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)

## Overview

The Lock/Mint-type Native Bridge (hereafter called the "Native Bridge"), see [MIP-58](https://github.com/movementlabsxyz/MIP/pull/58), must be protected against faulty components and attacks. A Rate-Limiter is a mechanism that can help to protect the Native Bridge. It limits the volume of transferred value, the maximum value transferred with a given transfer, or the number of transactions.

## Desiderata

### D1: Specify the actors and their trust assumptions

**User Journey**: The developer should understand existing trust assumptions.

**Description**: The Native Bridge is operated via contracts, actors and components. What are the trust assumptions on these?

### D1: Specify the risks and threats from components

**User Journey**: The developer should understand the risks from components.

**Description**: We must ensure that risks are minimized even in the case that a component is compromised or faulty.

**Recommendations**: Address the risks by first identifying the relevant parties and their trust assumptions. Then, specify the risks and threats from these components. How can we restrict the risks?

### D3: Define the rate-limiting mechanism

**User Journey**: The developer should understand the rate-limiting mechanism.

**Description**: The rate-limiting mechanism should be defined in a way that it is clear how it works and how it can be adjusted. Moreover all components and their parameters should be defined. It should also be defined what is being rate-limited.

## Errata
