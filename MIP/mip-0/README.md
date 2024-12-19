# MIP-0: Formalize Movement Proposals
- **Description**: A process through with Movement Improvement Proposals standardize and formalize specifications for Movement technologies.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz), [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)
- **Desiderata**: [MD-0](../MD/md-0)

## Abstract

This document formalizes the process through which Movement Improvement Proposals standardize and formalize specifications for Movement technologies, through MIPs (Movement Improvement Proposals), MDs (Movement Desiderata), and issues.

## Motivation

Movement technologies continually evolve, and there's a need to ensure that the process of proposing and adopting changes is both organized and standardized. By establishing MIPs, we aim to facilitate the introduction of new features or improvements, making sure they are well-vetted, discussed, and documented. This ensures the integrity of Movement technologies, making it easier for third parties to adopt and adapt to these changes.

## Specification

To summarize, the lifecycle of a proposal should be:

1. create a [new issue](https://github.com/movementlabsxyz/MIP/issues) to register the intent to write an MD/MIP and its scope.
2. If 1. is approved (this may require some discussions), start writing an MD and create a PR for it using [this Draft](../../md-template.md).
3. if 2. is approved (this may require some discussions on the MD PR) start writing the MIP and create a PR for it using [this Draft](../../mip-template.md).

### Issue

Issues are used to propose trivial changes or improvements to Movement technologies. They are used to discuss and document the rationale behind a proposed change, and to gather feedback from the community. Issues are not formalized and do not require a specific structure. They are used to gauge interest and to start discussions.

### MD

Movement Desiderate (MDs) are used to request new features, highlight new requirements, or propose new ideas. MDs are formalized and require a specific structure. They are used to provide a standardized means for requesting changes to Movement technologies, and to guide in written structure and by facilitating engagement.

We provide a [template](../../md-template.md) for MDs, which should be used for specifying complex changes to Movement technologies.

**Lifecycle**: An MIP starts as a draft, after which it undergoes discussions and revisions. Once agreed upon, it moves to a 'published' status. An MIP can also be deprecated if it becomes obsolete. The available statuses are listed in the [root README](../../README.md).

**Storage**: MDs should be stored in the [MDs directory](../../MD/). For each MIP a separate directory should be created, containing the MD in markdown format, and any additional files required for the MD.

**Structure**: Each MD must adhere to [this template](../../md-template.md), which requires details like title, description, author, status, and more. An MD also includes sections like Overview, Desiderata and Changelog.

**Changelog**: Post-publication changes, if any, to the MDs should be documented in this section. This ensures transparency and provides readers with accurate and up-to-date information.

### MIP

Movement Improvement Proposals (MIPs) serve as a mechanism to propose, discuss, and adopt changes or enhancements to Movement technologies. By providing a standardized and formalized structure for these proposals, MIPs ensure that proposed improvements are well-defined, transparent, and accessible to the wider community.

A Movement Improvement Proposal (MIP) is a design document that provides information to the Movement community, describing a new feature or improvement for Movement technologies.

**Lifecycle**: An MIP starts as a draft, after which it undergoes discussions and revisions. Once agreed upon, it moves to a 'published' status. An MIP can also be deprecated if it becomes obsolete. The available statuses are listed in the [root README](../../README.md).

**Storage**: MIPs should be stored in the [MIPs directory](../). For each MIP a separate directory should be created, containing the MIP in markdown format, and any additional files required for the MIP.
  
**Structure**: Each MIP must adhere to [this template](../../mip-template.md), which requires details like title, description, author, status, and more. A MIP also includes sections like Abstract, Motivation, Specification, Reference Implementation, Verification, Changelog, and Appendix, see next.

**Reference Implementation**: A reference implementation or a sample MIP following the MIP template can be provided to guide potential proposers. This MIP (MIP-0) serves as a practical example, aiding in understanding the format and expectations.
  
**Definitions** : Provide definitions that you think will empower the reader to quickly dive into the topic.

**Verification**

1. Correctness: Each MIP must convincingly demonstrate its correctness.

This MIP is correct insofar as it uses a structure established by Ethereum for Improvement Proposals which has hitherto been successful.

2. Security Implications: Each MIP should be evaluated for any potential security risks it might introduce to Movement technologies.

The primary security concern associated with this MIP is the exposure of proprietary technologies or information via the ill-advised formation of an MIP which the MIP process might encourage.

3. Performance Impacts: The implications of the proposal on system performance should be analyzed.

The primary performance concern associated with this MIP is its potential for overuse. Only specifications that are non-trivial and very high-quality should be composed as MIPs.

4. Procedures: To the extent possible, formal, analytical, or machined-aided validation of the above should be pursued. 

I'm using spellcheck while writing this MIP. You can verify that I am using valid grammar by pasting this sentence into Google Docs.

5. Peer Review and Community Feedback: A section should be included that captures significant feedback from the community, which may influence the final specifications of the MIP.

The Movement Labs team is currently reviewing and assessing this process.

**Appendix**: The Appendix should contain references and notes related to the MIP. Materials referenced in the MIP should be marked with specific labels (e.g., ⟨R1⟩) for easy tracking and understanding.

**Changelog**: Post-publication changes, if any, to the MIPs should be documented in this section. This ensures transparency and provides readers with accurate and up-to-date information.

## Changelog

- 2024-12-18: Add information about the process and structure of MDs.
