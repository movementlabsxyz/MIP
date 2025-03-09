# MIP-73: The San Fran Model

- **Description**: Proposes an L2 model that improves the Biarritz model. It transitions to a Lock/Mint-Native Bridge, adds Bridge fees, and proposes changes to existing components.
- **Authors**: [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)

## Abstract

The San Fran Model applies the changes to the type of the Native Bridge to lock/mint. It proposes bridge fees, a relayer, an informer, a rate limiter and fastconfirmations.

## Motivation

The [MIP-54: Biarritz Model](https://github.com/movementlabsxyz/MIP/pull/54) has been a starting point to this model. The San Fran Model is a further development of the Biarritz Model, which includes the Lock/Mint-Native Bridge, and adds the features or components mentioned in the Abstract. It focuses on providing fast finality settlement, see [MIP-37](https://github.com/movementlabsxyz/MIP/pull/37), as well as a sustainable operation of the bridge.

## Specification

_The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174._

_The conventions of [MIP-53: Conventions for Proposing Progressive L2 Models](../mip-53) are applied._

![alt text](overview.png)
_Modified or added components, compared to [The Biarritz Model](https://github.com/movementlabsxyz/MIP/pull/55) are shown in orange._

### Summary Table

| Category / Criterion | Evaluation |
|-----------|------------|
| **General** | |
| _When to use_ | A brief general description of the circumstances under which the model is appropriate. |
| _Suitable preceding models_ | A list of models or descriptions of models that are suitable precursors to this model. |
| _Suitable succeeding models_ | A list of models or descriptions of models that are suitable successors to this model. |
| _Technological motivations_ | A brief description of the technological motivations for using the model. |
| _Usership motivations_ | A brief description of the user motivations for using the model. |
| **Components** | |
| _[MIP-58](https://github.com/movementlabsxyz/MIP/pull/58): Lock/Mint-Native Bridge_ | Factually the Lock/Mint-Native Bridge has been introduced prior to the co-location. However, to categorize it within a model, the San Fran Model seems suitable. <br><br> We are moving away from the HTLC Native Bridge, see [MIP-39](https://github.com/movementlabsxyz/MIP/tree/main/MIP/mip-39) to the subjectively simpler design of a Lock/Mint Native Bridge, see [MIP-58](https://github.com/movementlabsxyz/MIP/pull/58). For a general overview of bridge designs, see [MIP-60](https://github.com/movementlabsxyz/MIP/pull/60). |
| _[MD-69](https://github.com/movementlabsxyz/MIP/pull/69): Bridge fees_ | In order to operate sustainably we require that the bridge fees cover expenditures of the operator sufficiently. We propose an approach for appropriate fee calculation in [MIP-58](https://github.com/movementlabsxyz/MIP/pull/58). |
| _[MIP-61](https://github.com/movementlabsxyz/MIP/pull/61): Relayer algorithm_ | Introduce an algorithm for continuous operation and bootstrapping for the Relayer. |
| _[MIP-71](https://github.com/movementlabsxyz/MIP/pull/71): Adjust Informer to Lock/Mint Bridge_ | With the change of the Native Bridge design the requirements, conditions and parameters have changed for the Informer. |
| _[MIP-74](https://github.com/movementlabsxyz/MIP/pull/74): Adjust Rate Limiter to Lock/Mint Bridge_ | With the change of the Native Bridge design the requirements, conditions and parameters have changed. |
| _[MIP-65](https://github.com/movementlabsxyz/MIP/pull/65):  Fastconfirmations on L2_ | In order to facility fast confirmations as requested by the Fast-Finality Settlement mechanism, we require confirmations on the L2 in addition to the confirmations on the L1 (postconfirmations, see [MIP-37](https://github.com/movementlabsxyz/MIP/pull/37)). This mechanism is called fastconfirmation. |


## Reference Implementation

## Verification

## Appendix

## Changelog
