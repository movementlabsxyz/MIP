
# MIP, MD and MG

We differentiate between MD and MIPs. 

In addition MG serves as a glossary for terms defined in the MIPs and MDs.

## Movement Desiderata (MD) 

See [MD-0](./MD/md-0) to get started. A template is provided at [md-template](md-template.md).

MDs serve to capture the **objectives** behind the **introduction** of a particular MIP.
Any  
- _wish_, 
- _requirement_, or 
- _need_ 

related to MIPs should be documented as an MD and stored in the MD directory. 

## Movement Improvement Proposal (MIP)

See [MIP-0](./MIP/mip-0) to get started. A template is provided at [mip-template](mip-template.md).


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

MG serve to capture the **definitions** of terms introduced in the MIPs and MDs. The creation of a new MG requires an MIP or MG (since new terms are introduced through the MIP or MG).


## Files and numbering

Each MIP, MD or MG is stored in a separate subdirectory with the a name `mip-<number>`, `md-<number>` or `mg-<number>`. The subdirectory contains a `README.md` that describes the MIP, MD, or MG. All assets related to the MIP, MD or MG are stored in the same subdirectory.

MIP/MG start as Drafts. They do not need to acquire a number at this point. 

MIPs, MDs and MGs are assigned their PR number as soon as they are in the review process. MDs that do not introduce a new MIP are also accepted. Thus, there will be gaps in the MIP number sequence. These gaps will also emerge when MIPs are deprecated or rejected.

PRs that don't introduce a new MIP are also accepted. 

MIPs can be updated. PRs that update a MIP should state so in the PR title via `[Update] .... `. 

## Status Terms
An MIP is proposed through a PR. Each MIP-introducing PR should have a status in the name in the form `[Status] ...`.

An MIP/MG should at all times have one of the following statuses:
- **Draft** - (set by author) An MIP/MG that is open for consideration. (It does not yet hold an MIP/MG number)
- **Review** - (set by author) The MIP/MG is under peer review. The MIP should receive an **MIP number**, according to the rules described in the [Files and numbering](#files-and-numbering) section. At this point the editor should be involved to ensure the MIP adheres to the guidelines.

>[!Note]
> In case the editors are not available for an unacceptable long period of time, a reviewer should assume the role of the editor interim. 

After acceptance the MIP is merged into `main` and the branch should be deleted.

Addtionally, the following statuses are used for MIPs that are not actively being worked on:
- **Stagnant** - an MIP that has not been updated for 6 months.
- **Withdrawn** - an MIP that has not been withdrawn.


Finally, MIPs can also be updated
- **Update** - (set by author) An MIP is being updated. The titel should list the MIP number, e.g. `[Update] MIP-0 ...`.


## Editor

The motivation for the role of the editor is to ensure the readability and easy access of content, until further means, such as automatic rendering becomes available.

Currently the editors are [@apenzk](https://github.com/apenzk). 

The editor is responsible for the final review of the MIPs. The editor is responsible for the following:
- Ensures a high quality of the MIPs, e.g. checking language while reviewing.
- Removes content from the MIPs that is commented out. (<!- ->)
- Ensures the MIP numbering is correct, the MIP has been added to [OVERVIEW.md](./OVERVIEW.md)
- Ensures the MIP is in the correct status. 
- Ensures the authors have added themselves to [CODEOWNERS](./.github/CODEOWNERS).

The editor is not responsible for the content. 

**Conflict resolution**: In the unlikely case, where an editor requests a change from an author that the author does not agree with and communication does not resolve the situation
- the editor can mandate that the author implements the changes by getting 2 upvotes from reviewers on their discussion comment mentioning the changes.
- Otherwise the author can merge without the editor requested change.


## Code owners
An author commits to becoming the owner of the MIP or MD they propose. This means that for any future changes to the MIP or MD the author will be notified. 

This is being implemented by adding the author as a code owner in the `.github/CODEOWNERS` file for a given MIP or MD.
