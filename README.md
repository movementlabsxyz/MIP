
# MIP, MD and MG

We differentiate between MD and MIPs.

In addition MG serves as a glossary for terms defined in the MIPs and MDs.

## Movement Desiderata (MD)

See [MD-0](./MD/md-0) to get started. A template is provided at [md-template](md-template.md).

MDs serve to capture the **objectives** behind the **introduction** of a particular MIP. Any  

- _wish_,
- _requirement_, or
- _need_

related to MIPs should be documented as an MD and stored in the MD directory.

## Movement Improvement Proposal (MIP)

See [MIP-0](./MIP/mip-0) to get started. A template is provided at [mip-template](mip-template.md).

Here is a list of pending MIPs:


Identifier | Status | Author | Description | MD | Ready to merge |
|--------|--------|--------|-------------|----|---|
| [MIP-0](https://github.com/movementlabsxyz/MIP/tree/main/MIP/mip-0) | Approved | @l-monninger | This MIP | |  |
| [MIP-1](https://github.com/movementlabsxyz/MIP/tree/l-monninger/entl/MIP/mip-1) | Pending | @l-monninger | ENTL (Enclave Nonce Time-lock) | | :x: (draft) |
| [MIP-13](https://github.com/movementlabsxyz/MIP/tree/mikhail/suzuka-da-migrations/MIP/mip-13) | Pending | @mzabaluev | Suzuka DA Migrations Format | [MD-13](https://github.com/movementlabsxyz/MIP/tree/mikhail/suzuka-da-migrations/MD/md-13) | :x: (review required) |
| [MIP-15](https://github.com/movementlabsxyz/MIP/tree/l-monninger/movement-gloss/MIP/mip-15) | Pending | @l-monninger | MG (Movement Glossary) <br> a process for introducing new glossary terms. | [MD-15](https://github.com/movementlabsxyz/MIP/tree/l-monninger/movement-gloss/MD/md-15), [MG-0](https://github.com/movementlabsxyz/MIP/tree/l-monninger/movement-gloss/MG/mg-0) | :white_check_mark:  |
| [MIP-16](https://github.com/movementlabsxyz/MIP/tree/gas-fee-calculation/MIP/mip-16) | Pending | @franck44 | Gas fee structure and calculation | | :x: (3 reviews required) | 
| [MIP-18](./MIP/mip-18) | Pending | @0xPrimata | Stage 0 Upgradeability and Multisigs | | :x: (3 reviews required) |
| [MIP-21](https://github.com/movementlabsxyz/MIP/tree/primata/bridge-attestors/MIP/mip-21) | Pending | @0xPrimata | Bridge Based on Attestors | | :x: (3 reviews required)|
| [MIP-23](https://github.com/movementlabsxyz/MIP/tree/l-monninger/releases/MIP/mip-n) | Pending | @l-monninger | Release Conventions for Movement Technologies | [MD-23](https://github.com/movementlabsxyz/MIP/tree/l-monninger/releases/MD/md-n) | :x: (1 review required) |
[MIP-24](https://github.com/movementlabsxyz/MIP/blob/andyjsbell/unwanted-framework/MIP/mip-24/README.md) | Pending | @andyjsbell | Removal of redundant functionality from framework | | :x: (3 reviews required) |
[MIP-25](https://github.com/movementlabsxyz/MIP/blob/andyjsbell/proxy-root/MIP/mip-25/README.md) | Pending | @andyjsbell | Proxy Aptos Framework for Stage 0 governance | | :x: (1 review required) |
| [MIP-27](https://github.com/movementlabsxyz/MIP/blob/primata/mip-27/MIP/mip-27/README.md) | Pending | @0xPrimata | Contract Pipeline |  | :x: (1 review required) |
| [MIP-28](https://github.com/movementlabsxyz/MIP/tree/l-monninger/actor-naming-conventions/MIP/mip-n) | Pending | @l-monninger | Naming Conventions for Movement Protocol Design | | :x: (1 review required) |

### Deciding whether to propose

You **SHOULD** draft and submit an MIP, if any of the following are true:

- Governance for the relevant software unit or process requires an MIP.
- The proposal is complex or fundamentally alters existing software units or processes.

AND, you plan to do the work of fully specifying the proposal and shepherding it through the MIP review process.

You **SHOULD NOT** draft an MIP, if any of the following are true:

- You only intend to request a change to software units or processes without overseeing specification and review.
- The change is trivial. In the event that an MIP is required by governance, such trivial changes usually be handled as either errata or appendices of an existing MIP.

## Movement Glossary (MG)

See [MG-0](./MIP/mg-0) to get started. A template is provided at [mg-template](mg-template.md).

An alphabetically ordered list of terms is provided in the [glossary](GLOSSARY.md).

MGs serve to capture the **definitions** of terms introduced in the MIPs and MDs. The creation of a new MG requires an MIP or MG (since new terms are introduced through the MIP or MG).

## Files and numbering

Each MIP, MD or MG is stored in a separate subdirectory with the a name `mip-<number>`, `md-<number>` or `mg-<number>`. The subdirectory contains a `README.md` that describes the MIP, MD, or MG. All assets related to the MIP, MD or MG are stored in the same subdirectory.

An MIP/MD starts as **Draft**s. They DO NOT acquire a number at this point.

An MIP/MD is assigned their PR number as soon as they are in the **Review** process. MDs that do not introduce a new MIP/MD are also accepted. Thus, there will be gaps in the MIP/MD number sequence. These gaps will also emerge when MIPs/MDs are deprecated or rejected.

PRs that don't introduce a new MIP/MD are also accepted, for example MIPs/MDs can be updated. PRs that **Update** a MIP/MD should state so in the PR title, e.g. `[Update] MIP-.... `.

## Status Terms

An MIP/MD is proposed through a PR. Each MIP/MDG-introducing PR should have a status in the name in the form `[Status] ...`.

An MIP/MG should at all times have one of the following statuses:

- **Draft** - (set by author) An MIP/MD that is open for consideration. (It does not yet hold an MIP/MD number)
- **Review** - (set by author) The MIP/MD is under peer review. The MIP/MD should receive an **MIP/MD number**, according to the rules described in the [Files and numbering](#files-and-numbering) section. At this point the editor should be involved to ensure the MIP/MD adheres to the guidelines.

>[!Note]
> In case the editors are not available for an unacceptable long period of time, a reviewer should assume the role of the editor interim.

After acceptance the MIP/MD is merged into `main` and the branch should be deleted.

Additionally, the following statuses are used for MIPs/MDs that are not actively being worked on:

- **Stagnant** - an MIP/MD that has not been updated for 6 months.
- **Withdrawn** - an MIP/MD that has not been withdrawn.


Finally, MIPs can also be updated

- **Update** - (set by author) An MIP/MD is being updated. The title should list the MIP/MD number, e.g. `[Update] MIP-0 ...`.

## Editor

The motivation for the role of the editor is to ensure the readability and easy access of content, until further means, such as automatic rendering becomes available.

Currently the editors are [@apenzk](https://github.com/apenzk).

The editor is responsible for the final review of the MIPs. The editor is responsible for the following:

- Ensures a high quality of the MIPs/MDs, e.g. checking language while reviewing.
- Removes content from the MIPs/MDs that is commented out. (e.g. content within <!- -> brackets)
- Ensures the MIP/MD numbering is correct.
- Ensures the MIP/MD is in the correct status.
- Ensures the authors have added themselves to [CODEOWNERS](./.github/CODEOWNERS), see [Code owners](#code-owners).

The editor is not responsible for the content.

**Conflict resolution**: In the unlikely case, where an editor requests a change from an author that the author does not agree with and communication does not resolve the situation

- the editor can mandate that the author implements the changes by getting 2 upvotes from reviewers on their discussion comment mentioning the changes.
- Otherwise the author can merge without the editor requested change.

## Code owners

An author commits to becoming the owner of the MIP/MD they propose. This means that for any future changes to the MIP/MD the author will be notified.

This is being implemented by adding the author as a code owner in the `.github/CODEOWNERS` file for a given MIP/MD.
