# MD-117: Ximen (Postconfirmations) Standards

- **Description**: Provides a set of liveness and correctness requirements for Postconfirmations protocols. 
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Approval**: :red-cross:
- **Etymology**: These standards were originally drafted as a planned but later alternative to the [Dongmen Standards](https://github.com/movementlabsxyz/MIP/pull/116) and so bear the name of a "younger" Taipei neighborhood, Ximen. 

## Overview

The [Dongmen Standards](https://github.com/movementlabsxyz/MIP/pull/116) (MD-116) acknowledge the inability of fully-synchronous protocols to satisfy traditional BFT assumptions. These standards accept MD-116.D2,3 but reject [MD-116.D1](https://github.com/movementlabsxyz/MIP/tree/l-monninger/dongmen-standards/MD/md-n#d1-fully-synchronous) (full synchronicity) instead proposing [MD-117.D1](#d1-partially-synchronous) (partial synchronicity) in its place. 

As a result, [MD-116.D4](https://github.com/movementlabsxyz/MIP/tree/l-monninger/dongmen-standards/MD/md-n#d4-minority-aware) (minority awareness) is no longer relevant. However, a request for a clear consideration of attacks on the indefinite nature of the agreement synchronicity is requested. 

## Definitions

- **Partially-synchronous**: A model of distributed systems in which the network may behave asynchronously for an unbounded (but finite) period of time, after which it stabilizes and messages are guaranteed to arrive within some fixed delay. This transition point, known as the *Global Stabilization Time (GST)*, is not known to the protocol. Unlike in fully-synchronous models, liveness is not guaranteed at any fixed moment, but is guaranteed eventually.

- **Commitment Hostage Attack**: An adversarial strategy in which a network or participant delays confirmation of a block (or decision) indefinitely by exploiting asynchrony, forcing the protocol into a state of limbo. These attacks often require post-facto reasoning or off-path resolution to identify and mitigate.

- **Synchronicity Attack**: A broader class of strategies in which an adversary manipulates message timing or node behavior to degrade the liveness or fairness of a consensus protocol, often without violating safety directly.



## Desiderata

### D1: Partially-synchronous

**User journey**: Consumers of Ximen Postconfirmations consensus can rely on agreement to be achieved by a know Global Stabilization Time w.r.t. to the confirming ledger. 

**Justification**: A partially-synchronous protocol is a consensus protocol under FLP. While it does not render predictable points in time at which consensus will be known, it does prevent permanent asynchrony and unliveness. 

### D2: Describe attacks on indefinite synchronicity

**User journey**: Consumers of Ximen Postconfirmations consensus can interpret a well-considered discussion of attacks on the indefinite nature of synchronicity. For a given Ximen Postconfirmation protocol, best efforts should be made to mitigate these attacks. 

**Justification**: The Ximen Standards seek to ensure common synchronicity attacks, such as [Commitment Hostage Attacks](https://github.com/movementlabsxyz/MIP/tree/main/MD/md-3), are well-considered for an adhering protocol. Owing to the complexity and often [off-path](https://economics.stackexchange.com/questions/57998/on-and-off-equilibrium-path-game-theory) nature of these attacks, the Ximen Standards recognize that full and rigorous criteria for protections against these attacks are not practical. 

## Changelog