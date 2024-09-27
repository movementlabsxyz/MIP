
# MIP-16: Calculation of gas fees 

- **Description**: How to calculate gas fees for transactions on Movement L2.
- **Authors**: [Franck Cassez](mailto:franck.cassez@movementlabs.xyz)
- **Desiderata**: [MIP-\<number\>](../MD/md-\<number\>)


## Abstract
This MIP describes the structure of the gas fees and overall resource consumption needed to execute, and post a transaction to the DA/L1.


## Motivation

The transaction fees on L2s are multi-dimensional. They comprise of _execution fees_, _settlement fees_ and _data availability fees_.
This MIP describes what the different types of fees are, and how the transaction fees can be computed.

## Scope of this MIP
This MIP applies to costs/fees **related to executing Move bytecode**. 

> [!WARNING] 
> It does not cover the extended future framework where EVM bytecode can be executed on a Movement chain. 

Althought the costs (in terms of resources consumption) are expressed in gas units when executing Move and EVM bytecode, the gas units are **not comparable**, e.g. the minimum gas for an EVM transaction is 21000 gas units, whereas for Move-Aptos it is 700 gas units. As a result designing a fee mechanism for Movement chains that support Move and EVM bytecodes will require some careful adjustments and analysis of the different fee structures (Move and EVM). 

> [!WARNING] 
> This MIP does not cover _staking_ (and slashing and rewards) for validators.

## Fee structure 

The cost of processing a transaction on a Movement chain is [multi-dimensional](https://medium.com/offchainlabs/understanding-arbitrum-2-dimensional-fees-fd1d582596c9):

1. **execution** fees: the costs that correspond to resources usage, CPU and permanent storage.
2. **data availability** fees: the costs of publishing transactions/blocks data to a _data availability layer_.
3. **settlement** fees: the costs of _validating_ a transaction (e.g. zk-proof generation and verification, validators attestations.)

Overall the transaction fees are the defined by the sum of the three types of fees:

$$ \textit{ExecFees} + \textit{DAFees} + \textit{SetlFees}\mathpunct. $$

The fees should be expressed in a single (crypto)-currency, e.g. USD, or a token \$APT, \$MOVE, \$ETH.

### Execution 

#### MoveVM execution fees 

To execute a transaction and store the result, the operator of the chain uses some hardware: CPU and disk storge. The **execution** fees represent the compensation of the operator for executing a transaction. 

Movement Network uses Aptos-Move as the execution layer and the execution fees for Aptos-Move are defined in the Aptos documentation [Gas and storage fees](https://aptos.dev/en/network/blockchain/gas-txn-fee). 
The Aptos-Move fee mechanism splits the execution fees in two parts:

- CPU and IO operations, expressed in gas units; 
- permanent storage, expressed in \$APT.

CPU and IO operations for a transaction $tx$ result in a number of gas units $g(tx)$, and the corresponding fees are computing using a _gas price_ $GasPrice$ expressed in the gas token (\$APT for Aptos-Move). A transaction specifies the value $GasPrice(tx)$ it is willing to pay.  
The value $GasPrice(tx)$ must not be lower than a minimum $GasPrice$, which may fluctuate depending on network contention, and may be updated frequently (e.g. after each block). 

In contrast, the permanent storage fees are designed to be stable and are updated infrequently. The reasoning is that they depend on how much storage costs (hardware, disks) and with advancement in technology this should go down in the future. The storage fees for $tx$ are denoted $StoreFees(tx)$ and expressed in \$APT[^3].

The fees that correspond to the permanent storage are **converted to gas units** using the  $GasPrice$ and the \$APT price. 

The _total charge in gas units_ for a transaction is the defined by:

$$ TotalGasUnits(tx) = g(tx) + StoreFees(tx)/GasPrice(tx)$$

and the total transaction fees are approximately[^1]:

$$ ExecFees(tx) = TotalGasUnits(tx) \times GasPrice(tx) \mathpunct.$$


> [!WARNING]
We may not use the \$APT token value to compute the fees on Movement. If we do so the $ExecFees$ will be identical to processing fees on Aptos-Move, and the total fees including $\textit{DAFees}$ and $\textit{SetlFees}$ will be higher than the processing fees on Aptos-Move, which may not be desirable.


> [!TIP]
**Proposal 1**: use the $\textit{TotalGasUnits}(tx)$ and a $GasPrice$ in \$MOVE to compute the execution fees on a Movement chain.
This may require an oracle to get the exchange rate for \$APT/\$MOVE.


#### Gas price adjustments
We may also want to adjust the $GasPrice$ (in \$MOVE) to reflect our metwork load. There are many ways the $GasPrice$ can be updated. On Ethereum it is governed by rules in [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559). zkSync, Arbitrum and OP Mainnet use different strategies [1, 4, 6] to update the gas price. 

> [!TIP]
**Proposal 2**: The OP Mainet [1] strategy seems to be the simplest one so we may implement this strategy first. 


### Data Availability fees

On a rollup (L2), transactions are grouped in _batches_. Processing a batch result in a new _state_. Both the transactions data and the new state are published to the _data availability_ (DA) layer. The reason is that they should be available for third-parties to retrieve and verify the correctness of the state transitions (and blocks). 

We assume that the agreement with the DA provider is such that we pay a **fixed** amount, $DAPerBytePrice$, in USD, per bytes we publish to the DA layer.
This can be updated infrequently e.g. every 6 months or year.

> [!NOTE] 
The reduce the costs, the data published to the DA layer can be compressed. This reduces the overall costs of publishing a batch (and a state) to the DA layer but makes it harder to identify the contribution of each transaction to the overall costs. OP Mainet Ecotone has a [formula](https://docs.optimism.io/stack/transactions/fees#formula) to try and weight the contribution of each transaction to the compressed data. It is unclear how well it works in practice.  

> [!TIP]
> **Proposal 3**: If the cost of publishing a batch $b$ to the DA is $DAFees(b)$, and $n$ transactions are in the batch, the DA fees for each transaction are $DAFees(b)/n$. This is simple to implement and can be refined later if needed.

### Settlement Fees

The settlement fees depend on a number of factors, and on the settlement mechanism used by given Movement chain.
There is a common feature though: some data are posted to Ethereum mainnet, and the price of a transaction on Mainnet may fluctuate. 

The difficulty is that we charge our users when we process a transaction on a Moement chain. At that time we don't know the price of an Ethereum transaction to post our data because it will happen in the future when the transaction is included in a block. As a result we may have to use an oracle to provide an estimate of the (gas) price on Ethereum when our transaction is processed.

Another thing that is common to all the settlement mechanisms is that we have to publish a _commitment_ to the states/blocks we produce.
This is usually done by publishing _state roots_ (hashes of states). 
There are two interfaces to publish data on Ethereum: 
- transaction data, and
- blobs.


Blobs were introduced to lower the cost of L2s and offer temporary (18 days) data storage at low cost.
Blobs are limited in size 128KB, and a maximum of 6 blocks per (Ethereum) block. 


#### Fraud-proof settlement

For a fraud-proof settlement mechanism, we have to publish the _state roots_ of the blocks we produce, or the change sets (they may be smaller).  
The size of the state roots of change sets roots is known when we create a (l2) block, so we can determine the expected cost of publishing to Ethereum mainnet using an oracle for the Ethereum gas price. 

#### Validity proof settlement
In a validity proof settlement we have two sources of costs:
1. the _proving_ part, which is a task dedicated to provers (or a market thereof),
2.  the _verification_ part which is a transaction in Ethereum Mainnet.
 
The second part is usually predicatable as the sizes of proofs are known for each zk-proof system, and the verification step is _efficient_. 
The proving part is more complex to evaluate. The [zkSync –– Fee mechanism](https://docs.zksync.io/zk-stack/concepts/fee-mechanism) [4] may be a useful reference to design an equivalent mechanism for Movement chains. 

> [!WARNING] 
Note that we first need a zkMoveVM to develop this approach.

#### Fast-finality settlement
In our metwork, we will offer _fast-finality settlement_ (FFS) where _validators_ verify state transitions (and blocks) and interact with a contract, `StakingK`, that may live[^2] on Ethereum mainnet. 

The costs incurred by the validators plus the cost of posting the attestations to Ethereum mainnet have to be factored in the $\textit{SetlFees}$.

> [!WARNING]
We have bnot finalised the FFS details yet so it may be premature to try and define fees for this mechanism. It also pertains to _staking_ which is not fully fledged yet.

> [!TIP]
**Proposal 4**: The simplest approach seems to implement a fraud-proof fee mechanism and publish state roots to Ethereum mainnet.

## References 

\[1\]  [Transaction fees on OP Mainet](https://docs.optimism.io/stack/transactions/fees). Optimism Documentation.

\[2\]  [Sui –– Gas Pricing](https://docs.sui.io/concepts/tokenomics/gas-pricing) . Sui Documentation.

\[3\] [Gas and storage fees](https://aptos.dev/en/network/blockchain/gas-txn-fee). Aptos documentation.

\[4\] [zkSync –– Fee mechanism](https://docs.zksync.io/zk-stack/concepts/fee-mechanism). zkSync documentation.

\[5\] [Transaction fees on Mantle](https://docs-v2.mantle.xyz/devs/concepts/tx-fee/overviews). Mantle documentation.


\[6\]  [Gas and Fees](https://docs.arbitrum.io/how-arbitrum-works/gas-fees). Arbitrum documentation.

<!-- \[4\] Arbitrum. [L1 Pricing.](https://developer.arbitrum.io/arbos/l1-pricing)

\[5\] D. Goldman. Medium, July 1st, 2022. [Understanding Arbitrum 2-Dimensional Fees.](https://medium.com/offchainlabs/understanding-arbitrum-2-dimensional-fees-fd1d582596c9) -->

<!-- \[6\] DZack23. July 2022. [L1 calldata data pricing / Sequencer reimbursement, "Fee Pool" Model.](https://research.arbitrum.io/t/l1-calldata-data-pricing-sequencer-reimbursement-fee-pool-model/107)
 -->
\[7\] [EIP-1559.](https://eips.ethereum.org/EIPS/eip-1559)

\[8\] Ethereum. [Gas and
Fees.](https://ethereum.org/en/developers/docs/gas/#eip-1559)

\[9\] [Multi-dimensional EIP-1559.](https://ethresear.ch/t/multidimensional-eip-1559/11651)

\[10\] [Notes on multi-dimensional EIP-1559.](https://youtu.be/QbR4MTgnCko)

<!-- \[11\] Optimism. [Bedrock Fees Dashboard.](https://dune.com/oplabspbc/optimism-bedrock-migration-impact-dashboard.) -->

<!-- \[12\] Arbitrum Nitro. [Fees Dashboard.](https://dune.com/taem/arbitrum-gas-fee)

\[13\] [EigenLayer.](https://www.eigenlayer.xyz)

\[14\] Ethereum. [Scaling.](https://ethereum.org/pt/roadmap/scaling/)
 -->
 
---

[^1]: There is another _refund_ component in the Aptos-Move fee statement that we ignore here.

[^2]: We may be able to have the quorum verification function in a Movement contract which would reduce the costs.

[^3]: It looks like the actual currency used to express this fee is a stable currency like USD. It can be converted to \$APT using an oracle.
---
## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).