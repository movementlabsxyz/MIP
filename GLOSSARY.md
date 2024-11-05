## Glossary

Alphabetically ordered list of terms defined through MGs.

**AB - Atomic Bridge**
A bridge design that is atomic in the sense that a transfer either completes or not at all. > [MG-?]()

***???? why atomic??. any transfer should be atomic***

**ABS - Atomic Bridge with Fast Finality Settlement**
Fast Finality settlement is employed to secure the AB transfers. > [MG-?]()

**attester**  (not recommended)
The term attester has been deprecated in favor of validator. > [MG-34](./MG/g-34/MG-34)

**batch**  
Less clean, but more common term for sequencer-batch. May be mixed up with the batch of transactions sent to the sequencer, or with the batch of L2-blocks that should be processed by the L1-contract. > [MG-34](./MG/g-34/MG-34)

**block**
More common term for L2-block. May be mixed up with the batch of transactions sent to the sequencer, the L1-block or with the batch of L2-blocks that should be processed by the L1-contract. So treat with care. > [MG-34](./MG/g-34/MG-34)

**block-range / block**
A range of blocks that are processed by the FFS postconfirmation protocol. > [MG-34](./MG/g-34/MG-34)

**FFS - Fast Finality Settlement**  
The objective of the Fast-Finality-Settlement (FFS) protocol is to confirm that transactions are processed correctly and back this confirmation through crypto-economic security. It does not relate to the ordering of transactions. > [MG-34](./MG/g-34/MG-34)

**L2-block**  
A block of transactions that is processed by the FFS protocol. It contains information about the state root produced by the transactions in the block. > [MG-34](./MG/g-34/MG-34)

**postconfirmation**  
The process of confirming a (sequence of) blocks after it has been processed by the FFS protocol on L1. > [MG-34](./MG/g-34/MG-34)

**sequencer-batch**  
The block of transactions that is provided by the sequencer. > [MG-34](./MG/g-34/MG-34)

**validator**  
A validator is a node that participates in the FFS protocol. Validators execute transactions from sequencer-batches and validate their correctness. > [MG-34](./MG/g-34/MG-34)

**`$MOVE`**

ERC-20 type token for the Movement Network with the source contract on L1. See also `$L1MOVE`. > [MG-39](./MG/mg-39/README.md)

**`$wMOVE`**
- not wrapped. 
wrapped version of the (L1) `$MOVE` token. See also `$L2MOVE`. > [MG-39](./MG/mg-39/README.md)

**`$L1MOVE`**

ERC-20 type token for the Movement Network with the source contract on L1. See also `$MOVE`. > [MG-39](./MG/mg-39/README.md)

**`$L2MOVE`**

wrapped version of the `$L1MOVE` token. See also `$wMOVE`. > [MG-39](./MG/mg-39/README.md)

**`$L1StakingToken`**

could be `$L1MOVE`. > [MG-?]()

**`$L2GasToken`**

could be `$L2MOVE`. > [MG-?]()

**AB-FFS Bridge**

Atomic Bridge that is secured in any way by the FFS protocol. > [MG-?]()

**Fallible transfer**

Bridge token transfer is broken. > [MG-?]()

**Circulating token**

Total supply of `$L1MOVE` plus `$L2MOVE`. > [MG-?]()

**Potential token**

Token that could potentially be converted to `$L1MOVE`or `$L2MOVE` token. A bridge transfer releases the potential token on the target change, while it locks source chain tokens into the potential token. > [MG-?]()

**Potential total supply**

Total supply plus potential token supply. > [MG-?]()

**Informer**

An entity that monitors L1 **and** L2. > [MG-?]()

**Bridge-Swap**

An AMM is between `$L2MOVE` and `$L2Bridge` token. > [MG-?]()

**Swap-Bridge-Swap**

Bridge-Swap plus `$L1MOVE` and `$L1Reward` token. > [MG-?]()

**Governed Gas Pool**

A token pool on L2 that holds the gas token (`$L2MOVE`). > [MIP-44](./MIP/mip-44/README.md)