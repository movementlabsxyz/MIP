
# MIP, MD and MG

We differentiate between **issue**, **MD** and **MIP**.

A user-friendly overview of the MIPs and MDs can be found in the [MIP Book](https://movementlabsxyz.github.io/MIP/).

The [Glossary](https://github.com/movementlabsxyz/MIP/wiki/glossary) contains an alphabetically ordered list of terms used in this repository. In addition MG serves as a platform to define glossary terms, which are used in the MIPs and MDs.

## Process

The lifecycle of a proposal should be:

1. Create a [new issue](https://github.com/movementlabsxyz/MIP/issues) to register the intent to write an MD/MIP and its scope.
2. If 1. received enough traction, start an **MD** using [this Draft](../../md-template.md) in a PR.
    2.1) Upon readiness flag the MD for review by the governance.
3. Start an **MIP** using [this Draft](../../mip-template.md) in a separate PR. The MIP may be written in parallel to the MD, but is dependent on the MD.
    3.1) Upon readiness flag the MIP for review by the governance body.

> :bulb: For more information on the process, see [MIP-0](./MIP/mip-0/README.md#process).

**Proposal lifecycle**

```mermaid
graph LR
    A[1: Idea: issue] --> B[2: Define the Request: MD] --> C[3: Solution proposal: MIP]
```

**Governance lifecycle**

```mermaid
graph LR
    A[2.1:  MD] -- Accept decision --> B[3.1: MIP] -- Accept decision --> C[Implementation]
```

## Movement Desiderata (MD)

MDs serve to capture the **objectives** behind the **introduction** of a particular MIP. Any  

- _wish_,
- _requirement_, or
- _need_

related to MIPs should be documented as an MD and stored in the MD directory.

A **template with instructions** is provided at [md-template](md-template.md). See [MIP-0](./MIP/mip-0) for a definition of its functionality.

## Movement Improvement Proposal (MIP)

A **template with instructions** is provided at [mip-template](mip-template.md). See [MIP-0](./MIP/mip-0) for a definition of its functionality.

#### Deciding whether to propose

You **SHOULD** draft and submit an MIP, if any of the following are true:

- Governance for the relevant software unit or process requires an MIP.
- The proposal is complex or fundamentally alters existing software units or processes.

AND, you plan to do the work of fully specifying the proposal and shepherding it through the MIP review process.

You **SHOULD NOT** draft an MIP, if any of the following are true:

- You only intend to request a change to software units or processes without overseeing specification and review.
- The change is trivial. In the event that an MIP is required by governance, such trivial changes usually be handled as either errata or appendices of an existing MIP.

## Glossary and Movement Gloss (MG)

A template with instructions is provided at [mg-template](mg-template.md). See [MIP-15](./MIP/mip-15) for a definition of its functionality. See [MG-0](./MG/mg-0) for an example.

An alphabetically ordered list of terms is provided in the [glossary](https://github.com/movementlabsxyz/MIP/wiki/glossary).

MGs serve to capture the **definitions** of terms introduced in the MIPs and MDs. The creation of a new MG requires an MIP or MG (since new terms are introduced through the MIP or MG).

See [MG-0](./MG/mg-0) for an example to get started. A template is provided at [mg-template](mg-template.md).

## Style guide

See [STYLEGUIDE.md](STYLEGUIDE.md) for a style guide for the MIPs, MDs and MGs.

## Files and numbering

An MIP/MD uses the PR number as the MIP/MD number. Note that PRs that do not introduce a new MIP/MD are also accepted. Thus, there will be gaps in the MIP/MD number sequence.

Each MIP, MD or MG is stored in a separate subdirectory with a name `mip-<number>`, `md-<number>` or `mg-<number>`. The subdirectory contains a `README.md` that describes the MIP, MD, or MG. All assets related to the MIP, MD or MG are stored in the same subdirectory.

An MIP/MD starts as **Draft**.

PRs that don't introduce a new MIP/MD are also accepted, for example MIPs/MDs can be updated. PRs that **Update** a MIP/MD should state so in the PR title, e.g. `[Update] MIP-....`.

**Parent-Child MIPs** are also supported. A child MIP is stored in a subdirectory of the parent MIP, named `mip-<number>.<index>`. The index is a number starting from 1. The child MIP should contain a `README.md` that describes the child MIP. For more information see [MIP-94](./MIP/mip-94).

## Status terms

**Github status terms**
An MIP/MD is proposed through a PR. Each MIP/MD PR should have a status in the name in the form `[status] MIP/MD-x: ...`.

An MIP/MG should at all times have one of the following PR statuses:

- **Draft** - (set by author) An MIP/MD that is open for consideration. (It does not yet hold an MIP/MD number)
- **Review** - (set by author) The new MIP/MD is under peer review. The MIP/MD should receive an **MIP/MD number**, according to the rules described in the [Files and numbering](#files-and-numbering) section.
- **Update** - (set by author) An existing MIP/MD is being updated. The title should list the MIP/MD number, e.g. `[Update] MIP-0 ...`.

In case the editors are not available for an unacceptable long period of time, a reviewer should assume the role of the editor interim.

**Approval status terms**
The governance body can set the following statuses. This type of status is displayed at the top of the MD/MIP-file.

- **Accepted** - an MIP/MD has been accepted by the governance body.
- **Rejected** - an MIP/MD has been rejected by the governance body.
- **Stagnant** - an MIP/MD that has not been updated for 6 months. Upon this status the PR will be closed.
- **Withdrawn** - an MIP/MD that has been withdrawn.

## Roles

**Approval and governance**
MDs and MIPs are approved or rejected by the governance body. The approval is not necessarily tightly coupled to the Github flow.

Currently the governance consists of [@franck44](https://github.com/franck44), [@l-monninger](https://github.com/l-monninger), [@apenzk](https://github.com/apenzk), [@0xmovses](https://github.com/0xmovses), [@bhenhsi](https://github.com/bhenhsi).

For more information on the role of the governance, see [MIP-0: Section "Governance"](./MIP/mip-0/README.md#governance).

**Editor**
Currently the editors are [@apenzk](https://github.com/apenzk).

For more information on the role of the editor, see [MIP-0: Section "Editor"](./MIP/mip-0/README.md#editor).

**Code owners**
An author commits to becoming the owner of the MIP/MD they propose. This means that for any future changes to the MIP/MD the author will be notified.
The author MUST add themselves as a code owner in [CODEWONERS](.github/CODEOWNERS).

## Copyright

Copyright and related rights waived via [CC0](LICENSE.md).
