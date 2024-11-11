# Glossary

Alphabetically ordered list of terms defined through MGs.

**AB - Atomic Bridge**
A bridge design that is atomic in the sense that a transfer either completes or not at all. See also native Bridge > [MG-?]()

**AB-FFS Bridge**
Atomic Bridge that is secured in any way by the FFS protocol. > [MG-?]()

**ABS - Atomic Bridge with Fast Finality Settlement**
Fast Finality settlement is employed to secure the AB transfers. > [MG-?]()

**Attester**  (not recommended)
The term attester has been deprecated in favor of validator. > [MG-34](./MG/g-34/MG-34)

**Blob**  
The set of transactions that is sent to the the DA before transactions are ordered. 

**Block**
More common term for L2-block. May be mixed up with the batch of transactions sent to the sequencer, the L1-block or with the batch of L2-blocks that should be processed by the L1-contract. So treat with care. > [MG-34](./MG/g-34/MG-34)

**Bridge-Swap**
An AMM is between `$L2MOVE` and `$L2Bridge` token. > [MG-?]()

**Circulating token**
Token that is not locked and in circulation on L1 or L2. > [MG-?]()

**FFS - Fast Finality Settlement**  
The objective of the Fast-Finality-Settlement (FFS) protocol is to confirm that transactions are processed correctly and back this confirmation through crypto-economic security. It does not relate to the ordering of transactions. > [MG-34](./MG/g-34/MG-34)

**`$GasToken`**
Token used to pay for fees on L2. Could be `$L2MOVE`. > [MG-?]()

**Governed Gas Pool**
A token pool on L2 that holds the gas token (`$L2MOVE`). > [MIP-44](./MIP/mip-44/README.md)

**Informer**
An entity that monitors L1 **and** L2 to understand token supply. > [MG-?]()

**`$L1MOVE`**
ERC-20 type token for the Movement Network with the source contract on L1. See also `$MOVE`. > [MG-39](./MG/mg-39/README.md)

**`$L2MOVE`**
Native token on L2. Used to pay for L2 gas. > [MG-39](./MG/mg-39/README.md)

**L2-block**  
A block of transactions that is processed by the FFS protocol. It contains information about the state root produced by the transactions in the block. > [MG-34](./MG/g-34/MG-34)

**`$MOVE`**
ERC-20 type token for the Movement Network with the source contract on L1. See also `$L1MOVE`. > [MG-39](./MG/mg-39/README.md)

**Native Bridge**
Native bridge that permits to exchange of `$L1MOVE` into `$L2MOVE`, and vice versa. This bridge mints `$L2MOVE`.

**Postconfirmation**  
The process of confirming a (sequence of) blocks after it has been processed by the FFS protocol on L1. > [MG-34](./MG/g-34/MG-34)

**Potential token**
Token that could potentially be converted to circulating `$L1MOVE`or `$L2MOVE` token. A bridge transfer releases the potential token on the target change, while it locks source chain tokens into the potential token. > [MG-?]()

**Potential total supply**
Total supply plus potential token supply. > [MG-?]()

**ProtoBlock**
A block of ordered transaction provided by sequencer or DA on L2. No execution applied at this point. > [MG-?]()

**`$StakingToken`**
Token used for staking on L1. Could be `$L1MOVE`. > [MG-?]()

**SuperBlock**
A range of L2-blocks that is processed by the FFS protocol. It contains information about the state root produced by the sequence of L2-blocks in the superBlock. > [MG-34](./MG/g-34/MG-34)

**Swap-Bridge-Swap**
Bridge-Swap plus `$L1MOVE` and `$L1Reward` token. > [MG-?]()

**Validator**  
A validator is a node that participates in the FFS protocol. Validators execute transactions from sequencer-batches and validate their correctness. > [MG-34](./MG/g-34/MG-34)
