# MIP-15: Conventions for Proposing Progressive L2 Models
- **Description**: Introduces conventions for proposing progressive L2 models.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Reviewer**: Andreas Penzkofer
- **Desiderata**: $\emptyset$

## Abstract

We define a progressive L2 model as a description of an L2 system that is intended for a particular stage of the said L2's life. To align expectations for reviewing proposals for said models, we propose a set of conventions including naming, formatting, and related standards.

## Motivation

In order to facilitate the development of L2 systems, it is important to have a clear and consistent way to propose and review models for these systems. This MIP aims to provide a set of conventions for proposing progressive L2 models that will help to ensure that proposals are clear, consistent, and easy to review.

## Specification
Progress L2 models should adhere to conventions of the following forms:

- **naming**: apply a standard naming format.
- **acknowledgement of standards**: acknowledge the conventions of this MIP.
- **summary table**: a table succinctly noting key features of the model.
- **statement towards progression**: a statement of how the model suits a progressive approach to L2 design and release.
- **pros and cons**: a list of pros and cons.

### Naming
All proposed progressive L2 models MUST adopt a name of the form "The [Location] Model" where [Location] is a location where the proposal was drafted or a similarly symbolic location. This name should be the title of the associated MIP. 

In text, the model SHOULD be referred to as "the [Location] Model," that is, the name of the model in lowercase with "the" prepended. 

### Acknowledgement of Standards
At the start of the "Specification" section of the MIP, the author MUST include the following markdown snippet:

```
We acknowledge and apply the conventions of [MIP-N: Conventions for Proposing Progressive L2 Models](link/to/this/mip).
```

### Summary Table
All proposed progressive L2 models MUST complete the following table:

| Category | Criterion | Evaluation |
|-----------|-----------|------------|
| **General** | | |
|X| When to use | A brief general description of the circumstances under which the model is appropriate. |
|X| Suitable preceding models | A list of models or descriptions of models that are suitable precursors to this model. |
|X| Suitable succeeding models | A list of models or descriptions of models that are suitable successors to this model. |
|X| Technological motivations | A brief description of the technological motivations for using the model. |
|X| Usership motivations | A brief description of the user motivations for using the model. |
| **Components** | | |
|X| [Component Name 1](link/to/component/design) | A description of usage of said component.  |
|X| [Component Name 2](link/to/component/design) | A description of usage of said component.  |

### Statement Towards Progression
All proposed progressive L2 models MUST include a statement of how the model suits a progressive approach to L2 design and release. This statement SHOULD be a paragraph in length and immediately follow the summary table--as if it were a caption for the table.

### Pros and Cons
All proposed progressive L2 models MUST include a list of pros and cons. This list SHOULD be formatted as two separate bulleted lists in subsections titled "Pros" and "Cons."

## Verification



## Errata


## Appendix
