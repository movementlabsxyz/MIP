# Glossary

Alphabetically ordered list of terms used in this repository.

**Blob**  
The set of transactions that is sent to the the DA before transactions are ordered.

**Block**
More common term for L2Block. May be mixed up with the batch of transactions sent to the sequencer, the L1Block or with the batch of L2Blocks that should be processed by the L1-contract. So treat with care.

**Circulating token**
Token that is not locked and in circulation on L1 or L2.

**FFS - Fast Finality Settlement**  
The objective of the Fast-Finality-Settlement (FFS) protocol is to confirm that transactions are processed correctly and back this confirmation through crypto-economic security. It does not relate to the ordering of transactions.

**`$GasToken`**
Token used to pay for fees on L2. Could be \$L2MOVE.

**Governed Gas Pool**
A token pool on L2 that holds the gas token (\$L2MOVE).

**Informer**
An entity that monitors L1 **and** L2 to understand token supply.

**\$L1MOVE**
ERC-20 type token for the Movement Network with the source contract on L1. See also \$MOVE. > [MG-39](./MG/mg-39/README.md)

**\$L2MOVE**
Native token on L2. Used to pay for L2 gas. > [MG-39](./MG/mg-39/README.md)

**L2Block**  
A block of transactions that is processed by the FFS protocol. It contains information about the state root produced by the transactions in the block.

**\$MOVE**
ERC-20 type token for the Movement Network with the source contract on L1. See also \$L1MOVE. > [MG-39](./MG/mg-39/README.md)

**Native Bridge**
Native bridge that permits to exchange of \$L1MOVE into \$L2MOVE, and vice versa. This bridge mints \$L2MOVE.

**Postconfirmation**  
The process of confirming a (sequence of) blocks after it has been processed by the FFS protocol on L1.

**Potential token**
Token that could potentially be converted to circulating \$L1MOVEor \$L2MOVE token. A bridge transfer releases the potential token on the target change, while it locks source chain tokens into the potential token.

**Potential total supply**
Total supply plus potential token supply.

**ProtoBlock**
A block of ordered transaction provided by sequencer or DA on L2. No execution applied at this point.

**`$StakingToken`**
Token used for staking on L1. Could be \$L1MOVE.

**SuperBlock**
A range of L2Blocks that is processed by the FFS protocol. It contains information about the state root produced by the sequence of L2Blocks in the superBlock.

**Validator**  
A validator is a node that participates in the FFS protocol. Validators execute transactions from sequencer-batches and validate their correctness.
