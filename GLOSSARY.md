## Glossary

Alphabetically ordered list of terms defined through MGs.

**Attester**  (not recommended)
The term attester has been deprecated in favor of validator. > [MIP-34](./MIP/mip-34)

**Batch**  
Less clean, but more common term for sequencer batch. May be mixed up with the batch of transactions sent to the sequencer, or with the batch of L2Blocks (superBlocks) that should be processed for postconfirmations. Use with care. > [MIP-34](./MIP/mip-34)

**Block**  
More common term for L2Block. May be mixed up with the batch of transactions sent to the sequencer, the L1 block or with the batch of L2Blocks that should be processed by the L1-contract. Use with care.

**SuperBlock**
A range of L2Blocks that are processed by the FFS postconfirmation protocol. > [MIP-34](./MIP/mip-34)

**FFS (Fast Finality Settlement)**  
The objective of the Fast Finality Settlement (FFS) protocol is to confirm that transactions are processed correctly and back this confirmation through crypto-economic security. There are two types of confirmation: postconfirmation and fastconfirmation. It does not relate to the ordering of transactions. > [MIP-34](./MIP/mip-34)

**L2Block**  
A block of transactions that is derived from a protoBlock. It contains information about the state root produced by the transactions in the block. > [MIP-34](./MIP/mip-34)

**Postconfirmation**  
The process of confirming a (sequence of) L2Blocks on L1. > [MIP-34](./MIP/mip-34)

**Fastconfirmation**  
The process of confirming a (sequence of) L2Blocks on L2. > [MIP-34](./MIP/mip-34)

**ProtoBlock**
The batch of transactions that is provided by the sequencer. > [MIP-34](./MIP/mip-34)

**Validator**  
A validator is a node that participates in the FFS protocol. Validators execute protoBlocks and validate their correctness. > [MIP-34](./MIP/mip-34)

**Quorum certificate**
The term quorum certificate has been deprecated in favor of fastconfirmation certificate.
