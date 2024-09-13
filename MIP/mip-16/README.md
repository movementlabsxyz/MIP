
# MIP-16: Calculation of gas fees 

- **Description**: How to calculate gas fees for transactions on Movement L2.
- **Authors**: [Franck Cassez](mailto:franck.cassez@movementlabs.xyz)
- **Desiderata**: [MD-\<number\>](../MD/md-\<number\>)

<!--
  READ MIP-1 BEFORE USING THIS TEMPLATE!

  This is the suggested template for new MIPs. After you have filled in the requisite fields, please delete these comments.

  Note that an MIP number will be assigned by an editor. When opening a pull request to submit your MIP, please use an abbreviated title in the filename, `mip-draft_title_abbrev.md`.

  The title should be 44 characters or less. It should not repeat the MIP number in title, irrespective of the category.

  TODO: Remove this comment before finalizing.
-->

## Abstract
This MIP describes the components of the gas fees and overall resource consumption needed to execute, and post a transaction to the DA/L1.

<!--
  The Abstract is a multi-sentence (short paragraph) technical summary. This should be a very terse and human-readable version of the specification section. Someone should be able to read only the abstract to get the gist of what this specification does.

  TODO: Remove this comment before finalizing.
-->

## Motivation

The transaction fees on L2s are multi-dimensional, so it may be useful to clarify what the fees are and how they are charged to the transaction issuer.

<!--
  The motivation section should include a description of any nontrivial problems the MIP solves. It should not describe how the MIP solves those problems.

  TODO: Remove this comment before finalizing.
-->

## Specification

In the sequel we assume:
- \$mMOVE is the wrapped \$MOVE token on Movement Rollup.
- \$mMOVE is used to pay the gas fees on Movement Rollup.
- some data are published to a _data availability (DA)_ layer and some to Ethereum mainnet (L1). 
- we execute MoveVM transaction only (not EVM).


The cost of processing a transaction on Movement Rollup is [multi-dimensional](https://medium.com/offchainlabs/understanding-arbitrum-2-dimensional-fees-fd1d582596c9):

1. **execution fees**: off-chain/Movement, an amount that is expressed in the Movement native tokens,
    \$mMOVE, and
2. **data availability** fees: correspond to posting data to the availability layer, expressed in \$ETH.
3. **L1** fees: correspond to transactions on Ethereum mainnet, expressed in \$ETH.


### Execution fees on movement

Movement Rollup is a Move-based rollup. As a result a transaction $\textit{tx}$ executed on Movement Rollup consumes a certain of gas, 
$g(tx)$. We want to express this fees in \$mMOVE and to do so we need to define the price of a unit of gas on Movement Rollup. This price may evolve with time or per block production, and we let $gpMvmt(k)$ be the price of a unit of gas at block $k$.

If a transaction $tx$ is included in block $k$ and its execution consumes $g(tx)$ the corresponding _execution_ fees (for the transaction issuer) are:

$$ g(tx) \times gpMvmt(k)\mathpunct.$$

### Data availability costs

On a rollup, transactions are executed in batches. The transactions data and the states have to be made available so that third party can audit them. This is achieved by publishign the data (transaction and states) to a data availability layer. 

The cost of publication may depend on the size of the data and we assume that this is fixed per bytes (it may change from time to time but is fixed for a rather long period, e.g. 1 month).

What do we have to publish? Some information that enables third party to reproduce a state transition and check whether it is valid.
This means we have to publish the _calldata_ (transaction and its parameters) and some information about the new state. It could be the new state or the change set that completely characterises the new state given the previous state. 

The DA costs of a transaction consist of two components:
- transaction data, a fixed cost that depends on the size of the calldata $|tx|$ of the transaction $tx$.
- a fraction of the cost of the size of new state (or change set). Indeed, transcations are processed in batches in a block, so a new block/state corresponds to the exexcution of a sequence of transactions. If a block $B_k$ (resp. change set $S_k$) has size $|B_k|$ (resp. $S_k$) and contains $n_k$ transactions, each transaction in the block incurs a fraction $|B_k|/n_k$ (resp. $|S_k|/n_k$) of the DA cost for $B_k$ (resp. $S_k$). 

Overall, assuming the fees to publish the block to the DA for block $B_k$ are $DACost(B_k)$, each transaction $tx$ in the block incurs 
$DACost(B_k)/n_k$.

### State roots publication costs

The state roots are regulalrly published to the L1 (Ethereum). Ethereum offers a cheap way to publish small amoutn of data in the form of blobs so we may use this technique to publish the state roots.

<!--
  The Specification section should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations.

  It is recommended to follow RFC 2119 and RFC 8170. Do not remove the key word definitions if RFC 2119 and RFC 8170 are followed.

  TODO: Remove this comment before finalizing
-->

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.


## Reference Implementation

<!--
  The Reference Implementation section should include links to and an overview of a minimal implementation that assists in understanding or implementing this specification. The reference implementation is not a replacement for the Specification section, and the proposal should still be understandable without it.

  TODO: Remove this comment before submitting
-->

## Verification

<!--

  All proposals must contain a section that discusses the various aspects of verification pertinent to the introduced changes. This section should address:

  1. **Correctness**: Ensure that the proposed changes behave as expected in all scenarios. Highlight any tests, simulations, or proofs done to validate the correctness of the changes.

  2. **Security Implications**: Address the potential security ramifications of the proposal. This includes discussing security-relevant design decisions, potential vulnerabilities, important discussions, implementation-specific guidance, and pitfalls. Mention any threats, risks, and mitigation strategies associated with the proposal.

  3. **Performance Impacts**: Outline any performance tests conducted and the impact of the proposal on system performance. This could be in terms of speed, resource consumption, or other relevant metrics.

  4. **Validation Procedures**: Describe any procedures, tools, or methodologies used to validate the proposal against its requirements or objectives. 

  5. **Peer Review and Community Feedback**: Highlight any feedback from peer reviews or the community that played a crucial role in refining the verification process or the proposal itself.


  TODO: Remove this comment before submitting
-->

Needs discussion.

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
<!--
  The Appendix should contain an enumerated list of reference materials and notes.

  When referenced elsewhere each appendix should be called out with [A<number>](#A<number>) and should have a matching header.

  TODO: Remove this comment before finalizing.

-->

### A1
Nothing important here.

---
## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).