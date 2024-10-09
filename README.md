
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
Each MIP, MD or MG is stored in a separate subdirectory with the a name `mip-<number>`, `md-<number>` or `mg-<number>`. The subdirectory contains a README.md file that describes the MIP, MD, or MG. All assets related to the MIP, MD or MG are stored in the same subdirectory.

MIPs, MDs and MGs are assigned their PR number as soon as they are drafted. MDs that do not introduce a new MIP are also accepted. Thus, there will be gaps in the MIP number sequence. These gaps will also emerge when MIPs are deprecated or rejected.
