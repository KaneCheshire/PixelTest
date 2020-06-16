# Contributing

Contributions are extremely welcome, but please consider the following:

- Respect other people, and recognise that they might be at a different level than you.
- Generally it's best to raise an issue before writing code and raising a PR, unless it's a small change. This avoids wasted time and allows for some discussion.
- Write unit tests wherever feasible.
- Keep things simple, and don't be offended if enhancement requests are denied in favour of keeping the tool focused.

## Branching

**Never commit directly to the main branch.**

- **main** - This is the main branch for development. All fixes and changes should happen on a branch created from `main`, and merged back into `main`. There is no specific `develop` branch. If you need to hotfix an existing release, check out the release tag and create a release branch from that.

## Pull Requests

Before merging any changes into `main`, a pull request should be created and assigned for review by all other active contributors. Ensure the project runs and all unit tests are passing before merging any branches. New changes are expected to be unit tested wherever feasible.

Assign one or more people to the pull request, and once everyone has approved, the changes may be merged into the target branch.

After merging a PR, delete the source branch.

## Releases

Each release must be tagged using [semantic versioning](http://semver.org/), for example `3.0.1`. Before releasing ensure:

- CHANGELOG is updated to reflect the changes from the previous version.
- README is updated where needed.
- The `Package.swift` file is up-to-date.
- The `.podspec` is updated to use the latest version.
- The example app has had `pod install` run on it.

Since there's only a `main` branch, releases are snapshotted by tags. This means that there is likely to be code in `main` that is unreleased. If changes need to happen to an existing release, check out the code for the tag of the release.
