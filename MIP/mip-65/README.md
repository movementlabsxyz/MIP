# MIP-65: FFS: Fastconfirmations

- **Description**: Fast-Finality Settlement : Fastconfirmations as confirmations on the L2.
- **Authors**: [Andreas Penzkofer]()
- **Desiderata**: [MD-65](../../MD/md-65/README.md)

## Abstract

This MIP introduces Fastconfirmations on level 2 (L2) as confirmations in addition to Postconfirmations. Fastconfirmations are a way to settle transactions on the L2 with fast confirmation times. This is achieved by using the L2 as a settlement layer for the [Fast Finality Settlement mechanism](https://github.com/movementlabsxyz/MIP/pull/34).

## Motivation

We introduce Postconfirmations on L1 in [MIP-37](https://github.com/movementlabsxyz/MIP/pull/37). While Postconfirmations partially draw from Ethereum security, they are  slow due to the finality time on Ethereum, and also expensive due to high L1 (Ethereum) fees.

In contrast, finality times on the L2 are much faster and fees are much lower. This justifies the introduction of Fastconfirmations on the L2 as a way to settle transactions on the L2 with fast confirmation times, but without any additional security guarantees from the L1.

Postconfirmations are a simple yet elegant design which permits implementation with

- high decentralization capability
- no requirements on p2p networking between validators
- no consensus required.

Postconfirmations can draw from the consensus progress on L1. Similarly, Fastconfirmations can draw from the consensus progress on protoBlocks on L2, which is independent of the confirmation of states.

## Specification

### Assumption

Abstractly the L2 chain consist of the following main components:

- a ledger
- a (shared) sequencer with Data Availability
- a validator set that confirms the ledger.

The sequencer outputs protoBlocks, which are ingested by validators. From these protoBlocks, the validators calculate the state of the ledger and calculates the next L2block.

The shared sequencer can serve multiple ledgers (also called _chains_). Validators can query for new protoBlocks and separate their transactions out by namespace. Alternatively validators could request based on namespace and receive a transaction stream specific to the chain. For simplicity we continue to refer to a protoBlock when discussing the pre-stage of the next L2block but in a shared setting protoBlock(namespace) would be more accurate.

### Operater chain

### Fastconfirmations

The L2 is a chain that ingests protoBlocks from a sequencer. This sequencer may or may not b


The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

## Reference Implementation

## Verification

Needs discussion.

---

## Changelog

---

## Appendix

---
## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).
