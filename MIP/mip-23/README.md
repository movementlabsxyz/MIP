# MIP-23: Release Conventions for Movement Technologies

- **Description**: Release Conventions for Movement Technologies address the delivery of canonical artifacts to the Movement community.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Desiderata**: [MD-23](../../MD/md-23)

## Abstract

Release Conventions for Movement Technologies standardize the process of delivering artifacts to the Movement community. By providing a coherent and repeatable process for releasing artifacts, these conventions ensure that Movement technologies are accessible and easy to use.

The release conventions proposed herein are based on the usage of GitHub for source control and the tagging of GitHub releases. Guidelines for implementing programmatic access to release artifacts are also described. Finally, the intended relationship between releases and governance is outlined.

## Motivation

Movement technologies are continually evolving, and there's a need to ensure that the process of releasing artifacts is both organized and standardized. By establishing Release Conventions for Movement Technologies, we aim to facilitate the delivery of canonical artifacts to the Movement community. This will ensure that Movement technologies are accessible, easy to use, and well-vetted.

## Specification

The definitions of "artifact" and "release" are accepted from [MD-n](../MD/md-n) and submitted for formal adoption in [MG-n](../MG/mg-n) and [MG-k](../MG/mg-k).

We break the specification into four sections:

1. **Standardized Release Naming Convention**: the section specifying the naming convention to be used for releases.
2. **Standardized Source Control**: the section specifying the process for initiating releases from source control.
3. **Programmatic Access to Release Artifacts**: the section specifying how release artifacts can be fetched programmatically and how software should be designed to this end.
4. **Standard Relationship between Releases and Governance**: the section specifying the relationship between releases and governance as should be assumed the default.

### Standardized Release Naming Convention

We propose the following naming convention for releases, inspired by the [Aptos release standard](https://github.com/aptos-labs/aptos-core/blob/main/RELEASE.md):

```
<software-unit>-v<major>.<minor>.<patch>-<release-type>
```

Where:

- `<software-unit>`: the name of the software unit being released, e.g., the Suzuka Full Node. 
- `<major>`, `<minor>`, `<patch>`: the version numbers of the release conforming to [Semantic Versioning](https://semver.org/).
- `<release-type>`: the type of release, e.g., `stable`, `beta`, or `rc`.

Note that `<release-type>` is ill-defined. Individual software units may define their own release types.

Note further that we do not specify environments such as `devnet`, `testnet`, or `mainnet` in the release name. Though these may be specified in the `<release-type>` field, we recommend that the governance for each software provide indirection from the environment to a given release.

We thus propose the following standard for releases marking the canonical release which should be used in a given environment:

```
<software-unit>-<environment>
```

An example of how this can be released in Git and GitHub is provided in the following section.

### Standardized Source Control

1. Source control MUST be responsible for initiating all releases with the following tags:
    1. A tag corresponding to the Standardized Release Naming Convention above.
    2. A tag corresponding to the commit hash of the release.
    3. A tag corresponding to the environment indirection for the release should it be valid.

2. Releases corresponding to environment indirection MUST only be tagged by making a release from the default branch of the repository.

3. By default, the `<release-type>` SHOULD correspond to the branch from which the release is made.

4. Tag indirection CAN be performed as follows:

```bash
git tag v1.0.0
git push origin v1.0.0
git tag -f latest v1.0.0 
git push origin -f latest 
```

5. GitHub SHOULD be the default source control platform. Within the platform each release should contain at least the archive of the source code which would produce the release artifact.

6. Well-known configuration files MUST also be included in the release archive where they apply.

7. Releases outside of GitHub, e.g., DockerHub, MUST be tagged with the same tags as the GitHub release and linked in the release notes on the GitHub release.

8. Releases to established environments MUST follow governance guidelines for the software unit in question.

9. Releases to established environments MUST trigger an update of all usage of that software unit to the appropriate tag by Movement Labs. This SHOULD be automated to the extent possible to ensure that the source control reflects the canonical release.

### Programmatic Access to Release Artifacts

1. Source control SHOULD be the primary source of release artifacts. 

2. Artifacts which are in consumable forms such as container images, binaries, or libraries can be consumed as the developer sees fit.

3. We recommend the following Rust pseudocode API for fetching artifacts such as well-known configuration files, contract addresses, or other artifacts which may need an application context to be properly consumed:

```rust
trait Release<T> {
    fn fetch_artifact(&self) -> Result<T, Error>;
}

/// Downloads a well-known file from the release in the source control platform.
struct WellKnownFileRelease {
    source: String,
    destination: String
}

/// The downloaded well-known file.
struct WellKnownFileArtifact {
    path: String,
}

impl Release<WellKnownFileArtifact> for WellKnownFileRelease {
    fn fetch_artifact(&self) -> Result<WellKnownFileArtifact, Error> {
       /// ...
    }
}

/// Gets the value of a JSON field from a release file.
struct JSONFieldRelease {
    source: String,
    field: String
}

/// The value of the JSON field.
struct JSONFieldArtifact {
    value: Value
}

/// The JSON field artifact.
impl Release<JSONFieldArtifact> for JSONFieldRelease {
    fn fetch_artifact(&self) -> Result<JSONFieldArtifact, Error> {
       /// ...
    }
}
```

4. Via the API above, particularly when implemented in Rust, the Developer CAN integrate version fetching into their application, e.g., during setup.

### Standard Relationship between Releases and Governance

Releases establish the canonical version of a software unit for a given environment. The governance of the software unit in question is responsible for approving releases to established environments.

1. Releases to established environments MUST be approved by the governance of the software unit in question.

2. Releases MUST trigger the update of all usage of that software unit to the appropriate tag by Movement Labs. This SHOULD be automated to the extent possible to ensure that the source control reflects the canonical release.

## Reference Implementation

## Verification

## Appendix

## Changelog
