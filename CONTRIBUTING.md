# Contributing

Contributions are extremely welcome, but please consider the following:

- Respect other people, and recognise that they might be at a different level than you.
- Raise issues for enhancement requests or bugs.
- Raise PRs for bug fixes or new feature development.
- Write unit tests wherever feasible.
- Keep things simple, and don't be offended if enhancement requests are denied in favour of keeping the tool focused.

## Branching

**Never commit directly to the master branch.**
Follow standard [Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) branching:

- **master** - This should always exactly mirror what's currently in production. Never commit directly to `master`.
- **develop** - Features and bug fixes should be merged into develop, for release in stages.
- **feature/\<feature-name\>** - Used for developing features before submitting for code review. Choose a short, meaningful description of the change being made, such as `feature/swift-5-compatibility`.
- **fix/\<issue-name\>** - Used for bug fixes before submitting for code review. e.g `fix/broken-layout`.
- **chore/\<chore-name\>** - Used for general code changes not suitable for a feature or fix branch, such as updating automated build settings. e.g `chore/tidy-file`.
- **hotfix/\<hotfix-name\>** - Used for developing **urgent** fixes, created from `master` rather than `develop`. Follows the same branch naming conventions.

## Pull Requests

Before merging any changes into `master`, a pull request should be created and assigned for review by all other active contributors. Ensure the project runs and all unit tests are passing before merging any branches. New changes are expected to be unit tested wherever feasible.

Assign one or more people to the pull request, and once everyone has approved, the changes may be merged into the target branch. Simple pull request can be merged when one other person approved it.Common sense applies.

After merging a PR, delete the source branch.

## Releases

Each release should be tagged using [semantic versioning](http://semver.org/), for example `3.0.1`. Before releasing ensure:

- CHANGELOG is updated to reflect the changes from the previous version.
- README is updated where needed.
- The `.podspec` is updated to use the latest version.
- The example app has had `pod install` ran on it.
