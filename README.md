
# MIPs and MDs

We differentiate between MD and MIPs.

## Movement Desiderata (MD) 

See [MD-0](./MD/md-0) to get started.

MDs serve to capture the **objectives** behind the **introduction** of a particular MIP.
Any  
- _wish_, 
- _requirement_, or 
- _need_ 

related to MIPs should be documented as an MD and stored in the MD directory. 

## Movement Improvement Proposal (MIP)

See [MIP-0](./MIP/mip-0) to get started.


### Deciding whether to propose
You **SHOULD** draft and submit an MIP, if any of the following are true:
- Governance for the relevant software unit or process requires an MIP.
- The proposal is complex or fundamentally alters existing software units or processes.

AND, you plan to do the work of fully specifying the proposal and shepherding it through the MIP review process. 

You **SHOULD NOT** draft an MIP, if any of the following are true:
- You only intend to request a change to software units or processes without overseeing specification and review.
- The change is trivial. In the event that an MIP is required by governance, such trivial changes usually be handled as either errata or appendices of an existing MIP. 

## Files and numbering
Each MIP or MD is stored in a separate subdirectory with the a name `md-<number>` or `mip-<number>`. The subdirectory contains a `README.md` file that describes the MIP or MD. All assets related to the MIP or MD are stored in the same subdirectory.

MIPs start as Drafts. MIPs obtain a number during the review process described in [Status Terms](#status-terms). 

PRs that don't introduce a new MIP are also accepted. 
- MIPs can be updated. PRs that update a MIP should state so in the PR title via `[Update] .... `. 

There may be gaps in the numbering, as MIPs get rejected and removed.


## Status Terms
An MIP is proposed through a PR. Each MIP-introducing PR should have a status in the name in the form `[Status] ...`.

An MIP should at all times have one of the following statuses:
- **Draft** - (set by author) An MIP that is open for consideration. (It does not yet hold an MIP number)
- **Review** - (set by author) The MIP is under peer review. The MIP should receive an **MIP number** and the MIP should be registered in the MIP overview file.
- **Accepted** - (set by editor) An MIP that has been accepted. All technical changes requested have been addressed by the author. There may be additional non-technical changes requested by the MIP editor.

After acceptance the MIP is merged into `main` and the branch should be deleted.

Addtionally, the following statuses are used for MIPs that are not actively being worked on:
- **Stagnant** - an MIP that has not been updated for 6 months.
- **Withdrawn** - an MIP that has not been updated for 6 months.
