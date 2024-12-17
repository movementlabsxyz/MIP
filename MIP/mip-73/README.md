# MIP-73: The SanFran Model
- **Description**: Proposes an L2 model that improves the Biarritz model. It transitions to a Lock/Mint-Native Bridge, adds Bridge fees, and proposes changes to existing components.
- **Authors**: [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)

## Abstract

The SanFran Model applies the following changes

- formally adds the Lock/Mint-Native Bridge, see [MIP-58](https://github.com/movementlabsxyz/MIP/pull/58)
- proposes detailed Bridge fees, see [MD-69](https://github.com/movementlabsxyz/MIP/pull/69)
- proposes Relayer - Continuous Operation and Bootstrapping algorithm, see [MIP-61](https://github.com/movementlabsxyz/MIP/pull/61)
- proposes changes to the Informer, see [MIP-71](https://github.com/movementlabsxyz/MIP/pull/71)
- proposes changes to the Rate Limiter, see [MIP-74](https://github.com/movementlabsxyz/MIP/pull/74)
- proposes fast-confirmations on L2, see [MIP-65](https://github.com/movementlabsxyz/MIP/pull/65)

## Motivation

This model is the result of the co-location.

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

The following Diagram gives an overview of the modified or added components.

![alt text](overview.png)
_Modified or added components are shown in orange._

### Lock/Mint-Native Bridge

Factually the Lock/Mint-Native Bridge has been introduced prior to the co-location. However, to categorize it within a model, the SanFran Model seems suitable.

We are moving away from the HTLC Native Bridge, see [MIP-39](https://github.com/movementlabsxyz/MIP/tree/main/MIP/mip-39) to the subjectively simpler design of a Lock/Mint Native Bridge, see [MIP-58](https://github.com/movementlabsxyz/MIP/pull/58). For a general overview of bridge designs, see [MIP-60](https://github.com/movementlabsxyz/MIP/pull/60).

### Bridge fees

In order to operate sustainably we require that the bridge fees cover expenditures of the operator sufficiently. We propose an approach for appropriate fee calculation in [MIP-58](https://github.com/movementlabsxyz/MIP/pull/58).

### Relayer - Continuous Operation and Bootstrapping

Introduce an algorithm for continuous operation and bootstrapping for the Relayer, see [MIP-61](https://github.com/movementlabsxyz/MIP/pull/61).

### Adjust Informer to the Lock/Mint Native Bridge design

With the change of the Native Bridge design the requirements, conditions and parameters have changed. [MIP-71](https://github.com/movementlabsxyz/MIP/pull/71) updates the Informer to the new setting.

### Adjust the Rate Limiter to the Lock/Mint Native Bridge design

With the change of the Native Bridge design the requirements, conditions and parameters have changed. [MIP-74](https://github.com/movementlabsxyz/MIP/pull/74) updates the Rate Limiter to the new setting.

### Add fastconfirmations

In order to facility fast confirmations as requested by the Fast-Finality Settlement mechanism, we require confirmations on the L2 in addition to the confirmations on the L1 (postconfirmations, see [MIP-37](https://github.com/movementlabsxyz/MIP/pull/37)).

We propose such a mechanism called fastconfirmation in [MIP-65](https://github.com/movementlabsxyz/MIP/pull/65).

## Reference Implementation

## Verification

Needs discussion.

---

## Errata

---

## Appendix

### A1
Nothing important here.

---
## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).