# MD-n: MLIR Move Compiler Stack
- **Description**: Provide an MLIR compiler stack for Move.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)

## Overview

[MLIR](https://mlir.llvm.org/) is a compiler technology that eases  domain-specific optimizations by allowing the creation of intermediate representation (IR) dialects. We believe that applying MLIR to the Move compiler stack can have direct benefits for users in terms of time performance, memory performance, and gas costs. We also believe MLIR can facilitate Move portability by providing a series of IR which can target different backends or other already portable IR such as [LLVM-IR](https://llvm.org/docs/LangRef.html). 

## Desiderata

### D1.1: Define optimization criteria for Move MLIR dialects

**User journey**: Researchers, Reviewers, and Move Developers can understand what various Move MLIR dialects attempt to optimize. 

**Justification**: It is critical to have optimization criteria against which the MLIR dialects are assessed. 

### D1.2: Provide optimization criteria for Aptos Gas Algebra

**User journey**: Researchers, Reviewers, and Move Developer can understand how a set of Move MLIR dialects attempt to optimize Move bytecode w.r.t. to the Aptos Gas Algebra. 

**Justification**: The most obvious immediate benefit of Move bytecode optimization would be the reduction of gas costs. This should be accomplished w.r.t. the Aptos Gas Algebra--which is currently used in the MoveVM to compute gas fees. 

**Recommendations**:
1. Review the [`StandardGasAlgebra`](https://github.com/movementlabsxyz/aptos-core/blob/1d1cdbbd7fabb80dcb95ba5e23213faa072fab67/aptos-move/aptos-gas-meter/src/algebra.rs#L21) and [`GasAlgebra`](https://github.com/movementlabsxyz/aptos-core/blob/1d1cdbbd7fabb80dcb95ba5e23213faa072fab67/aptos-move/aptos-gas-meter/src/traits.rs#L24) trait to understand how gas fees are parameterized.
2. Provide criteria that generalize with the `GasAlgebra` trait s.t. users of the compiler stack can benefit from optimizations when the `GasAlgebra` is updated. 
3. The most obvious criterion is simply average gas fee. However, this is (a) difficult to determine as you need to assume some sample of real world transactions before the optimization would hold after the optimizations and (b) could in-fact be misaligned with community objectives of optimization. 
    1. It may likewise be advantageous to define a set of criteria or optimization space w.r.t. the community. 


### D1.3: Implement a set of MLIR dialects optimizing for D1.1 and D1.2

**User journey**: Move Developers can optimize Move bytecode w.r.t. the criteria [D1.1](#d11-define-optimization-criteria-for-move-mlir-dialects) and [D1.2](#d12-provide-optimization-criteria-for-aptos-gas-algebra) by applying a set of MLIR dialects.

**Justification**: Move Developers and the Community can benefit from optimized bytecode which may reduced costs or align with other objectives. 

**Recommendations**:
1. Begin with a bytecode-to-bytecode approach, i.e., applying dialect optimizations to existing Move bytecode before ultimately yielding optimized Move bytecode.

### D1.4: Define an [MLIR legalizer](https://mlir.llvm.org/getting_started/Glossary/#legalization) which preserves Move bytecode semantics

**User journey**: Move Developers can maintain verifiable Move bytecode through optimization passes. 

**Justification**: The [verifiability of Move bytecode](https://diem-developers-components.netlify.app/papers/diem-move-a-language-with-programmable-resources/2020-05-26.pdf) is one of its most distinctive security traits. Preserving this across Move bytecode optimizations preserves the current developer expectations when using the compiler stack. 

### D2: Provide a set of MLIR dialects which enables transformation to LLVM-IR

**User journey**: Move Developers can port Move programs to a variety of architectures by leveraging LLVM-IR's many supported backends. 

**Justification**: The usage of Move--inside and outside of the context of DLT--can be furthered my making the language more portable.

**Recommendations:**
1. Consider how optimizations under [D1.1](#d11-define-optimization-criteria-for-move-mlir-dialects) and [D1.2](#d12-provide-optimization-criteria-for-aptos-gas-algebra) do or do not still apply. 
2. Consider how semantics may still be preserved, as is requested under [D1.4](#d14-define-an-mlir-legalizer-which-preserves-move-bytecode-semantics)

## Changelog