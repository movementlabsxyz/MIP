# MD-23: Define Artifact Releases for Movement Technologies

- **Description**: Define a process for releasing artifacts for Movement technologies.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)

## Overview

Provide a coherent and repeatable process for releasing artifacts for Movement technologies. This should be used for specifying the process of releasing artifacts for Movement technologies--particularly those that may require third-parties to adjust their usage of said technologies.

## Definitions

**artifact**: a deployable unit of software that is the result of a build process. This could be a library, a binary, a container image, or a well-known configuration file.

**release**: a versioned artifact that is made available to the public. This could be a stable release, a beta release, or a release candidate.

## Desiderata

### D1: Apply standardized release naming convention

**User Journey**: All users can easily identify the type of release, software units, and versioning of Movement technologies.

**Justification**: A standardized naming convention for releases will help developers understand the purpose of a release and the changes it contains. This will help developers make informed decisions about which releases to use.

### D2: Ensure release artifacts can be fetched programmatically and used to run applications

**User Journey**: Operators can programmatically fetch release artifacts and use them to run applications.

**Justification**: Operators should be able to automate the process of fetching and deploying release artifacts. This will help ensure that applications are always running the latest version of Movement technologies.

### D3: Initiate all releases from source control

**User Journey**: Developers can initiate the release process from source control.

**Justification**: Releasing from source control ensures that the release process is repeatable and that all changes are tracked. This will help developers understand the history of a release and troubleshoot any issues that arise.

### D4: Define standard relationship between releases and governance

**User Journey**: All users can understand the relationship between releases and governance, i.e., how a particular release gets voted in as canonical for a given set of Movement technologies.

**Justification**: A clear relationship between releases and governance will help users understand how releases are approved and what criteria they must meet. This will help users trust that releases are of high quality and meet the needs of the community.

## Changelog
