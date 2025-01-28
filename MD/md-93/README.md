# MD-93: Parent-Child MIPs
- **Description**: Provide formal structure for parent and child MIPs.
- **Authors**: [Andy Golay](mailto:andy.golay@movementlabs.xyz)

## Overview

Provide formal structure for parent-child MIPs. For more complicated MIPs, or MIPs which have implementations specific to various software stacks, infrastructure providers, etc., it can makes sense for the sake of organization to have child MIPs to add specific details, rather than making the parent MIP too verbose or cluttered.

## Definitions

- **Parent MIP**: The main MIP for to a specific improvement proposal. 

- **Child MIP**: Also MAY be referred to as a sub-MIP. Child MIPs give detail on specific domains referenced within a parent MIP. They are substantial enough that they make sense to refactor into MIPs associated with the parent MIP.

## Desiderata

### D1: Convention for parent and child MIP file organization and naming

**User Journey**: Proposer/Researcher can adhere to a standardized template for substantial, detailed subsections of MIPs which warrant being categorized as their own related child MIP.

**Justification**: The file organization and naming must be consistent, so there should be a formal convention. 
