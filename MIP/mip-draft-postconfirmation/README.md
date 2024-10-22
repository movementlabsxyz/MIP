# MIP-\<number\>: Postconfirmation
- **Description**: L1-confirmation of L2-blocks. A sub-protocol of FFS.
- **Authors**: [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)
<!-- - **Desiderata**: [MIP-\<number\>](../MIP/mip-\<number\>) -->


<!--
  READ MIP-1 BEFORE USING THIS TEMPLATE!

  This is the suggested template for new MIPs. After you have filled in the requisite fields, please delete these comments.

  Note that an MIP number will be assigned by an editor. When opening a pull request to submit your MIP, please use an abbreviated title in the filename, `mip-draft_title_abbrev.md`.

  The title should be 44 characters or less. It should not repeat the MIP number in title, irrespective of the category.

  TODO: Remove this comment before finalizing.
-->

## Abstract

At certain intervals validators commit L2-block-batches to L1. The L1 contract will verify if 2/3 of the validators have attested to the L2-block-batch height and on the default path this is initiated by a special role - the acceptor. 

This provides an L1-protected _postconfirmation_ that the block (or a batch of blocks) is confirmed. This additional anchoring mechanism increases the security of the L2-confirmation as it locks in the L2-confirmation, reduces the risk of long range attacks and provides a way to slash validators that have attested against the majority.

<!--
  The Abstract is a multi-sentence (short paragraph) technical summary. This should be a very terse and human-readable version of the specification section. Someone should be able to read only the abstract to get the gist of what this specification does.

  TODO: Remove this comment before finalizing.
-->

## New Definitions and Terms

- **validator** : A participant in the FFS protocol that is responsible for attesting to the correctness of L2-block-batches.
- **attester** (deprecated): a validator
- **postconfirmation** : a confirmation on L1, protected by a supermajority of stake
- **acceptor** : A validator that is selected to accept L2-block-batches.
- **L2-block-batch** : a batch of L2-blocks that are committed to L1.

#### Other

- **block** (not recommended): since postconfirmations are commitments on batches of L2-blocks the term L2-block-batch is preferred. Also it gets mixed up with L1-blocks. For example, the term `block` is used in the context of `block.timestamp` which refers to the L1-block time.


## Motivation

We require an FFS protocol that is secure and efficient, yet simple in its initial design. By simplicity we mean that the validators only communicate with the L1-contract and not with each other. This is a key design decision to reduce the complexity of the protocol. 

Moreover, to facilitate predictable rewards, validators only commit. While the update of the state in the contract (the postconfirmation) is left to the role of the acceptor.

<!--
  The motivation section should include a description of any nontrivial problems the MIP solves. It should not describe how the MIP solves those problems.

  TODO: Remove this comment before finalizing.
-->

## Specification

<!--
  The Specification section should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations.

  It is recommended to follow RFC 2119 and RFC 8170. Do not remove the key word definitions if RFC 2119 and RFC 8170 are followed.

  TODO: Remove this comment before finalizing
-->

L2-blocks are deterministically derived from the sequencer-batch. Validators calculate the next transition:  $B \xrightarrow{\ txs \ } B'$. After a certain number of blocks, the validators commit individually the hash of the L2-block-batch to the L1-contract. The L1-contract will verify if 2/3 of the validators have attested to the L2-block-batch height.


#### Domains - One contract to rule them all

The contract is intended to handle multiple chains. We differentiate between them by their unique identifier `domain` (of type `address`).

#### Epochs

We require epochs in order to faciliate `staking` and `unstaking` of validators, as well as rewards and penalties. The `epochDuration` is set when initializing a chain. 

There are two types of epochs
1. The **_current epoch_** is the epoch that is currently active and it determines the current `acceptor`.
```solidity
currentEpoch = getEpochByL1BlockTime();
```
where
```solidity
function getEpochByL1BlockTime(address domain) public view returns (uint256) {
    return block.timestamp / epochDuration;
}
```

2. The **_accepting epoch_** is the epoch in which commitments are counted and postconfirmation for an L2-block-batch is created. 

Note that validator L1-transactions could get lost, or validators can become inactive. Since liveness concerns should be handled, we permit for a more recent epoch to accept the L2-block-batch from an earlier epoch. 

#### L2-block-batches

Validators commit the hash of the L2-block-batch to the L1-contract. If an L2-block-batch is new, the L1-contract will asign the `current epoch` to the L2-block-batch hash. 

```solidity
// commits a attester to a particular block
function submitBlockCommitmentForAttester(address attester,  BlockCommitment memory blockCommitment) internal {
  ...
  if (blockHeightEpochAssignments[blockCommitment.height] == 0) {
      blockHeightEpochAssignments[blockCommitment.height] = getEpochByL1BlockTime();
  }
  ...
}
```


#### Acceptor

Every interval `acceptorTerm` one of the validators takes on the role to accept L2-block-batches. This acceptor is selected via L1-randomness provided through L1-block hashes. This acceptor is responsible for updating the contract state once a super-majority is reached for an L2-block-batch. The acceptor is rewarded for this service.

The L1-contract determines the current valid `acceptor` by considering the current L1-block time (`block.timestamp`) and randomness provided through L1-block hashes. For example,

```solidity
function getCurrentAcceptor() public view returns (address) {
  uint256 currentL1BlockHeight = block.number;
  // -1 because we do not want to consider the current block.
  uint256 relevantL1BlockHeight = currentL1BlockHeight - currentL1BlockHeight % acceptorTerm - 1 ; 
  bytes32 blockHash = blockhash(relevantL1BlockHeight);
  address[] memory attesters = getAttesters();
  // map the blockhash to the attesters
  uint256 leaderIndex = uint256(blockHash) % attesters.length;
  return attesters[acceptorIndex];        
}
```




**Liveness**. In order to guarantee liveness the protocol ensures that anyone can voluntarily provide the service of the accepter. However, no reward is being issued for this service.

![Version A Diagram](postconfirmation.png)
*Figure 1: Leader-independent block generation process in Version B.*




<!--The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.-->


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