
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

Here is a list of MDs with their statuses:


Identifier | Status | Author | Description | MIP | Ready to merge |
|--------|--------|--------|-------------|----|---|
| [MD-0](https://github.com/movementlabsxyz/MIP/tree/main/MD/md-0) | Approved | @l-monninger | This MD | |  |
| [MD-2](https://github.com/movementlabsxyz/MIP/tree/l-monninger/enclave-crash-resistant-keys/MD/md-2) | Draft | @l-monninger | Crash-resistant Enclave Keys | | :x: | 
| [MD-3](https://github.com/movementlabsxyz/MIP/tree/l-monninger/mcr-asynchrony/MD/md-3) | Draft | @l-monninger | MCR under Network Partitions and Asynchrony | | :x: | 
| [MD-4](https://github.com/movementlabsxyz/MIP/tree/l-monninger/gas-offset/MD/md-4) | Draft | @l-monninger | MCR under Network Partitions and Asynchrony | | :x: | 
|[MD-5](https://github.com/movementlabsxyz/MIP/tree/l-monninger/long-range-attacks/MD/md-5) | Draft | @l-monninger | Long Range Attacks | | :x: | 
|[MD-6](https://github.com/movementlabsxyz/MIP/tree/l-monninger/block-validation/MD/md-6) | Draft | @l-monninger | Suzuka Block Validation | | :x: |
| [MD-7](https://github.com/movementlabsxyz/MIP/tree/l-monninger/mev/MD/md-7) | Draft | @l-monninger | Prevent Suzuka MEV Exploits and Censorship | | :x: |
[MD-13](https://github.com/movementlabsxyz/MIP/tree/mikhail/suzuka-da-migrations/MD/md-13) | ? | @mzabaluev | Suzuka DA Migrations Format |  [MIP-13](https://github.com/movementlabsxyz/MIP/tree/mikhail/suzuka-da-migrations/MIP/mip-13) | Renamed?  | 
| [MD-14](https://github.com/movementlabsxyz/MIP/tree/primata/bridge-timelock-as-state/MD/md-14) | Pending | @0xPrimata | Bridge Should Use A More Secure Timelock | | :x: (1 review required) |
| [MD-15](https://github.com/movementlabsxyz/MIP/tree/l-monninger/movement-gloss/MD/md-15) | Pending | @l-monninger | Movement Glossary | [MIP-15](https://github.com/movementlabsxyz/MIP/tree/l-monninger/movement-gloss/MIP/mip-15) | :x: (2 reviews required) |
| [MD-16](https://github.com/movementlabsxyz/MIP/tree/andygolay/move-on-bitcoin/MD/md-16) | Pending | @andygolay | Move on Bitcoin | | :x: (3 reviews required)  |
| [MD-17](https://github.com/movementlabsxyz/MIP/blob/6722c67a8434de07c6612e46b5a023b63ad8dcbd/MD/md-17/README.md) | Pending | @0xPrimata | Bridge Fees | | :x: (3 reviews required) |
| [MD-20](https://github.com/movementlabsxyz/MIP/tree/0xmovses/bridge-swap/MD/md-20) | Pending | @0xmovses| Bridge swap |  [MD-17](https://github.com/movementlabsxyz/MIP/blob/6722c67a8434de07c6612e46b5a023b63ad8dcbd/MD/md-17/README.md), [MIP-20](https://github.com/movementlabsxyz/MIP/blob/0xmovses/bridge-swap/MIP/mip-20/README.md) | :x: (2 reviews required) | 
| [MD-26](https://github.com/movementlabsxyz/MIP/tree/andygolay/md-26/MD/md-26) | Pending | @andygolay | User-facing checks | | :x: (1 review required) |
| [MD-30](https://github.com/movementlabsxyz/MIP/blob/4c62ae80b3e72dc7a641ad6f3b06af5f081e450b/MD/md-30/README.md) | Pending | @0xPrimata | Movement Name Service | | :x: (3 reviews required)  |

## Movement Improvement Proposal (MIP)

See [MIP-0](./MIP/mip-0) to get started.

Here is a list of MIPs with their statuses:

Identifier | Status | Author | Description | MD | Ready to merge |
|--------|--------|--------|-------------|----|---|
| [MIP-0](https://github.com/movementlabsxyz/MIP/tree/main/MIP/mip-0) | Approved | @l-monninger | This MIP | |  |
| [MIP-1](https://github.com/movementlabsxyz/MIP/tree/l-monninger/entl/MIP/mip-1) | Draft | @l-monninger | ENTL (Enclave Nonce Time-lock) | | :x:  |
| [MIP-13](https://github.com/movementlabsxyz/MIP/tree/mikhail/suzuka-da-migrations/MIP/mip-13) | Pending | @mzabaluev | Suzuka DA Migrations Format | [MD-13](https://github.com/movementlabsxyz/MIP/tree/mikhail/suzuka-da-migrations/MD/md-13) | :x: (review required) |
| [MIP-15](https://github.com/movementlabsxyz/MIP/tree/l-monninger/movement-gloss/MIP/mip-15) | Pending | @l-monninger | MG (Movement Glossary) <br> a process for introducing new glossary terms. | [MD-15](https://github.com/movementlabsxyz/MIP/tree/l-monninger/movement-gloss/MD/md-15), [MG-0](https://github.com/movementlabsxyz/MIP/tree/l-monninger/movement-gloss/MG/mg-0) | :white_check_mark:  |
| [MIP-16](https://github.com/movementlabsxyz/MIP/tree/gas-fee-calculation/MIP/mip-16) | Pending | @franck44 | Gas fee structure and calculation | | :x: (3 reviews required) | 
| [MIP-18](./MIP/mip-18) | Pending | @0xPrimata | Stage 0 Upgradeability and Multisigs | | :x: (3 reviews required) |
| [MIP-20](https://github.com/movementlabsxyz/MIP/blob/0xmovses/bridge-swap/MIP/mip-20/README.md) | Pending | @0xmovses | Bridge Swap Mechanism | [MD-20](https://github.com/movementlabsxyz/MIP/tree/0xmovses/bridge-swap/MD/md-20) | :x: |
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

## Files and numbering
Each MIP or MD is stored in a separate subdirectory with the a name `md-<number>` or `mip-<number>`. The subdirectory contains a README.md file that describes the MIP or MD. All assets related to the MIP or MD are stored in the same subdirectory.

MDs and MIPs are assigned their PR number as soon as they are drafted. PRs that do not introduce a new MIP are also accepted. Thus, there will be gaps in the MIP number sequence. These gaps will also emerge when MIPs are deprecated or rejected.

