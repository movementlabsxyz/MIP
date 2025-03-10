# MIP-53: Conventions for proposing Progressive L2 Models

- **Description**: Introduces conventions for proposing progressive L2 models.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Reviewer**: Andreas Penzkofer
- **Approval**: :white_check_mark:

## Abstract

Movement's L2 (Level 2) system will progress through various changes during its life, and each stage is presented through a new L2 model (which we call **progressive L2 model**). Thus a given progressive L2 model describes as a particular stage in the evolution of the L2 system.  A given progressive L2 model stage is defined through the sum of its improvements and it may encompass components that are not directly related to each other.

We propose a set of conventions including naming, formatting, and related standards to assist reviewing proposals for said models. Finally a collection point of these terms to provide an overview

## Motivation

In order to facilitate the development of L2 systems, it is important to have a clear and consistent way to propose and review models for these systems. This MIP aims to provide a set of conventions for proposing progressive L2 models that will help to ensure that proposals are clear, consistent, and easy to review.

## Specification

_The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174._

Progressive L2 models should adhere to conventions of the following forms:

- **Naming**: apply a standard naming format. To be introduced in the MIP title.
- **Acknowledgement of standards**: acknowledge the conventions of this MIP.
- **Summary table**: a table succinctly noting key features of the model.
- **Statement towards progression**: a statement of how the model suits a progressive approach to L2 design and release.
- **Pros and cons**: a list of pros and cons.

### Naming

All proposed progressive L2 models MUST adopt a name of the form "The [Location] Model" where [Location] is a location where the proposal was drafted or a similarly symbolic location. This name should be the title of the associated MIP.

In text, the model SHOULD be referred to as "[Location] Model," that is, the name of the model in title case.

### Acknowledgement of standards

At the start of the "Specification" section of the MIP, the author MUST include the following markdown snippet:

_The conventions of [MIP-53: Conventions for Proposing Progressive L2 Models](../mip-53) are applied._

### Summary table

All proposed progressive L2 models MUST complete the following table:

| Category / Criterion | Evaluation |
|-----------|------------|
| **General** | |
| _When to use_ | A brief general description of the circumstances under which the model is appropriate. |
| _Suitable preceding models_ | A list of models or descriptions of models that are suitable precursors to this model. |
| _Suitable succeeding models_ | A list of models or descriptions of models that are suitable successors to this model. |
| _Technological motivations_ | A brief description of the technological motivations for using the model. |
| _Usership motivations_ | A brief description of the user motivations for using the model. |
| **Components** | |
| _[Component Name 1](link/to/component/design)_ | A description of usage of said component.  |
| _[Component Name 2](link/to/component/design)_ | A description of usage of said component.  |

### Statement towards progression

All proposed progressive L2 models MUST include a statement of how the model suits a progressive approach to L2 design and release. This statement SHOULD be a paragraph in length and immediately follow the summary table--as if it were a caption for the table.

### Pros and cons

All proposed progressive L2 models MUST include a list of pros and cons. This list SHOULD be formatted as two separate bulleted lists in subsections titled "Pros" and "Cons."

## Verification

## Appendix

## Changelog
