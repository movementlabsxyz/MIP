# MIP-15: MG (Movement Gloss)
- **Description**: Introduces the Movement Gloss (MG) document type and establishes a process for introducing new glossary terms. Introduces the [Glossary](../GLOSSARY.md), which contains an overview of all terms defined through MGs.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Reviewer**: Andreas Penzkofer
- **Desiderata**: [MD-15](../MD/md-15/README.md)

## Abstract

This MIP introduces the Movement Gloss (MG) document type and establishes a process for introducing new glossary terms. The MG document type will be used to define terms unique to Movement Labs and to provide specific definitions for terms that are used in a unique way, underspecified in the literature, or have a specific meaning in the context of Movement Labs.

## Motivation

In order to communicate with more specificity in all contexts, Movement Labs should introduce a glossary. This glossary should define terms both unique to Movement Labs and general terms that are used in a unique way, underspecified in the literature, or have a specific meaning in the context of Movement Labs.

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

### Glossary

The [Glossary](../GLOSSARY.md) is an alphabetically ordered list of terms defined through MGs. Any term introduced through an MG MUST be declared in the Glossary. 

The Glossary table contains the following columns:
- The Term
- A short definition
- The number of the MG that introduces the term

### MG Document Type
A template for the MG is provided at [mg-template](../../md-template.md). An example MG is provided at [mg-0](../../MG/mg-0/README.md). These templates cover the requested elements listed in [MD-15.D1](../MD/md-15/README.md).

### MG Process
1. A new glossary term MUST be defined in an MG document matching the provided templates.
2. An MG document MUST not be accepted unless justified in an MIP.

For example, herein, we justify the introduction of [MG-0](../../MG/mg-0/README.md). MG-0 defines the term "gloss" which is used in the context of Movement Labs to denote the definition of a term as would feature as an entry in a glossary. It is important to include in the glossary both clarify as the acronym "MG" and to provide an example gloss. 

## Reference Implementation
See the MG document type template at [mg-template](../../md-template.md) and the example MG at [mg-0](../../MG/mg-0/README.md).


## Verification



## Errata


## Appendix
