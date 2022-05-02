<!--
SPDX-FileCopyrightText: 2022 Josef Andersson

SPDX-License-Identifier: CC0-1.0
-->

# ORT CI Base

NOTE: REPO IN TESTING/POC PHASE; GIT HISTORY WILL BE RESET WHEN/IF PROJECT IS   "good enough" for an initial commit and pass the experimental phase, so if you clone it, dont expect anything, and dont use it "for real" yet, things will break, both in feature and logic. This project is unofficial, and not under the ORT umbrella.

A base project for easier builds of CI integrations using the powerful [ORT (OSS Review Toolkit)](https://github.com/oss-review-toolkit/ort).

Related siblings projects are:

- [ORT CI ACTION](https://github.com/janderssonse/ort-ci-action) - A GitHub Action for running ORT in CI
- [ORT CI GitLab](https://github.com/janderssonse/ort-ci-gitlab) - A GitLab CI template for running ORT in CI
- [ORT CI Tekton]--TO-DO

## Table of Contents

- [Background](#background)
- [Usage](#usage)
- [Contributing](#contributing)
- [Maintainers](#maintainers)
- [License](#license)

## Background

Why this? I needed a simple way to run ORT in CI pipelines using GitHub/GitLab.
There already existed an official project for GitLab [ort-gitlab-ci](https://github.com/oss-review-toolkit/ort-gitlab-ci), and a few thirdparty GitHub-actions.
As I started testing that, there were a few things that would not work in my usecase, being to tight to the implementation in some places.
But the main logic (the wrapper scripts etc) could easily be adapted in to a general implementation, with minor adjustments, so why not extract that a bit.
Instead of taking my shots at start submitting PRs to upstreams and hoping for that (the ORT project) would accepted my ideas,  I decided to instead make a few PoCs first.

After a few after-work evenings hack sessions I had:
* extracted those scripts to this project
* made a few env vars configurable (to allow better CI implementation)
* extracted the main script flow to it's own script (ort-ci-main.sh)
* added tests (bats-core) and made it more testable by dividing into functions etc.
* clearly separated image building and workflow runs

And with this Base I could PoC GitHub action/revised GitLab CI project mentioned earlier.

It works for my use cases currently, I will clean it up, test and document it further. I think I will add more CI variants time allowing. After speaking with the ORT project, they were interested in parts or whole possibly ending up under their umbrella, which would be supernice!

Note: I think the scripts with would be quite easy to submit as PRs to the upstreams GitLab project really, in small steps if the would want to use the modified scripts with tests added or/and head this way. I made efforts to not stray away from them, reusing same variables, mostly same logic, just making things more configurable.

## Usage

The project contains wrapper scripts and templates, and is not intended for a direct usage.
Instead, see [ORT CI Action](https://github.com/janderssonse/ort-ci-action) and [ORT CI GitLab](https://github.com/janderssonse/ort-ci-gitlab) for different integrations around it, how to use it.

Please also see the [Description of input variables](docs/variables.adoc)

### Development

Basically, to create a new implementation you would clone this repo in your CI integration and use the src/ort_ci_main.sh main to run it, sending in environment variables.

#### Structure

- /src contains the main scripts.

- /templates is intended to contain a few default templates for convenience, TO-DO a bit more work around this
- /docker contains CI-specific additions needed by ORT CI besides the original ORT Project Dockerfile.

#### Unit tests

Install the Bash test framework [bats-core](https://github.com/bats-core/bats-core) with libs (they will end up under ./test/lib/)

```console
./test/install_bats.bash

```

Run the bats-core tests

```console
./test/lib/bats-core/bin/bats test 

```

#### Project linters

The project is using a few hygiene linters:

- [MegaLinter](https://megalinter.github.io/latest/) - for shell, markdown etc. check.
- [Repolinter](https://github.com/todogroup/repolinter) - for overall repo structure.
- [commitlint](https://github.com/conventional-changelog/commitlint) - for conventional commit check.
- [REUSE Compliance Check](https://github.com/fsfe/reuse-action) - for reuse specification compliance.

Before committing a PR, please have run with this linters to avoid red checks. If forking, they are already set up for your and will check your fork too (as GitHub actions). But, you can always adjust/disable them to work for fork in the .github/workflow-files during dev.

## Contributing

ORT CI Base follows the [Contributor Covenant](http://contributor-covenant.org/version/1/3/0/) Code of Conduct.  
Please also see the [Contributor Guide](docs/CONTRIBUTING.adoc)

## Maintainers

[Josef Andersson](https://github.com/janderssonse).

## License

Scripts under /src and /docker/Dockerfile.ci are

Copyright (C) 2020-2022 HERE Europe B.V.
(but with minor additions/refactoring)
Copyright (C) 2022 Josef Andersson)

The main project is otherwise under

[MIT](LICENSE)

See .reuse/dep5 and file headers for further information, most "scrap" files, configuration files etc. are under CC0-1.0, essentially Public Domain.

## Credits

Thanks to the [ORT (OSS Review Toolkit) Project](https://github.com/oss-review-toolkit/ort), for developing such a powerful tool. It fills a void in the SCA toolspace.

## F.A.Q

* TO-DO


