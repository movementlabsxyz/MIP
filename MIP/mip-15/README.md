# MIP-15: MG (Movement Gloss)

- **Description**: Terms should be well defined. This is achieved through the [Glossary](../GLOSSARY.md) and the Movement Gloss (MG) process.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Reviewer**: Andreas Penzkofer
- **Desiderata**: [MD-15](../MD/md-15/README.md)

## Abstract

This MIP defines the [Glossary](../GLOSSARY.md), which contains an overview of relevant terms used in this repo. This glossary defines terms that are frequently used.

Furthermore, this MIP introduces the Movement Gloss (MG) document type and establishes a process for introducing new glossary terms. The MG document type will be used to define terms unique to Movement Labs and to provide specific definitions for terms that are used in a unique way, underspecified in the literature, or have a specific meaning in the context of Movement Labs.

## Motivation

In order to communicate with more specificity in all contexts, Movement Labs should introduce a glossary. We require alignment of terms across this repository and beyond.

Furthermore, terms may be underspecified in literature, are used in a unique way, or have a specific meaning in the context of Movement Labs. These terms may require additional extensive definition. This necessitates the introduction of the Movement Gloss (MG) document type.

## Specification

> _The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174._

### Glossary

The [Glossary](../../GLOSSARY.md) is an alphabetically ordered list of terms that should be defined and may be frequently referenced. The glossary should be a living document that is updated as new terms are introduced or as terms are redefined.

The Glossary file contains:

- The Term
- A short definition
- (Optional) The number of the MG/MIP/MD that introduces the term.

The format is as follows:

```markdown
**<Term>**
<Definition> → [MD-x](MD/md-x/README.md), [MG-y](MG/mg-y/README.md)
```

### MG (Movement Gloss)

An MG is a definition of a term that requires detailed explanation. Any term introduced through an MG MUST be declared in the Glossary.

A template for the MG is provided at [mg-template](../../md-template.md). The template covers the requested elements listed in [MD-15.D1](../MD/md-15/README.md).

An example MG is provided at [mg-0](../../MG/mg-0/README.md).

An MG document MUST not be accepted unless it is required by an MIP or MD. For example, herein, we justify the introduction of [MG-0](../../MG/mg-0/README.md). MG-0 defines the term "gloss" which is used in the context of Movement Labs to denote the definition of a term as would feature as an entry in a glossary. For the MGs, it is important to include in the glossary both clarify as the acronym "MG" and to provide an example gloss.

#### MG Structure

**Term**
Definition of the term.

**Related Work**
Enumerate key usages of the term or related terms in other contexts.

**Example Usages**
Provide examples of the term's usage in context.

**Changelog**
Document any post-publication changes to the glossary entry.

## Reference Implementation

See the [Glossary](../../GLOSSARY.md).

See the MG document type template at [mg-template](../../md-template.md) and the example MG at [mg-0](../../MG/mg-0/README.md).

## Verification

## Errata

## Appendix
