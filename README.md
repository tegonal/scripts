<!-- for main -->

[![Download](https://img.shields.io/badge/Download-v3.2.0-%23007ec6)](https://github.com/tegonal/scripts/releases/tag/v3.2.0)
[![Apache 2.0](https://img.shields.io/badge/%E2%9A%96-Apache%202.0-%230b45a6)](http://opensource.org/licenses/Apache2.0 "License")
[![Quality Assurance](https://github.com/tegonal/scripts/actions/workflows/quality-assurance.yml/badge.svg?event=push&branch=main)](https://github.com/tegonal/scripts/actions/workflows/quality-assurance.yml?query=branch%3Amain)
[![Newcomers Welcome](https://img.shields.io/badge/%F0%9F%91%8B-Newcomers%20Welcome-blueviolet)](https://github.com/tegonal/scripts/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22 "Ask in discussions for help")

<!-- for main end -->
<!-- for release -->
<!--
[![Download](https://img.shields.io/badge/Download-v3.2.0-%23007ec6)](https://github.com/tegonal/scripts/releases/tag/v3.2.0)
[![Apache 2.0](https://img.shields.io/badge/%E2%9A%96-Apache%202.0-%230b45a6)](http://opensource.org/licenses/Apache2.0 "License")
[![Newcomers Welcome](https://img.shields.io/badge/%F0%9F%91%8B-Newcomers%20Welcome-blueviolet)](https://github.com/tegonal/scripts/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22 "Ask in discussions for help")
-->
<!-- for release end -->

# Scripts of Tegonal

There are scripts which we use over and over again in different projects.
As they might be usable for you as well, we are publishing them here.
Feel free to use it and report bugs if you should find one.

---
❗ You are taking a *sneak peek* at the next version. It could be that some features you find on this page are not
released yet.  
Please have a look at the README of the corresponding release/git tag. Latest
version: [README of v3.2.0](https://github.com/tegonal/scripts/tree/v3.2.0/README.md).

---

**Table of Content**

- [Installation](#Installation)
- [Documentation](#documentation)
- [Contributors and contribute](#contributors-and-contribute)
- [License](#license)

# Installation

We recommend you pull the scripts with the help of [gt](https://github.com/tegonal/gt).  
Alternatively you can
[![Download](https://img.shields.io/badge/Download-v3.2.0-%23007ec6)](https://github.com/tegonal/scripts/releases/tag/v3.2.0)
the sources.

Following the commands you need to execute to set up tegonal scripts via [gt](https://github.com/tegonal/gt).

```bash
gt remote add -r tegonal-scripts -u https://github.com/tegonal/scripts
````

Now you can pull the scripts you want via:

```bash
export TEGONAL_SCRIPTS_VERSION="v3.2.0"
gt pull -r tegonal-scripts -t "$TEGONAL_SCRIPTS_VERSION" -p ...
```

Note that dependencies have to be pulled manually and almost all scripts depend on `src/setup.sh`
which in turn depends on `src/utility/source-once.sh` and this one depends on `src/utility/log.sh`.
Many of the scripts depend on further scripts located in `src/utility`.
Therefore, for simplicity reasons, we recommend you pull `src/setup.sh` and all files in `src/utility` in addition:

```
export TEGONAL_SCRIPTS_VERSION="v3.2.0" 
gt pull -r tegonal-scripts -t "$TEGONAL_SCRIPTS_VERSION" -p src/setup.sh
gt pull -r tegonal-scripts -t "$TEGONAL_SCRIPTS_VERSION" -p src/utility/
```

## Sourcing functions

We recommend you use the following code at the beginning of your script in case you want to `source` a file/function
(in the example below we want to use tegonal's io functions located in `utility/io.sh`):

<setup>

<!-- auto-generated, do not modify here but in src/setup.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit

if ! [[ -v dir_of_tegonal_scripts ]]; then
	# Assumes your script is in (root is project folder) e.g. /src or /scripts and
	# the tegonal scripts have been pulled via gt and put into /lib/tegonal-scripts
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi

sourceOnce "$dir_of_tegonal_scripts/utility/io.sh"
```

</setup>

Note that `source "$dir_of_tegonal_scripts/setup.sh"` will automatically source `utility/source-once.sh`
and `utility/log.sh`

# Documentation

The scripts are ordered by topic:

- [CI](#continuous-integration)
	- [install shellcheck](#install-shellcheck)
	- [install shellspec](#install-shellspec)
	- [Jelastic](#jelastic)
		- [deploy](#deploy-to-jelastic)
		- [utils](#jelastic-utils)
- [Quality Assurance](#quality-assurance)
	- [runShellcheck](#runshellcheck)
    - [runShellcheckPullHooks](#runshellcheck-on-pull-hookssh)
- [Releasing](#releasing)
	- [Releasing Files](#release-files)
	- [Prepare Files Next Dev Cycle](#prepare-files-next-dev-cycle)
	- [Release Template](#release-template)
    - [Prepare Next Dev Cycle Template](#prepare-next-dev-cycle-template)
	- [git Pre-Release checks](#git-pre-release-checks)
    - [sbt sonatype publish](#sbt-publish-to-sonatype)
	- [Update Version common steps](#update-version-common-steps)
	- [Update Version in README](#update-version-in-readme)
	- [Update Version in bash scripts](#update-version-in-bash-scripts)
	- [Update Version in issue templates](#update-version-in-issue-templates)
	- [Toggle main/release sections](#toggle-mainrelease-sections)
	- [Hide/Show sneak-peek banner](#hideshow-sneak-peek-banner)
	- [Create tag, prepare-next, push](#create-tag-prepare-next-dev-cycle-and-push-tag-and-changes)

- [Script Utilities](#script-utilities)
	- [array utils](#array-utils)
	- [Ask functions](#ask-functions)
    - [cleanups](#cleanups)
	- [Checks](#checks)
	- [git Utils](#git-utils)
	- [GPG Utils](#gpg-utils)
	- [Http functions](#http-functions)
	- [IO functions](#io-functions)
	- [Log functions](#log-functions)
	- [Parse arguments](#parse-arguments)
	- [Parse utils](#parse-utils)
	- [Recursive `declare -p`](#recursive-declare--p)
	- [Replace Snippets](#replace-snippets)
	- [`source` once](#source-once)
	- [Update Documentation](#update-bash-documentation)

# Continuous Integration

The scripts under this topic (in directory `ci`) help out in performing CI steps.

## Install shellcheck

Installs shellcheck v0.8.0.  
Most likely used together with [runShellcheck](#runshellcheck).
Following an example:

<ci-install-shellcheck>

<!-- auto-generated, do not modify here but in src/ci/install-shellcheck.sh.doc -->
```bash
# run the install-shellcheck.sh in your github/gitlab workflow
# for instance, assuming you fetched this file via gt and remote name is tegonal-scripts
# then in a github workflow you would have

jobs:
  steps:
    - name: install shellcheck v0.10.0
      run: ./lib/tegonal-scripts/src/ci/install-shellcheck.sh
    # and most likely as well
    - name: run shellcheck
      run: ./scripts/run-shellcheck.sh
```

</ci-install-shellcheck>

## Install shellspec

<ci-install-shellspec>

<!-- auto-generated, do not modify here but in src/ci/install-shellspec.sh.doc -->
```bash
# run the install-shellcheck.sh in your github/gitlab workflow
# for instance, assuming you fetched this file via gt and remote name is tegonal-scripts
# then in a github workflow you would have

jobs:
  steps:
    - name: install shellspec
      run: ./lib/tegonal-scripts/src/ci/install-shellspec.sh
    # and most likely as well
    - name: run shellspec
      run: shellspec
```

</ci-install-shellspec>

## Jelastic

The scripts under this topic (in directory `ci/jelastic`) help out when dealing with jelastic cli

### Deploy to jelastic

Helper function which performs a signin and redeploycontainers

<ci-jelastic-deploy>

<!-- auto-generated, do not modify here but in src/ci/jelastic/deploy.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

# typically you would define those via secrets (GitHub) or Variables (Gitlab)
JELASTIC_LOGIN='my-user'
JELASTIC_PASSWORD='access-token'
JELASTIC_PLATFORM_URL='https://...'

# the label of the docker image as pushed to the docker registry configured for the environment test
DOCKER_IMAGE_VERSION=bebea131

# executes signin and redeploycontainers via jelastic_cli
"$dir_of_tegonal_scripts/ci/jelastic/deploy.sh" -l "$JELASTIC_LOGIN" -p "$JELASTIC_PASSWORD" -u "$JELASTIC_PLATFORM_URL" -e "test" -n cp -t "$DOCKER_IMAGE_VERSION"

# you can also source
sourceOnce "$dir_of_tegonal_scripts/ci/jelastic/deploy.sh"
jelastic_deploy -l "$JELASTIC_LOGIN" -p "$JELASTIC_PASSWORD" -u "$JELASTIC_PLATFORM_URL" -e "test" -n cp -t "$DOCKER_IMAGE_VERSION"
```

</ci-jelastic-deploy>

In a GitHub workflow you would use it as follows:

```yaml
jobs:
	steps:
		-   name: deploy shellcheck v0.8.0
			run: |
				./lib/tegonal-scripts/src/ci/jelastic/deploy.sh \
				  -l "$JELASTIC_LOGIN" -p "$JELASTIC_PASSWORD" -u "$JELASTIC_PLATFORM_URL" \
				  -e "test" -n cp \
				  -t "$DOCKER_IMAGE_VERSION"
```

Help:

<ci-jelastic-deploy-help>

<!-- auto-generated, do not modify here but in src/ci/jelastic/deploy.sh -->
```text
Parameters:
-l|--login       The user who logs in
-p|--password    The access token of the user
-u|--url         The platformUrl to the jelastic instance
-e|--env         The environment to use
-n|--nodeGroup   The nodeGroup to use
-t|--tag         The tag which shall be deployed

--help     prints this help
--version  prints the version of this script

INFO: Version of deploy.sh is:
v3.3.0-SNAPSHOT
```

</ci-jelastic-deploy-help>

### Jelastic utils

The most important functions are defined in this file: jelastic_signin which in turn uses the generic jelastic_exec

<ci-jelastic-utils>

<!-- auto-generated, do not modify here but in src/ci/jelastic/utils.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/ci/jelastic/jelastic-utils.sh"

# typically you would define those via secrets (GitHub) or Variables (Gitlab)
JELASTIC_LOGIN='my-user'
JELASTIC_PASSWORD='access-token'
JELASTIC_PLATFORM_URL='https://...'

# before doing anything with jelastic cli, you need to signin
# this is just a helper function you could also use jelastic_exec and pass users/authentication/signin as command
jelastic_signin "$JELASTIC_PLATFORM_URL" "$JELASTIC_LOGIN" "$JELASTIC_PASSWORD"

# generic utility which executes the jelastic_cli with the corresponding command and args but,
# in contrast to the cli, it checks whether the response contained `result: 0` or not
jelastic_exec "environment/control/redeploycontainers" --envName "test" --nodeGroup "cp" --tag "a123e2"
```

</ci-jelastic-utils>

# Quality Assurance

The scripts under this topic (in directory `qa`) perform checks or execute qa tools.

## runShellcheck

A function which expects the name of an array of dirs as first argument and a source path as second argument (which is
passed to shellcheck via -P parameter). It then executes shellcheck for each *.sh in these directories with predefined
settings for shellcheck.

<qa-run-shellcheck>

<!-- auto-generated, do not modify here but in src/qa/run-shellcheck.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/qa/run-shellcheck.sh"

# shellcheck disable=SC2034   # is passed by name to runShellcheck
declare -a dirs=(
	"$dir_of_tegonal_scripts"
	"$dir_of_tegonal_scripts/../scripts"
	"$dir_of_tegonal_scripts/../spec"
)
declare sourcePath="$dir_of_tegonal_scripts"
runShellcheck dirs "$sourcePath"
```

</qa-run-shellcheck>

## runShellCheck on pull-hooks.sh

If you are using [gt](https://github.com/tegonal/gt) then you most likely want to be sure that your pull-hook.sh files 
don't contain shell issues, you can use the function `runShellCheckPullHooks` which analyses all pull-hook.sh files
in the remotes dir of gt using the $dir_of_tegonal_scripts as source path.

<qa-run-shellcheck-pull-hooks>

<!-- auto-generated, do not modify here but in src/qa/run-shellcheck-pull-hooks.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/qa/run-shellcheck-pull-hooks.sh"

# pass the working directory of gt which usually is .gt in the root of your repository
runShellcheckPullHooks ".gt"
```

</qa-run-shellcheck-pull-hooks>


# Releasing

The scripts under this topic (in directory `releasing`) perform some steps of your release process.

## Release Files

Script which releases a version for a repository containing files which don't need to be compiled or packaged.
Instead, they will be signed by a specified gpg key where its public key, defined in .gt/signing-key.public.asc,
will be used to verify the signatures.

This script is useful if you want to release e.g. scripts which can then be fetched
via [gt](https://github.com/tegonal/gt).

It uses [release-template](#release-template) internally and thus applies the same conventions + the mentioned public
key
which needs to be defined in .gt/signing-key.public.asc

It executes the same steps as in release-template where scripts located in projectRootDir/src are also updated
regarding the version and as explained, in the releaseHook, it signs the files the given --sign-fn finds.

Help:

<releasing-release-files-help>

<!-- auto-generated, do not modify here but in src/releasing/release-files.sh -->
```text
Parameters:
-v                            The version to release in the format vX.Y.Z(-RC...)
-k|key                        The GPG private key which shall be used to sign the files
--sign-fn                     Function which is called to determine what files should be signed. It should be based find and allow to pass further arguments (we will i.a. pass -print0)
-b|--branch                   (optional) The expected branch which is currently checked out -- default: main
--project-dir                 (optional) The projects directory -- default: .
-p|--pattern                  (optional) pattern which is used in a perl command (separator /) to search & replace additional occurrences. It should define two match groups and the replace operation looks as follows: \${1}$version\${2}
-nv|--next-version            (optional) the version to use for prepare-next-dev-cycle -- default: is next minor based on version
--prepare-only                (optional) defines whether the release shall only be prepared (i.e. no push, no tag, no prepare-next-dev-cycle) -- default: false
--before-pr-fn                (optional) defines the function which is executed before preparing the release (to see if we should release) and after preparing the release -- default: beforePr (per convention defined in scripts/before-pr.sh). No arguments are passed
--prepare-next-dev-cycle-fn   (optional) defines the function which is executed to prepare the next dev cycle -- default: perpareNextDevCycle (per convention defined in scripts/prepareNextDevCycle). The following arguments are passed: -v nextVersion --pattern additionalPattern --project-dir projectsRootDir --before-pr-fn beforePrFn
--after-version-update-hook   (optional) if defined, then this function is called after versions were updated and before calling beforePr. The following arguments are passed: -v version --project-dir projectsRootDir and --pattern additionalPattern

--help     prints this help
--version  prints the version of this script

INFO: Version of release-files.sh is:
v3.3.0-SNAPSHOT
```

</releasing-release-files-help>

Full usage example:

<releasing-release-files>

<!-- auto-generated, do not modify here but in src/releasing/release-files.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
sourceOnce "$scriptsDir/before-pr.sh"

function findScripts() {
	find "src" -name "*.sh" -not -name "*.doc.sh" "$@"
}
# make the function visible to release-files.sh / not necessary if you source release-files.sh, see further below
declare -fx findScripts

# releases version v0.1.0 using the key 0x945FE615904E5C85 for signing and function findScripts to find the files which
# should be signed (and thus released). Assumes that a function named beforePr is in scope (which we sourced above)
"$dir_of_tegonal_scripts/releasing/release-files.sh" -v v0.1.0 -k "0x945FE615904E5C85" --sign-fn findScripts

# releases version v0.1.0 using the key 0x945FE615904E5C85 for signing and function findScripts to find the files which
 ## should be signed (and thus released). Moreover, searches for additional occurrences where the version should be
# replaced via the specified pattern
"$dir_of_tegonal_scripts/releasing/release-files.sh" \
	-v v0.1.0 -k "0x945FE615904E5C85" --sign-fn findScripts \
	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

function specialBeforePr(){
	beforePr && echo "imagine some additional work"
}
# make the function visible to release-files.sh / not necessary if you sourcerepare-files-next-dev-cycle.sh, see further below
declare -fx specialBeforePr

# releases version v0.1.0 using the key 0x945FE615904E5C85 for signing and
"$dir_of_tegonal_scripts/releasing/release-files.sh" \
	-v v0.1.0 -k "0x945FE615904E5C85" --sign-fn findScripts \
	--before-pr-fn specialBeforePr


# in case you want to provide your own release.sh and only want to do some pre-configuration
# then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/release-files.sh"

# and then call the function with your pre-configuration settings:
# here we define the function which shall be used to find the files to be signed
# since "$@" follows afterwards, one could still override it via command line arguments.
# put "$@" first, if you don't want that a user can override your pre-configuration
releaseFiles --sign-fn findScripts "$@"

# call the function define --before-pr-fn, don't allow to override via command line arguments
releaseFiles "$@" --before-pr-fn specialBeforePr
```

</releasing-release-files>

## Prepare Files Next Dev Cycle

Script which prepares files for a next development cycle (typically used together with [release files](#release-files)).
it uses the [prepare next dev cycle template](#prepare-next-dev-cycle-template) and thus is based on the same conventions.

<releasing-prepare-files-next-dev-cycle-help>

<!-- auto-generated, do not modify here but in src/releasing/prepare-files-next-dev-cycle.sh -->
```text
Parameters:
-v                            the version for which we prepare the dev cycle
--project-dir                 (optional) The projects directory -- default: .
-p|--pattern                  (optional) pattern which is used in a perl command (separator /) to search & replace additional occurrences. It should define two match groups and the replace operation looks as follows: \${1}$version\${2}
--before-pr-fn                (optional) defines the function which is executed before preparing the release (to see if we should release) and after preparing the release -- default: beforePr (per convention defined in scripts/before-pr.sh). No arguments are passed
--after-version-update-hook   (optional) if defined, then this function is called after versions were updated and before calling beforePr. The following arguments are passed: -v version --project-dir projectsRootDir and --pattern additionalPattern

--help     prints this help
--version  prints the version of this script

INFO: Version of prepare-files-next-dev-cycle.sh is:
v3.3.0-SNAPSHOT
```

</releasing-prepare-files-next-dev-cycle-help>

Full usage example:

<releasing-prepare-files-next-dev-cycle>

<!-- auto-generated, do not modify here but in src/releasing/prepare-files-next-dev-cycle.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
sourceOnce "$scriptsDir/before-pr.sh"

# prepare dev cycle for version v0.2.0, assumes a function beforePr is in scope which we sourced above
"$dir_of_tegonal_scripts/releasing/prepare-files-next-dev-cycle.sh" -v v0.2.0

function specialBeforePr(){
	beforePr && echo "imagine some additional work"
}
# make the function visible to release-files.sh / not necessary if you source prepare-files-next-dev-cycle.sh, see further below
declare -fx specialBeforePr

# prepare dev cycle for version v0.2.0 and
# searches for additional occurrences where the version should be replaced via the specified pattern in:
# - script files in ./src and ./scripts
# - ./README.md
# uses specialBeforePr instead of beforePr
"$dir_of_tegonal_scripts/releasing/prepare-files-next-dev-cycle.sh" -v v0.2.0 \
	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])" \
	--before-pr-fn specialBeforePr

# in case you want to provide your own release.sh and only want to do some pre-configuration
# then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/prepare-files-next-dev-cycle.sh"

# and then call the function with your pre-configuration settings:
# here we define the pattern which shall be used to replace further version occurrences
# since "$@" follows afterwards, one could still override it via command line arguments.
# put "$@" first, if you don't want that a user can override your pre-configuration
prepareNextDevCycle -p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])" "$@"

# call the function define --before-pr-fn, don't allow to override via command line arguments
prepareNextDevCycle "$@" --before-pr-fn specialBeforePr
```

</releasing-prepare-files-next-dev-cycle>

## Release Template

Defines a release process template where some conventions are defined:

- expects a version in format vX.Y.Z(-RC...)
- main is your default branch (or you use --branch to define another)
- requires you to have a function beforePr in scope (or you define another one via --before-pr-fn)
- requires you to have a function prepareNextDevCycle in scope (or you define another one via
  --prepare-next-dev-cycle-fn)

It then executes the following steps:


- [git pre-release checks](#git-pre-release-checks)
- check `beforePrFn` can be executed without problems
- [update version common release steps](#update-version-common-release-steps)
- call the afterVersionUpdateHook if defined
-  check again `beforePrFn`  is not broken
- call the releaseHook
- commit changes, create tag
- execute `prepareNextDevCycleFn` (which typically creates a commit as well)
- push tag and commits


Help:

<releasing-release-template-help>

<!-- auto-generated, do not modify here but in src/releasing/release-template.sh -->
```text
Parameters:
-v                            The version to release in the format vX.Y.Z(-RC...)
--release-hook                performs the main release task such as (run tests) create artifacts, deploy artifacts
-b|--branch                   (optional) The expected branch which is currently checked out -- default: main
--project-dir                 (optional) The projects directory -- default: .
-p|--pattern                  (optional) pattern which is used in a perl command (separator /) to search & replace additional occurrences. It should define two match groups and the replace operation looks as follows: \${1}$version\${2}
-nv|--next-version            (optional) the version to use for prepare-next-dev-cycle -- default: is next minor based on version
--prepare-only                (optional) defines whether the release shall only be prepared (i.e. no push, no tag, no prepare-next-dev-cycle) -- default: false
--before-pr-fn                (optional) defines the function which is executed before preparing the release (to see if we should release) and after preparing the release -- default: beforePr (per convention defined in scripts/before-pr.sh). No arguments are passed
--prepare-next-dev-cycle-fn   (optional) defines the function which is executed to prepare the next dev cycle -- default: perpareNextDevCycle (per convention defined in scripts/prepareNextDevCycle). The following arguments are passed: -v nextVersion --pattern additionalPattern --project-dir projectsRootDir --before-pr-fn beforePrFn
--after-version-update-hook   (optional) if defined, then this function is called after versions were updated and before calling beforePr. The following arguments are passed: -v version --project-dir projectsRootDir and --pattern additionalPattern

--help     prints this help
--version  prints the version of this script

INFO: Version of release-template.sh is:
v3.3.0-SNAPSHOT
```

</releasing-release-template-help>

Full example:

<releasing-release-template>

<!-- auto-generated, do not modify here but in src/releasing/release-template.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

function releaseScalaLib() {
	sbt publishSigned
	# or
	sbt test publishedSigned
}
# make the function visible to release-templates.sh / not necessary if you source release-templates.sh, see further below
declare -fx releaseScalaLib

# releases version v0.1.0 using releaseScalaLib as hook
"$dir_of_tegonal_scripts/releasing/release-template.sh" \
	-v v0.1.0 -k "0x945FE615904E5C85" --release-hook releaseScalaLib

# releases version v0.1.0 using releaseScalaLib as hook and
# searches for additional occurrences where the version should be replaced via the specified pattern in:
# - script files in ./src and ./scripts
# - ./README.md
"$dir_of_tegonal_scripts/releasing/release-template.sh" \
	-v v0.1.0 -k "0x945FE615904E5C85" --release-hook releaseScalaLib \
	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

# in case you want to provide your own release.sh and only want to do some pre-configuration
# (such as specify the release-hook) then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/release-template.sh"

# and then call the function with your pre-configuration settings:
# here we define the function which shall be used as release-hook after "$@" this way one cannot override it.
# put --release-hook before "$@" if you want to define only a default
releaseTemplates "$@" --release-hook releaseScalaLib

function releaseScalaLib_afterVersionUpdateHook() {
	# some additional version bumps (assuming version is in scope)
	local version
	perl -0777 -i -pe "s/.../$version/g" "build.sbt"
}

# and then call the function with your pre-configuration settings:
# here we define the function which shall be used as release-hook after "$@" this way one cannot override it.
# put --release-hook before "$@" if you want to define only a default
releaseTemplate "$@" --release-hook releaseScalaLib \
	--after-version-update-hook releaseScalaLib_afterVersionUpdateHook
```

</releasing-release-template>

## Prepare next dev cycle template

template to prepare a next releases, updating version and such using [update-version-common-steps.sh](#update-version-common-release-steps)

Help:

<releasing-prepare-next-dev-cycle-template-help>

<!-- auto-generated, do not modify here but in src/releasing/prepare-next-dev-cycle-template.sh -->
```text
Parameters:
-v                            the version for which we prepare the dev cycle
--project-dir                 (optional) The projects directory -- default: .
-p|--pattern                  (optional) pattern which is used in a perl command (separator /) to search & replace additional occurrences. It should define two match groups and the replace operation looks as follows: \${1}$version\${2}
--before-pr-fn                (optional) defines the function which is executed before preparing the release (to see if we should release) and after preparing the release -- default: beforePr (per convention defined in scripts/before-pr.sh). No arguments are passed
--after-version-update-hook   (optional) if defined, then this function is called after versions were updated and before calling beforePr. The following arguments are passed: -v version --project-dir projectsRootDir and --pattern additionalPattern

--help     prints this help
--version  prints the version of this script

INFO: Version of prepare-next-dev-cycle-template.sh is:
v3.3.0-SNAPSHOT
```

</releasing-prepare-next-dev-cycle-template-help>


Full example:

<releasing-prepare-next-dev-cycle-template>

<!-- auto-generated, do not modify here but in src/releasing/prepare-next-dev-cycle-template.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"


function prepareNextAfterVersionUpdateHook() {
	# some additional version bumps e.g. using perl
	perl -0777 -i #...
}
# make the function visible to release-templates.sh / not necessary if you source release-templates.sh, see further below
declare -fx releaseScalaLib

# releases version v0.1.0 using releaseScalaLib as hook
"$dir_of_tegonal_scripts/releasing/release-template.sh" \
	-v v0.1.0 -k "0x945FE615904E5C85" --release-hook releaseScalaLib

# releases version v0.1.0 using releaseScalaLib as hook and
# searches for additional occurrences where the version should be replaced via the specified pattern in:
# - script files in ./src and ./scripts
# - ./README.md
"$dir_of_tegonal_scripts/releasing/release-files.sh" \
	-v v0.1.0 -k "0x945FE615904E5C85" --release-hook releaseScalaLib \
	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

# in case you want to provide your own release.sh and only want to do some pre-configuration
# (such as specify the release-hook) then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/release-template.sh"

# and then call the function with your pre-configuration settings:
# here we define the function which shall be used as release-hook after "$@" this way one cannot override it.
# put --release-hook before "$@" if you want to define only a default
releaseTemplates "$@" --release-hook releaseScalaLib
```

</releasing-prepare-next-dev-cycle-template>

## git Pre-Release checks

checks if the repo is ready to be released for a given version

- expects a version in format vX.Y.Z(-RC...)
- you are currently on `main` (or use `--branch` to define a different expected branch)
- your branch is up-to-date with `origin`

it assists you in pulling/rebasing etc. in case you are on the wrong branch or behind origin.

Help:

<releasing-pre-release-checks-git-help>

<!-- auto-generated, do not modify here but in src/releasing/pre-release-checks-git.sh -->
```text
Parameters:
-v            The version to release in the format vX.Y.Z(-RC...)
-b|--branch   (optional) The expected branch which is currently checked out -- default: main

--help     prints this help
--version  prints the version of this script

INFO: Version of pre-release-checks-git.sh is:
v3.3.0-SNAPSHOT
```

</releasing-pre-release-checks-git-help>

Full usage example:

<releasing-pre-release-checks-git>

<!-- auto-generated, do not modify here but in src/releasing/pre-release-checks-git.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

# checks releasing v0.1.0 makes sense and the current branch is main
"$dir_of_tegonal_scripts/releasing/pre-release-checks-git.sh" -v v0.1.0

# checks releasing v0.1.0 makes sense and the current branch is hotfix-1.0
"$dir_of_tegonal_scripts/releasing/pre-release-checks-git.sh" -v v0.1.0 -b hotfix-1.0
```

</releasing-pre-release-checks-git>

## SBT Sonatype publish

Assumes you have configured your sbt project to publish to sonatype (or any other repo) where you have defined to 
use SONATYPE_USER and SONATYPE_PW as env vars for your credentials. I.e. your build.sbt file will contain something like:
```sbt
credentials += Credentials(
  "Sonatype Nexus Repository Manager",
  "oss.sonatype.org",
  sys.env.getOrElse("SONATYPE_USER", ""),
  sys.env.getOrElse("SONATYPE_PW", "")
)
```

This script asks to fill in those to env vars if not already given an calls `sbt publishSigned` afterwards passing
them in without exporting them.

Full example:

<releasing-sbt-publish-to-sonatype>

<!-- auto-generated, do not modify here but in src/releasing/sbt-publish-to-sonatype.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

# ask for SONATYPE_USER and SONATYPE_PW (unless already exported beforehand) and calls sbt publishSigned
"$dir_of_tegonal_scripts/releasing/sbt-publish-to-sonatype.sh"

# predefine SONATYPE_USER, asks for SONATYPE_PW (unless already exported beforehand) and calls sbt publishSigned
SONATYPE_USER="kshjwo2" "$dir_of_tegonal_scripts/releasing/sbt-publish-to-sonatype.sh"

# if you use it in combination with other files, then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/sbt-publish-to-sonatype.sh"

# and then call the function
sbtPublishToSonatype
SONATYPE_USER="kshjwo2" sbtPublishToSonatype
```

</releasing-sbt-publish-to-sonatype>


## Update Version Common Steps

Performs several `releasing` scripts defined in the following sections:

- Updates the version in *.sh (see [Update Version in bash scripts](#update-version-in-bash-scripts))
  defined in /scripts and .gt/**/pull-hook.sh
- Updates the version in .github/ISSUE_TEMPLATE/**.y(a)ml files (
  see [Update Version in issue templates](#update-version-in-issue-templates))
- Updates the version in the README.md (see next section [Update Version in README](#update-version-in-readme)).
- [activates the release section and hides the main section](#toggle-mainrelease-sections) if `-for-release` is `true` (the opposite otherwise)
- [hides the sneak-peek banner](#hideshow-sneak-peek-banner) (or shows it if `--for-release` is `false`)

Help:

<releasing-update-version-common-steps-help>

<!-- auto-generated, do not modify here but in src/releasing/update-version-common-steps.sh -->
```text
Parameters:
--for-release   true if update is for release in which case we hide the sneak-peek banner and toggle sections for release, if false then we show the sneak-peek banner and toggle the section for development
-v              The version to release in the format vX.Y.Z(-RC...)
--project-dir   (optional) The projects directory -- default: .
-p|--pattern    (optional) pattern which is used in a perl command (separator /) to search & replace additional occurrences. It should define two match groups and the replace operation looks as follows: \${1}$version\${2}

--help     prints this help
--version  prints the version of this script

INFO: Version of update-version-common-steps.sh is:
v3.3.0-SNAPSHOT
```

</releasing-update-version-common-steps-help>

Full usage example:

<releasing-update-version-common-steps>

<!-- auto-generated, do not modify here but in src/releasing/update-version-common-steps.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

# updates the version in headers of different files, hides the sneak-peek banner and
# toggles sections in README.md for release
"$dir_of_tegonal_scripts/releasing/update-version-common-steps.sh" --for-release true -v v0.1.0

# 1. searches for additional occurrences where the version should be replaced via the specified pattern
# 2. git commit all changes and create a tag for v0.1.0
# 3. call scripts/prepare-next-dev-cycle.sh with nextVersion deduced from the specified version (in this case 0.2.0-SNAPSHOT)
# 4. git commit all changes as prepare v0.2.0 dev cycle
# 5. push tag and commits
# 6. releases version v0.1.0 using the key 0x945FE615904E5C85 for signing and
"$dir_of_tegonal_scripts/releasing/update-version-common-steps.sh" \
	--for-release true \
	-v v0.1.0 -k "0x945FE615904E5C85" \
	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

# in case you want to provide your own release.sh and only want to do some pre-configuration
# then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-common-steps.sh"

# and then call the function with your pre-configuration settings:
# here we pre-define the additional pattern which shall be used in the search to replace the version
# since "$@" follows afterwards, one could still override it via command line arguments.
# put "$@" first, if you don't want that a user can override your pre-configuration
updateVersionCommonSteps -p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])" "$@"
```

</releasing-update-version-common-steps>

## Update Version in README

Updates the version used in download badges and in the sneak peek banner.
Requires that you follow one of the following schemas for the download badges:

```
[![Download](https://img.shields.io/badge/Download-<YOUR_VERSION>-%23<YOUR_COLOR>)](<ANY_URL>/v0.2.0)
[![Download](https://img.shields.io/badge/Download-<YOUR_VERSION>-%23<YOUR_COLOR>)](<ANY_URL>=v0.2.0)
```

And it searches for the following text for the sneak peek banner:

```
For instance, the [README of v2.0.0](<ANY_URL>/tree/v2.0.0/...) 
```

Help:

<releasing-update-version-README-help>

<!-- auto-generated, do not modify here but in src/releasing/update-version-README.sh -->
```text
Parameters:
-v             The version to release in the format vX.Y.Z(-RC...)
-f|--file      (optional) the file where search & replace shall be done -- default: ./README.md
-p|--pattern   (optional) pattern which is used in a perl command (separator /) to search & replace additional occurrences. It should define two match groups and the replace operation looks as follows: \${1}$version\${2}

--help     prints this help
--version  prints the version of this script

Examples:
# update version for ./README.md
update-version-README.sh -v v0.1.0

# update version for ./docs/index.md
update-version-README.sh -v v0.1.0 -f ./docs/index.md

# update version for ./README.md
# also replace occurrences of the defined pattern
update-version-README.sh -v v0.1.0 -p "(VERSION=['\"])[^'\"]+(['\"])"

INFO: Version of update-version-README.sh is:
v3.3.0-SNAPSHOT
```

</releasing-update-version-README-help>

Full usage example:

<releasing-update-version-README>

<!-- auto-generated, do not modify here but in src/releasing/update-version-README.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

"$dir_of_tegonal_scripts/releasing/update-version-README.sh" -v 0.1.0

# if you use it in combination with other tegonal-scripts files, then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-README.sh"

# and then call the function
updateVersionReadme -v 0.2.0
```

</releasing-update-version-README>

## Update Version in bash scripts

Sets the version placed before the `Description` section accordingly.

Help:

<releasing-update-version-scripts-help>

<!-- auto-generated, do not modify here but in src/releasing/update-version-scripts.sh -->
```text
Parameters:
-v               The version to release in the format vX.Y.Z(-RC...)
-d|--directory   (optional) the working directory in which *.sh are searched (also in subdirectories) / you can also specify a file -- default: ./src
-p|--pattern     (optional) pattern which is used in a perl command (separator /) to search & replace additional occurrences. It should define two match groups and the replace operation looks as follows: \${1}$version\${2}

--help     prints this help
--version  prints the version of this script

Examples:
# update version to v0.1.0 for all *.sh in ./src and subdirectories
update-version-scripts.sh -v v0.1.0

# update version to v0.1.0 for all *.sh in ./scripts and subdirectories
update-version-scripts.sh -v v0.1.0 -d ./scripts

# update version to v0.1.0 for all *.sh in ./src and subdirectories
# also replace occurrences of the defined pattern
update-version-scripts.sh -v v0.1.0 -p "(VERSION=['\"])[^'\"]+(['\"])"

INFO: Version of update-version-scripts.sh is:
v3.3.0-SNAPSHOT
```

</releasing-update-version-scripts-help>

Full usage example:

<releasing-update-version-scripts>

<!-- auto-generated, do not modify here but in src/releasing/update-version-scripts.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

"$dir_of_tegonal_scripts/releasing/update-version-scripts.sh" -v 0.1.0

# if you use it in combination with other tegonal-scripts files, then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-scripts.sh"

# and then call the function
updateVersionReadme -v 0.2.0
```

</releasing-update-version-scripts>

## Update Version in issue templates

Replaces the `placeholder` of the `Affected Version` field in the given y(a)ml files

Help:

<releasing-update-version-issue-templates-help>

<!-- auto-generated, do not modify here but in src/releasing/update-version-issue-templates.sh -->
```text
Parameters:
-v               The version to release in the format vX.Y.Z(-RC...)
-d|--directory   (optional) the working directory in which *.y(a)ml are searched (also in subdirectories) / you can also specify a file -- default: ./.github/ISSUE_TEMPLATE
-p|--pattern     (optional) pattern which is used in a perl command (separator /) to search & replace additional occurrences. It should define two match groups and the replace operation looks as follows: \${1}$version\${2}

--help     prints this help
--version  prints the version of this script

Examples:
# update version to v0.1.0 for all *.y(a)ml in ./.github/ISSUE_TEMPLATE and subdirectories
update-version-issue-templates.sh -v v0.1.0

# update version to v0.1.0 for all *.y(a)ml in ./tpls and subdirectories
update-version-issue-templates.sh -v v0.1.0 -d ./tpls

# update version to v0.1.0 for all *.y(a)ml in ./.github/ISSUE_TEMPLATE and subdirectories
# also replace occurrences of the defined pattern
update-version-issue-templates.sh -v v0.1.0 -p "(VERSION=['\"])[^'\"]+(['\"])"

INFO: Version of update-version-issue-templates.sh is:
v3.3.0-SNAPSHOT
```

</releasing-update-version-issue-templates-help>

Full usage example:

<releasing-update-version-issue-templates>

<!-- auto-generated, do not modify here but in src/releasing/update-version-issue-templates.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

"$dir_of_tegonal_scripts/releasing/update-issue-templates.sh" -v 0.1.0

# if you use it in combination with other tegonal-scripts files, then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/update-issue-templates.sh"

# and then call the function
updateVersionIssueTemplate -v 0.2.0
```

</releasing-update-version-issue-templates>

## Toggle main/release sections

Utility to comment/uncomment sections defined via

```
<!-- for main -->
...
<!-- for main end -->
```

and

```
<!-- for release -->
...
<!-- for release end -->
```

depending on the passed command:

- Passing `main` will uncomment main sections and comment release sections.
- Passing `release` will uncomment release sections and comment main sections.

Help:

<releasing-toggle-sections-help>

<!-- auto-generated, do not modify here but in src/releasing/toggle-sections.sh -->
```text
Parameters:
-c|--command   either 'main' or 'release'
-f|--file      (optional) the file where search & replace shall be done -- default: ./README.md

--help     prints this help
--version  prints the version of this script

Examples:
# comment the release sections in ./README.md and uncomment the main sections
toggle-sections.sh -c main

# comment the main sections in ./docs/index.md and uncomment the release sections
toggle-sections.sh -c release -f ./docs/index.md

INFO: Version of toggle-sections.sh is:
v3.3.0-SNAPSHOT
```

</releasing-toggle-sections-help>

Full usage example:

<releasing-toggle-sections>

<!-- auto-generated, do not modify here but in src/releasing/toggle-sections.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

"$dir_of_tegonal_scripts/releasing/toggle-sections.sh" -c main

# if you use it in combination with other files, then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/toggle-sections.sh"

# and then call the function
toggleSections -c release
```

</releasing-toggle-sections>

## Hide/Show sneak peek banner

In case you use a sneak peek banner as we do in this repo, then this script can be used to hide it (before tagging)
and show it again in the new dev cycle.

Help:

<releasing-sneak-peek-banner-help>

<!-- auto-generated, do not modify here but in src/releasing/sneak-peek-banner.sh -->
```text
Parameters:
-c|--command   either 'show' or 'hide'
-f|--file      (optional) the file where search & replace shall be done -- default: ./README.md

--help     prints this help
--version  prints the version of this script

Examples:
# hide the sneak peek banner in ./README.md
sneak-peek-banner.sh -c hide

# show the sneak peek banner in ./docs/index.md
sneak-peek-banner.sh -c show -f ./docs/index.md

INFO: Version of sneak-peek-banner.sh is:
v3.3.0-SNAPSHOT
```

</releasing-sneak-peek-banner-help>

Full usage example:

<releasing-sneak-peek-banner>

<!-- auto-generated, do not modify here but in src/releasing/sneak-peek-banner.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

"$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh" -c hide

# if you use it in combination with other files, then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh"

# and then call the function
sneakPeekBanner -c show
```

</releasing-sneak-peek-banner>

# Script Utilities

The scripts under this topic (in directory `utility`) are useful for bash programming as such.

## array utils

Utility functions when dealing with arrays.

<utility-array-utils>

<!-- auto-generated, do not modify here but in src/utility/array-utils.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/array-utils.sh"

declare regex
regex=$(joinByChar '|' my regex alternatives)
declare -a commands=(add delete list config)
regex=$(joinByChar '|' "${commands[@]}")

joinByString ', ' a list of strings and the previously defined "$regex"
declare -a names=(alwin darius fabian mike mikel robert oliver thomas)
declare employees
employees=$(joinByString ", " "${names[@]}")
echo ""
echo "Tegonal employees are currently: $employees"

function startingWithA() {
	[[ $1 == a* ]]
}
declare -a namesStartingWithA=()
arrFilter names namesStartingWithA startingWithA
declare -p namesStartingWithA

declare -a everySecondName
arrTakeEveryX names everySecondName 2 0
declare -p everySecondName
declare -a everySecondNameStartingFrom1
arrTakeEveryX names everySecondNameStartingFrom1 2 1
declare -p everySecondNameStartingFrom1

arrStringEntryMaxLength names # 6
```

</utility-array-utils>

## Ask functions

Utility functions to interact with the user.

<utility-ask>

<!-- auto-generated, do not modify here but in src/utility/ask.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/ask.sh"

if askYesOrNo "shall I say hello"; then
	echo "hello"
fi

function noAnswerCallback {
	echo "hm... no answer, I am sad :("
}
timeoutInSeconds=30
readArgs='' # i.e. no additional args passed to read
answer='default value used if there is no answer'
askWithTimeout "some question" "$timeoutInSeconds" noAnswerCallback answer "$readArgs"
echo "$answer"
```

</utility-ask>

## cleanups

Utility functions which shall help to keep your repo clean and tidy.

<utility-cleanups>

<!-- auto-generated, do not modify here but in src/utility/cleanups.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit

projectDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/.."

# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$projectDir/lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/cleanups.sh"

# e.g. in scripts/cleanup-on-push-to-main.sh
function cleanupOnPushToMain() {
	removeUnusedSignatures "$projectDir"
	logSuccess "cleanup done"
}
```

</utility-cleanups>

## Checks

Utility functions which check some conditions like is passed arg the correct type etc.

<utility-checks>

<!-- auto-generated, do not modify here but in src/utility/checks.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/checks.sh"

function foo() {
	# shellcheck disable=SC2034   # is passed by name to checkArgIsArray
	local -rn arr=$1
	local -r fn=$2
	local -r bool=$3
	local -r version=$4

	# resolves arr recursively via recursiveDeclareP and check that is a non-associative array
	checkArgIsArray arr 1        		# same as exitIfArgIsNotArray if set -e has an effect on this line
	checkArgIsFunction "$fn" 2   		# same as exitIfArgIsNotFunction if set -e has an effect on this line
	checkArgIsBoolean "$bool" 3   	# same as exitIfArgIsNotBoolean if set -e has an effect on this line
	checkArgIsVersion "$version" 4  # same as exitIfArgIsNotVersion if set -e has an effect on this line

	# shellcheck disable=SC2317   # is passed by name to checkArgIsArrayWithTuples
	function describeTriple() {
		echo >&2 "array contains 3-tuples with names where the first value is the first-, the second the middle- and the third the lastname"
	}
	# check array with 3-tuples
	checkArgIsArrayWithTuples arr 3 "names" 1 describeTriple

	exitIfArgIsNotArray arr 1
	exitIfArgIsNotArrayOrIsEmpty arr 1
	exitIfArgIsNotFunction "$fn" 2
	exitIfArgIsNotBoolean "$bool" 3
	exitIfArgIsNotVersion "$version" 4

	# shellcheck disable=SC2317   # is passed by name to exitIfArgIsNotArrayWithTuples
	function describePair() {
		echo >&2 "array contains 2-tuples with names where the first value is the first-, and the second the last name"
	}
	# check array with 2-tuples
	exitIfArgIsNotArrayWithTuples arr 2 "names" 1 describePair
}

if checkCommandExists "cat"; then
	echo "do whatever you want to do..."
fi

# give a hint how to install the command
checkCommandExists "git" "please install it via https://git-scm.com/downloads"

# same as checkCommandExists but exits instead of returning non-zero in case command does not exist
exitIfCommandDoesNotExist "git" "please install it via https://git-scm.com/downloads"

# meant to be used in a file which is sourced where a contract exists between the file which `source`s and the sourced file
exitIfVarsNotAlreadySetBySource myVar1 var2 var3
```

</utility-checks>

## git Utils

Utility functions around git.

<utility-git-utils>

<!-- auto-generated, do not modify here but in src/utility/git-utils.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/git-utils.sh"

declare currentBranch
currentBranch=$(currentGitBranch)
echo "current git branch is: $currentBranch"

if hasGitChanges; then
	echo "do whatever you want to do..."
fi

if localGitIsAhead "main"; then
	echo "do whatever you want to do..."
elif localGitIsAhead "main" "anotherRemote"; then
	echo "do whatever you want to do..."
fi

if localGitIsBehind "main"; then
	echo "do whatever you want to do..."
elif localGitIsBehind "main"; then
	echo "do whatever you want to do..."
fi

if hasRemoteTag "v0.1.0"; then
	echo "do whatever you want to do..."
elif hasRemoteTag "v0.1.0" "anotherRemote"; then
	echo "do whatever you want to do..."
fi

echo "all existing tags on remote origin, starting from smallest to biggest version number"
remoteTagsSorted

# if you specify the name of the remote, then all additional arguments are passed to `sort` which is used internally
echo "all existing tags on remote upstream, starting from smallest to biggest version number"
remoteTagsSorted upstream -r

declare latestTag
latestTag=$(latestRemoteTag)
echo "latest tag on origin: $latestTag"
latestTag=$(latestRemoteTag upstream)
echo "latest tag on upstream: $latestTag"
```

</utility-git-utils>

## GPG Utils

Utility functions which hopefully make it easier for you to deal with gpg

<utility-gpg-utils>

<!-- auto-generated, do not modify here but in src/utility/gpg-utils.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/gpg-utils.sh"

# import public-key.asc into gpg store located at ~/.gpg but ask for confirmation first
importGpgKey ~/.gpg ./public-key.asc --confirmation=true

# import public-key.asc into gpg store located at ~/.gpg and trust automatically
importGpgKey ~/.gpg ./public-key.asc --confirmation=false

# import public-key.asc into gpg store located at .gt/.gpg and trust automatically
importGpgKey .gt/.gpg ./public-key.asc --confirmation=false

# trust key which is identified via info@tegonal.com in gpg store located at ~/.gpg
trustGpgKey ~/.gpg info@tegonal.com
```

</utility-gpg-utils>

## http functions

<utility-http>

<!-- auto-generated, do not modify here but in src/utility/http.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/http.sh"

# downloads https://.../signing-key.public.asc and https://.../signing-key.public.asc.sig and verifies it with gpg
wgetAndVerify "https://github.com/tegonal/gt/.gt/signing-key.public.asc"
```

</utility-http>

## IO functions

<utility-io>

<!-- auto-generated, do not modify here but in src/utility/io.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/io.sh"

function readFile() {
	cat "$1" >&3
	echo "reading from 4 which was written to 3"
	local line
	while read -u 4 -r line; do
		echo "$line"
	done
}

# creates file descriptors 3 (output) and 4 (input) based on temporary files
# executes readFile and closes the file descriptors again
withCustomOutputInput 3 4 readFile "my-file.txt"


# First tries to set chmod 777 to the directory and all files within it and then deletes the directory
deleteDirChmod777 ".git"
```

</utility-io>

## Log Functions

Utility functions to log messages including a severity level where logError writes to stderr

<utility-log>

<!-- auto-generated, do not modify here but in src/utility/log.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/log.sh"

logInfo "hello %s" "world"
# INFO: hello world

logInfo "line %s" 1 2 3
# INFO: line 1
# INFO: line 2
# INFO: line 3

logWarning "oho..."
# WARNING: oho...

logError "illegal state..."
# ERROR: illegal state...

seconds=54
logSuccess "import finished in %s seconds" "$seconds"
# SUCCESS: import finished in 54 seconds

die "fatal error, shutting down"
# ERROR: fatal error, shutting down
# exit 1

returnDying "fatal error, shutting down"
# ERROR: fatal error, shutting down
# return 1

# in case you don't want a newline at the end of the message, then use one of
logInfoWithoutNewline "hello"
# INFO: hello%
logWarningWithoutNewline "be careful"
logErrorWithoutNewline "oho"
logSuccessWithoutNewline "yay"

traceAndDie "fatal error, shutting down"
# ERROR: fatal error, shutting down
#
# Stacktrace:
#    foo @ /opt/foo.sh:32:1
#    bar @ /opt/bar.sh:10:1
#    ...
# exit 1

traceAndReturnDying "fatal error, shutting down"
# ERROR: fatal error, shutting down
#
# Stacktrace:
#    foo @ /opt/foo.sh:32:1
#    bar @ /opt/bar.sh:10:1
#    ...
# return 1

printStackTrace
# Stacktrace:
#    foo @ /opt/foo.sh:32:1
#    bar @ /opt/bar.sh:10:1
#   main @ /opt/main.sh:4:1
```

</utility-log>

## Parse arguments

We provide three scripts helping in parsing command line arguments:

- parse-args.sh which expects named arguments
- parse-fn-args which is intended to be used in functions and only supports positional arguments
- parse-command.sh which simplifies the delegation to corresponding command functions

### parse-args.sh

Full usage example:

<utility-parse-args>

<!-- auto-generated, do not modify here but in src/utility/parse-args.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
MY_LIB_VERSION="v1.1.0"

# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/parse-args.sh"

# declare all parameter names here (used as identifier afterwards)
declare pattern version directory

# parameter definitions where each parameter definition consists of three values (separated via space)
# VARIABLE_NAME PATTERN HELP_TEXT
# where the HELP_TEXT is optional in the sense of that you can use an empty string
# shellcheck disable=SC2034   # is passed by name to parseArguments
declare params=(
	pattern '-p|--pattern' ''
	version '-v' 'the version'
	directory '-d|--directory' '(optional) the working directory -- default: .'
)
# optional: you can define examples which are included in the help text -- use an empty string for no example
declare examples
# `examples` is used implicitly in parse-args, here shellcheck cannot know it and you need to disable the rule
examples=$(
	cat <<EOM
# analyse in the current directory using the specified pattern
analysis.sh -p "%{21}" -v v0.1.0
EOM
)

parseArguments params "$examples" "$MY_LIB_VERSION" "$@"
# in case there are optional parameters, then fill them in here before calling exitIfNotAllArgumentsSet
if ! [[ -v directory ]]; then directory="."; fi
exitIfNotAllArgumentsSet params "$examples" "$MY_LIB_VERSION"

# pass your variables storing the arguments to other scripts
echo "p: $pattern, v: $version, d: $directory"
```

</utility-parse-args>

### parse-fn-args.sh

Full usage example:

<utility-parse-fn-args>

<!-- auto-generated, do not modify here but in src/utility/parse-fn-args.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit

if ! [[ -v dir_of_tegonal_scripts ]]; then
	# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/parse-fn-args.sh"

function myFunction() {
	# declare the variable you want to use and repeat in `declare params`
	local command dir

	# shellcheck disable=SC2034   # is passed by name to parseFnArgs
	local -ra params=(command dir)
	parseFnArgs params "$@"

	# pass your variables storing the arguments to other scripts
	echo "command: $command, dir: $dir"
}

function myFunctionWithVarargs() {

	# in case you want to use a vararg parameter as last parameter then name your last parameter for `params` varargs:
	local command dir varargs
	# shellcheck disable=SC2034   # is passed by name to parseFnArgs
	local -ra params=(command dir varargs)
	parseFnArgs params "$@"

	# use varargs in another script
	echo "command: $command, dir: $dir, varargs: ${varargs*}"
}
```

</utility-parse-fn-args>

### parse-commands.sh

Full usage example:

<utility-parse-commands>

<!-- auto-generated, do not modify here but in src/utility/parse-commands.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
MY_LIB_VERSION="v1.1.0"

# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/parse-commands.sh"

# command definitions where each command definition consists of two values (separated via space)
# COMMAND_NAME HELP_TEXT
# where the HELP_TEXT is optional in the sense of that you can use an empty string
# shellcheck disable=SC2034   # is passed by name to parseCommands
declare commands=(
	add 'command to add people to your list'
	config 'manage configuration'
	login ''
)

# the function which is responsible to load the corresponding file which contains the function of this particular command
function sourceCommand() {
	local -r command=$1
	shift
	sourceOnce "my-lib-$command.sh"
}

# pass:
# 1. supported commands
# 2. version which shall be shown in --version and --help
# 3. source command, responsible to load the files
# 4. the prefix used for the commands. e.g. command show with prefix my_lib_ results in calling a
#    function my_lib_show if the users wants to execute command show
# 5. arguments passed to the corresponding function
parseCommands commands "$MY_LIB_VERSION" sourceCommand "my_lib_" "$@"
```

</utility-parse-commands>

## Parse utils

Utility functions when parsing (see also [Parse arguments](#parse-arguments)).

<utility-parse-utils>

<!-- auto-generated, do not modify here but in src/utility/parse-utils.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
MY_LIBRARY_VERSION="v1.0.3"

if ! [[ -v dir_of_tegonal_scripts ]]; then
	# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/parse-utils.sh"

function myParseFunction() {
	while (($# > 0)); do
		if [[ $1 == "--version" ]]; then
			shift || die "could not shift by 1"
			printVersion "$MY_LIBRARY_VERSION"
		fi
		#...
	done
}

function myVersionPrinter() {
	# 3 defines that printVersion shall skip 3 stack frames to deduce the name of the script
	# makes only sense if we already know that this method is called indirectly
	printVersion "$MY_LIBRARY_VERSION" 3
}
```

</utility-parse-utils>

## Recursive `declare -p`

Utility function to find out the initial `declare` statement after following `declare -n` statements

<utility-recursive-declare-p>

<!-- auto-generated, do not modify here but in src/utility/recursive-declare-p.sh.doc -->
```bash
#!/usr/bin/env bash
# shellcheck disable=SC2034
set -euo pipefail
shopt -s inherit_errexit

# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/recursive-declare-p.sh"

declare -i tmp=1
declare -n ref1=tmp
declare -n ref2=ref1
declare -n ref3=ref2

declare r0 r1 r2 r3
r0=$(recursiveDeclareP tmp)
r1=$(recursiveDeclareP ref1)
r2=$(recursiveDeclareP ref2)
r3=$(recursiveDeclareP ref3)

printf "%s\n" "$r0" "$r1" "$r2" "$r3"
# declare -i tmp="1"
# declare -i tmp="1"
# declare -i tmp="1"
# declare -i tmp="1"
```

</utility-recursive-declare-p>

## Replace Snippets

If you want to include some code in markdown files (or any other HTML-like file) then replace-snippet.sh could come in
handy.

Full usage example:

<utility-replace-snippet>

<!-- auto-generated, do not modify here but in src/utility/replace-snippet.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/replace-snippet.sh"

declare file
file=$(mktemp)
echo "<my-script></my-script>" > "$file"

declare dir fileName output
dir=$(dirname "$file")
fileName=$(basename "$file")
output=$(echo "replace with your command" | grep "command")

# replaceSnippet file id dir pattern snippet
replaceSnippet my-script.sh my-script-help "$dir" "$fileName" "$output"

echo "content"
cat "$file"

# will search for <my-script-help>...</my-script-help> in the temp file and replace it with
# <my-script-help>
#
# <!-- auto-generated, do not modify here but in my-snippet -->
# ```
# output of executing $(myCommand)
# ```
# </my-script-help>
```

</utility-replace-snippet>

## Source once

Establishes a guard by creating a variable based on the file which shall be sourced.

<utility-source-once>

<!-- auto-generated, do not modify here but in src/utility/source-once.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/source-once.sh"

sourceOnce "foo.sh"    # creates a variable named sourceOnceGuard_foo__sh which acts as guard and sources foo.sh
sourceOnce "foo.sh"    # will source nothing as sourceOnceGuard_foo__sh is already defined
unset sourceOnceGuard_foo__sh          # unsets the guard
sourceOnce "foo.sh"    # is sourced again and the guard established
# you can also use sourceAlways instead of unsetting and using sourceOnce.
sourceAlways "foo.sh"

# creates a variable named sourceOnceGuard_bar__foo__sh which acts as guard and sources bar/foo.sh
sourceOnce "bar/foo.sh"

# will source nothing, only the parent dir + file is used as identifier
# i.e. the corresponding guard is sourceOnceGuard_bar__foo__sh and thus this file is not sourced
sourceOnce "asdf/bar/foo.sh"

declare guard
guard=$(determineSourceOnceGuard "src/bar.sh")
# In case you don't want that a certain file is sourced, then you can define the guard yourself
# this will prevent that */src/bar.sh is sourced
printf -v "$guard" "%s" "true"
```

</utility-source-once>

## Update Bash documentation

Updates the `Usage` section of a bash file based on a sibling doc which is named *.doc.sh (e.g foo.sh and foo.doc.sh).
Moreover, it uses [Replace Snippets](#replace-snippets) to update a corresponding snippet in the specified files.

Full usage example:

<utility-update-bash-docu>

<!-- auto-generated, do not modify here but in src/utility/update-bash-docu.sh.doc -->
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/update-bash-docu.sh"

find . -name "*.sh" \
	-not -name "*.doc.sh" \
	-print0 |
	while read -r -d $'\0' script; do
		declare script="${script:2}"
		updateBashDocumentation "$dir_of_tegonal_scripts/$script" "${script////-}" . README.md
	done
```

</utility-update-bash-docu>

# Contributors and contribute

Our thanks go to [code contributors](https://github.com/tegonal/scripts/graphs/contributors)
as well as all other contributors (e.g. bug reporters, feature request creators etc.)

You are more than welcome to contribute as well:

- star this repository if you like/use it
- [open a bug](https://github.com/tegonal/scripts/issues/new?template=bug_report.md) if you find one
- Open a [new discussion](https://github.com/tegonal/scripts/discussions/new?category=ideas) if you are missing a
  feature
- [ask a question](https://github.com/tegonal/scripts/discussions/new?category=q-a)
  so that we better understand where our scripts need to improve.
- have a look at
  the [help wanted issues](https://github.com/tegonal/scripts/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
  if you would like to code.

Please have a look at
[CONTRIBUTING.md](https://github.com/tegonal/scripts/tree/main/.github/CONTRIBUTING.md)
for further suggestions and guidelines.

# License

The provided scripts are licensed under [Apache 2.0](http://opensource.org/licenses/Apache2.0).
