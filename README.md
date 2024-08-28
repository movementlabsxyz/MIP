
# MIPs and MDs

We differentiate between MD and MIPs.

## Movement Desiderata (MD) 

MDs serve to capture the **objectives** behind the **introduction** of a particular MIP.
Any  
- _wish_, 
- _requirement_, or 
- _need_ 

related to MIPs should be documented as an MD and stored in the MD directory. 

See [MIP-0](./MD/md-0) to get started.

## Movement Improvement Proposal (MIP)

Movement Improvement Proposals. See [MIP-0](./MIP/mip-0) to get started.


### Deciding whether to propose
You **SHOULD** draft and submit an MIP, if any of the following are true:
- Governance for the relevant software unit or process requires an MIP.
- The proposal is complex or fundamentally alters existing software units or processes.

AND, you plan to do the work of fully specifying the proposal and shepherding it through the MIP review process. 

You **SHOULD NOT** draft an MIP, if any of the following are true:
- You only intend to request a change to software units or processes without overseeing specification and review.
- The change is trivial. In the event that an MIP is required by governance, such trivial changes usually be handled as either errata or appendices of an existing MIP. 

## Files and numbering
Each MIP or MD is stored in a separate subdirectory with the a name `md-<number>` or `mip-<number>`. The subdirectory contains a README.md file that describes the MIP or MD. All assets related to the MIP or MD are stored in the same subdirectory.

MDs and MIPs are assigned their PR number as soon as they are drafted. PRs that do not introduce a new MIP are also accepted. Thus, there will be gaps in the MIP number sequence. These gaps will also emerge when MIPs are deprecated or rejected.

