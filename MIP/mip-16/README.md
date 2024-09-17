
# MIP-16: Calculation of gas fees 

- **Description**: How to calculate gas fees for transactions on Movement L2.
- **Authors**: [Franck Cassez](mailto:franck.cassez@movementlabs.xyz)
- **Desiderata**: [MIP-\<number\>](../MD/md-\<number\>)


## Abstract
This MIP describes the structure of the gas fees and overall resource consumption needed to execute, and post a transaction to the DA/L1.


## Motivation

The transaction fees on L2s are multi-dimensional, so it may be useful to clarify what the fees are and how they are charged to the transaction issuer.


## Specification

In the sequel we assume:
- \$mMOVE is the wrapped \$MOVE token on Movement Rollup.
- \$MOVE is used to pay the gas fees on Movement Rollup. 
- one \$mMOVE has the same value as one \$MOVE.
- some data are published to a _data availability (DA)_ layer and some to Ethereum mainnet (L1). 
- we execute MoveVM transactions only (not EVM transactions).

The cost of processing a transaction on Movement Rollup is [multi-dimensional](https://medium.com/offchainlabs/understanding-arbitrum-2-dimensional-fees-fd1d582596c9):

1. **execution fees**: off-chain/Movement, an amount that is expressed in the Movement native tokens,
    \$MOVE, and
2. **data availability** fees: correspond to posting data to the availability layer, expressed in \$ETH.
3. **L1** fees: correspond to transactions on Ethereum mainnet, expressed in \$ETH.

### Execution fees on movement

Movement Rollup is a Move-based rollup. As a result a transaction $\textit{tx}$ executed on Movement Rollup consumes a certain amount of gas, 
$g(tx)$. We want to express this fees in \$MOVE and to do so we need to define the price of a unit of gas on Movement Rollup. This price may evolve with time or per block production, and we let $gpMvmt(k)$ be the price of a unit of gas at block $k$.

If a transaction $tx$ is included in block $k$ and its execution consumes $g(tx)$ gas units, the corresponding _execution_ fees (for the transaction issuer) are:

$$ g(tx) \times gpMvmt(k)\mathpunct.$$

### Data availability costs

On a rollup, transactions are executed in batches. The transactions data and the states have to be made available so that third parties can audit them. This is achieved by publishing the data (transaction data and states) to a data availability layer.

The cost of publication may depend on the size of the data and we assume that this is fixed per bytes (it may change from time to time but is fixed for a rather long period, e.g. 1 month).

**What do we have to publish?** Some information that enables third parties to reproduce a the execution of a transaction and check whether it is valid.
This means we have to publish the _calldata_ (transaction and its parameters) and some information about the _source_ (previous) and _target_ (new) states. It could be the new state or the change set that completely characterises the new state given the previous state. 

The DA costs of a transaction consist of two components:

- transaction data, a fixed cost that depends on the size of the calldata $|tx|$ of the transaction $tx$.

- a fraction of the cost of the size of new state (or change set). Indeed, transcations are processed in batches in a block, so a new block/state corresponds to the exexcution of a sequence of transactions. If a block $B_k$ (resp. change set $S_k$) has size $|B_k|$ (resp. $S_k$) and contains $n_k$ transactions, each transaction in the block incurs a fraction $|B_k|/n_k$ (resp. $|S_k|/n_k$) of the DA cost for $B_k$ (resp. $S_k$). 

Overall, assuming the fees to publish the block to the DA for block $B_k$ are $DACost(B_k)$, each transaction $tx$ in the block incurs 
$DACost(B_k)/n_k$.



### State roots publication costs

Note that rollups usually process batches of **blocks** and submit digests for these batches to further reduce the costs related to the L1.  

The **state roots** are regulalrly published to the L1 (Ethereum). Ethereum offers a cheap way to publish small amount of data in the form of _blobs_ so we may use this technique to publish the state roots.


The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.


## Reference Implementation

N/A


## Verification
N/A



---

## Errata
<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the proposal in which the error was identified.

  TODO: Maintain this comment.
-->

---

## Appendix
N/A



---
## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).