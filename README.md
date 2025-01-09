
# MIP, MD and MG

We differentiate between issues, MD and MIPs.

An overview of the MIPs and MDs can be found in the [OVERVIEW](https://movementlabsxyz.github.io/MIP/).

The lifecycle of a proposal should be:

1. create a [new issue](https://github.com/movementlabsxyz/MIP/issues) to register the intent to write an MD/MIP and its scope.
2. If 1. is approved (this may require some discussions), start writing an MD and create a PR for it using [this Draft](../../md-template.md).
3. The author MAY start an MIP using [this Draft](../../mip-template.md) in the same PR as the MD. However, doing so may slow down the governance approval of the MD. A preferred approach is to start with the MD, then await governance approval and only then start the MIP in a separate PR.

```mermaid
graph LR
    A[Idea: issue] --> B[Request: MD] --> C[Solution: MIP]
```

In addition MG serves as a glossary for terms defined in the MIPs and MDs.

!!! info For more information on the process in this repository, see also[MIP-0](./MIP/mip-0/README.md).

## Movement Desiderata (MD)

MDs serve to capture the **objectives** behind the **introduction** of a particular MIP. Any  

- _wish_,
- _requirement_, or
- _need_

related to MIPs should be documented as an MD and stored in the MD directory.

A template with instructions is provided at [md-template](md-template.md). See [MIP-0](./MIP/mip-0) for a definition of its functionality.

## Movement Improvement Proposal (MIP)

A template with instructions is provided at [mip-template](mip-template.md). See [MIP-0](./MIP/mip-0) for a definition of its functionality.

### Deciding whether to propose

You **SHOULD** draft and submit an MIP, if any of the following are true:

- Governance for the relevant software unit or process requires an MIP.
- The proposal is complex or fundamentally alters existing software units or processes.

AND, you plan to do the work of fully specifying the proposal and shepherding it through the MIP review process.

You **SHOULD NOT** draft an MIP, if any of the following are true:

- You only intend to request a change to software units or processes without overseeing specification and review.
- The change is trivial. In the event that an MIP is required by governance, such trivial changes usually be handled as either errata or appendices of an existing MIP.

## Movement Glossary (MG)

See [MG-0](./MG/mg-0) to get started. A template is provided at [mg-template](mg-template.md).

An alphabetically ordered list of terms is provided in the [glossary](GLOSSARY.md).

MGs serve to capture the **definitions** of terms introduced in the MIPs and MDs. The creation of a new MG requires an MIP or MG (since new terms are introduced through the MIP or MG).

## Files and numbering

Each MIP, MD or MG is stored in a separate subdirectory with a name `mip-<number>`, `md-<number>` or `mg-<number>`. The subdirectory contains a `README.md` that describes the MIP, MD, or MG. All assets related to the MIP, MD or MG are stored in the same subdirectory.

An MIP/MD starts as **Draft**s. They DO NOT acquire a number at this point.

An MIP/MD is assigned their PR number as soon as they are in the **Review** process. MDs that do not introduce a new MIP/MD are also accepted. Thus, there will be gaps in the MIP/MD number sequence. These gaps will also emerge when MIPs/MDs are deprecated or rejected.

PRs that don't introduce a new MIP/MD are also accepted, for example MIPs/MDs can be updated. PRs that **Update** a MIP/MD should state so in the PR title, e.g. `[Update] MIP-....`.

## Status Terms

An MIP/MD is proposed through a PR. Each MIP/MD PR should have a status in the name in the form `[status] MIP/MD-x: ...`.

An MIP/MG should at all times have one of the following statuses:

- **Draft** - (set by author) An MIP/MD that is open for consideration. (It does not yet hold an MIP/MD number)
- **Review** - (set by author) The MIP/MD is under peer review. The MIP/MD should receive an **MIP/MD number**, according to the rules described in the [Files and numbering](#files-and-numbering) section. At this point the editor should be involved to ensure the MIP/MD adheres to the guidelines.

!!! info In case the editors are not available for an unacceptable long period of time, a reviewer should assume the role of the editor interim.

After acceptance the MIP/MD is merged into `main` and the branch should be deleted.

Additionally, the following statuses are used for MIPs/MDs that are not actively being worked on:

- **Stagnant** - an MIP/MD that has not been updated for 6 months. Upon this status the PR will be closed.
- **Withdrawn** - an MIP/MD that has been withdrawn.

Finally, an MIP/MD can also be updated:

- **Update** - (set by author) An MIP/MD is being updated. The title should list the MIP/MD number, e.g. `[Update] MIP-0 ...`.

## Governance

For more information on the role of the governance, see [MIP-0: Governance](./MIP/mip-0/README.md#governance).

Currently the governance consists of [@franck44](https://github.com/franck44), [@l-monninger](https://github.com/l-monninger), [@apenzk](https://github.com/apenzk), [@0xmovses](https://github.com/0xmovses), [@bhenhsi](https://github.com/bhenhsi).

## Editor

For more information on the role of the editor, see [MIP-0: Editor](./MIP/mip-0/README.md#editor).

Currently the editors are [@apenzk](https://github.com/apenzk).

## Code owners

An author commits to becoming the owner of the MIP/MD they propose. This means that for any future changes to the MIP/MD the author will be notified.

The author MUST add themselves as a code owner in [CODEWONERS](.github/CODEOWNERS).
