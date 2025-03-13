# MIP-13:  Suzuka DA Migrations Format
- **Description**: Data format which describes migrations of the canonical state of the DA over time.
- **Authors**: [Mikhail Zabaluev](mailto:mikhail.zabaluev@movementlabs.xyz)
- **Desiderata**: [MD-13](../MD/md-13)

## Abstract

The format of a well-known file defining migrations of the DA blob format enacted on specified
block heights.
This would be a hardfork or coordinated approach (TODO: clarify terminology) to upgrades, in that
each node participating in the network SHOULD be deployed with an up to date copy of the file
describing the migrations up to and above the current block height.

## Motivation

In order to allow for safe upgrades, data model changes, and DA migrations, it has been proposed that we provide a data format which describes the canonical state of the DA over time.

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

### DA Migration Configuration Format

The format of a well-known file defining migrations is a JSON serialization of a map where keys
indicate the block height at which the configuration in the value starts applying. The values are
objects with named fields specifying the format settings. The top-level configuration envelope
specifies the current version of the format to permit breaking changes in the future.

```json
{
  "version": 1,
  "migrations": {
    "123456": {
      "namespace": "deadbeef01234567890",
      "transaction_format": 1,
      "block_format": 2,
      "ordering_rule": 3,
      "node_version": "1.2"
    }
  }
}
```

the Rust definition of the value struct:

```rust
#[derive(Serialize, Deserialize)]
pub struct DASettings {
    namespace: Namespace,
    transaction_format: TransactionFormatVersion,
    block_format: BlockFormatVersion,
    ordering_rule: OrderingRuleVersion,
    node_version: NodeVersionReq,
}
```

Here, `Namespace` is the data type representing a Celestia namespace ID with the
human-readable serialization as a hex string.
The `*Version` types are enums initially defined with a single `V1` member each.
`NodeVersionReq` serializes into a SemVer-conforming version specification in the
_MAJOR_`.`_MINOR_ format.

### Principles of managing migrations

Each new entry in the migration table SHALL use a unique Celestia namespace identifier to prevent
confusion and detect accidental misconfiguration early.

The configuration in all nodes in the network SHOULD be updated well in advance of the block height
at which a new change is introduced. The expected process in governance stage 0 is a coordinated
upgrade.

The `node_version` field gives the semver minimum version of the Suzuka full node software that is
REQUIRED to use these settings. A node that does not satisfy the version requirement for any of the
encountered entries MUST reject the configuration and report an error.

The producers and consumers of DA blobs MUST implement all versions encountered in the configuration
file and apply the settings accordingly to the block height of the data blobs. No mixing of
different DA formats between blobs submitted by correct nodes for the same block height is
supported by this specification.

### Future evolution of the DA migration configuration format

New fields can be added to the `DASettings` structures in future revisions
of this specifications without changing the value of the top-level
`version` field. Implementations SHALL ignore the fields not defined in
the revision of the specification they support. If interpretation of such newly
added field values in a specific migration requires behavior not supported
by older versions of the node software, this SHOULD be communicated to
non-compliant nodes with the compatibility requirement in the `node_version`
field.

Any values of known fields of `DASettings` that are not supported by the current
implementation SHALL result in rejecting the configuration and reporting an error.
The implementation MAY check the compatibility requirement given by `node_version`
before reporting errors on unsupported values.

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

---
## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).