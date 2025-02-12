# MIP-94: Parent-Child MIPs

- **Description**: Add concept of child MIPs to extend MIPs that contain substantial amount of content.
- **Authors**: [Andy Golay](mailto:andy.golay@movementlabs.xyz)
- **Desiderata**: [MD-93](https://github.com/movementlabsxyz/MIP/pull/93)
- **Approval**: :white_check_mark:

## Abstract

This document formalizes parent-child MIPs.

## Motivation

For more complex MIPs, or MIPs which have implementations specific to various software stacks, infrastructure providers, etc., it can makes sense for the sake of organization to have child MIPs to add specific details, rather than making the parent MIP too verbose or cluttered.

## Specification

To create a child MIP:

1. Create a folder within the directory of an MIP. That MIP will be the "parent MIP" for the child MIP.

2. Name the folder `mip-n.k` where `n` is the MIP's number as defined in . `k` represents the index of the child MIP.
    **Example:** If the child MIP is the 1st child MIP of MIP 5, the child MIP will be `mip-5.1`

3. Add a `README.md` fill containing the child MIP contents. Follow the [MIP template](../../mip-template.md) but don't repeat redundant information from the parent MIP.

## Reference Implementation

This MIP contains a reference implementation of parent-child MIPs:

![parent-child MIP reference](image.png)

- The parent MIP is MIP 94.
- Within the `mip-94` directory are two folders: `mip-94.1` and `mip-94.2`, each with their own `README.md` file.

## Verification

## Changelog

## Appendix

## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).
