<!--
SPDX-FileCopyrightText: 2022 Josef Andersson

SPDX-License-Identifier: CC0-1.0
-->

# ORT CI Base

NOTE: REPO IN TESTING PHASE; GIT HISTORY WILL BE RESET WHEN/IF PROJECT IS   "good enough" for an initial commit and pass the experimental phase, so if you clone it, dont expect to much, and dont use it "for real" yet, things will break

A base project for easier builds of CI integrations using the powerful [ORT (OSS Review Toolkit)](https://github.com/oss-review-toolkit/ort).

## Table of Contents

- [Background](#background)
- [Usage](#usage)
- [Maintainers](#maintainers)
- [Contributing](#contributing)
- [License](#license)

## Background

Why this? I needed a simpel way to simply ORT in CI pipelines using GitHub/GitLab.
There existed an official project for GitLab [ort-gitlab-ci](https://github.com/oss-review-toolkit/ort-gitlab-ci), and a few thirdparty GitHub-actions.
As I started testing, there were a few things that would not work in my workflows, being to tight to the implementation in some places.
But the main logic (the wrapper scripts etc) could be adapted in general CI-implementation, with minor adjustments, so why not.
Instead of taking my shots at start submitting PRs to upstreams and hoping for that they would be accepted soon, I decided to instead make a few PoCs of I how would make it work, and see where I would end up.

After a few after-work evenings hack sessions I had:
* extracted those scripts to this project
* made a few env vars configurable (to allow better CI implementation)
* extracted the main script flow to it's own script (ort-ci-main.sh)
* added tests (bats-core) and made it more testable by dividing into functions etc.
* clearly separated image building and workflow runs

Togheter with this I created the PoC GitHub action/revised GitLab CI project.

The future is unknown. It works for me currently, and it was fun to work on. I think I will add more CI variants time allowing. Should the ORT project want to use anything from these projects, I would gladly see it there instead of under my user.

Note: I think the scrips with would be quite easy to submit as PRs to the upstreams GitLab project really, in small steps if the would want to use the modifed scripts with tests added or/and head this way.

## Usage

The project contains wrapper scripts and templates, and is not intended for direct usage.
Instead, see [ORT CI Action](https://github.com/janderssonse/ort-ci-action) and [ORT CI GitLab](https://github.com/janderssonse/ort-ci-gitlab) for different integrations around it, how to use it.
There you will also find a description of each and every variable in the scripts.

Basically, to create a new implementation you would clone this repo in your CI integration and use the src/ort_ci_main.sh main to run it.


### Development

#### Structure

- /src contains the main scripts.

- /templates is intended to contain a few default templats for convinience, TO-DO

- /docker contains ci-specific additons that is needed by ORT besides the original ORT-Dockerfile.

#### Testing

Install the bats-core with libs (they will end up under ./test/lib/)

```console
./test/install_bats.bash

```

Run the bats-core tests

```console
./test/lib/bats-core/bin/bats test 

```

#### Project linters

The project is using a few hygiene linters:

[MegaLinter](https://megalinter.github.io/latest/) - for shell, markdown etc check.
[Repolinter](https://github.com/todogroup/repolinter) - for overall repostructre.
[commitlint](https://github.com/conventional-changelog/commitlint) - for conventional commit check.
[REUSE Compliance Check](https://github.com/fsfe/reuse-action) - for reuse specification compliance.

Before commiting a PR, please have run with this linters to avoid red checks. If forking on GitHub, you can adjust them to work for fork in the .github/workflow-files.

## Maintainers

[Josef Andersson](https://github.com/janderssonse).

## Contributing

ORT CI Base follows the [Contributor Covenant](http://contributor-covenant.org/version/1/3/0/) Code of Conduct.
Please also see the [Contributor Guide](docs/CONTRIBUTING.adoc)


## License

Scripts under /src and docker/Dockerfile.ci are

Copyright (C) 2020-2022 HERE Europe B.V.
(but with additions/refactoring)
Copyright (C) 2022 Josef Andersson)

The main project is under

[MIT](LICENSE)

See .reuse/dep5 and file headers for further information.
Most "scrap" files, textfiles etc are under CC0-1.0, essentially Public Domain.

## Credits

Thanks to the [ORT (OSS Review Toolkit) Project](https://github.com/oss-review-toolkit/ort), for developing such a powerful tool. It fills a void in SCA-toolspace.

## F.A.Q

* TO-DO


