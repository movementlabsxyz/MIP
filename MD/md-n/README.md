# MD-n: PQC Virtual Machine
- **Description**: Provide PQC for transaction signing and on-chain modules. 
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)

## Overview

Post Quantum Cryptography (PQC) is a necessary development for the security of decentralized systems against quantum compute capabilities. We assert the MoveVM and surrounding execution environment can immediately benefit from the implementation of PQC in two ways:

1. **Transaction Signing**: transactions can be signed and verified with PQC algorithms. 
2. **PQC On-chain Modules**: developers can call PQC methods from modules deployed on-chain during execution. 

## Desiderata

### D1: Extend the MoveVM with to include PQC signing standards
**User journey**: Users can sign transactions with PQC. 

**Justification**: PQC signed transactions prevent impersonation and maintain secure identity in a post-quantum computing environment. 

**Recommendations:**
1. Extend the [`TransactionAuthenticator`](https://github.com/movementlabsxyz/aptos-core/blob/1d1cdbbd7fabb80dcb95ba5e23213faa072fab67/types/src/transaction/authenticator.rs#L47) enum such that its usage supports some pre-determined PQC. 
2. Use [`liboqs`](https://github.com/open-quantum-safe/liboqs-rust) to implement added cryptography. 
3. Support [Dilithium](https://pq-crystals.org/dilithium/), [Falcon](https://falcon-sign.info/), and [Sphincs](https://sphincs.org/).

### D2: Extend MoveVM natives to include PQC

**User journey**: Move module developers can call MoveVM natives which run native PQC implementations for hashing, signing, and verifying. 

**Justification**: Not all information will be able to verified simply at the transaction level. Some applications, particularly bridges, can benefit from verification of signatures and similar within the actual smart contract execution itself. 

**Recommendations:**
1. Extend the [`all_natives`](https://github.com/movementlabsxyz/aptos-core/blob/1d1cdbbd7fabb80dcb95ba5e23213faa072fab67/aptos-move/framework/src/natives/mod.rs#L39) method following the existing pattern, adding appropriate [`aptos_framework`](https://github.com/movementlabsxyz/aptos-core/tree/1d1cdbbd7fabb80dcb95ba5e23213faa072fab67/aptos-move/framework/aptos-framework/sources) bindings. 

### D3: Ensure performance of PQC algorithms across common operator architectures

**User journey**: Operators can use common architectures without risking PQC-performance-based partitions of the network. 

**Justification**: Current PQC algorithms implemented for [x86](https://en.wikipedia.org/wiki/X86_SIMD_instruction_listings) and [ARM](https://developer.arm.com/documentation/dht0002/latest/Introducing-NEON/What-is-SIMD-/ARM-SIMD-instructions) may rely on SIMD instructions to ensure high-performance in time. An partition of the network $P$ which runs on an architecture for which transaction verification and natives are not implemented using such SIMD may fail to process blocks in sufficient time and thus produce a network fork. Because this issue may be esoteric, it can cause honest and well-incentivized participants to become members of the fork--thus problematizing Byzantine assumptions. 

**Recommendations:**
1. Consider the [RISC-V]() everywhere approach to SIMD proposed by NTHU. 

## Changelog
