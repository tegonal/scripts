<!-- for main -->

[![Download](https://img.shields.io/badge/Download-v0.8.0-%23007ec6)](https://github.com/tegonal/scripts/releases/tag/v0.8.0)
[![Apache 2.0](https://img.shields.io/badge/%E2%9A%96-Apache%202.0-%230b45a6)](http://opensource.org/licenses/Apache2.0 "License")
[![Code Quality](https://github.com/tegonal/scripts/workflows/Code%20Quality/badge.svg?event=push&branch=main)](https://github.com/tegonal/scripts/actions/workflows/code-quality.yml?query=branch%3Amain)
[![Newcomers Welcome](https://img.shields.io/badge/%F0%9F%91%8B-Newcomers%20Welcome-blueviolet)](https://github.com/tegonal/scripts/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22 "Ask in discussions for help")

<!-- for main end -->
<!-- for release -->
<!--
[![Download](https://img.shields.io/badge/Download-v0.8.0-%23007ec6)](https://github.com/tegonal/scripts/releases/tag/v0.8.0)
[![Apache 2.0](https://img.shields.io/badge/%E2%9A%96-Apache%202.0-%230b45a6)](http://opensource.org/licenses/Apache2.0 "License")
[![Newcomers Welcome](https://img.shields.io/badge/%F0%9F%91%8B-Newcomers%20Welcome-blueviolet)](https://github.com/tegonal/scripts/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22 "Ask in discussions for help")
-->
<!-- for release end -->

# Scripts of Tegonal

There are scripts which we use over and over again in different projects.
As they might be usable for you as well, we are publishing them here.
Feel free to use it and report bugs if you should find one.

---
❗ You are taking a _sneak peek_ at the next version.
Please have a look at the README of the git tag in case you are looking for the documentation of the corresponding
version.
For instance, the [README of v0.8.0](https://github.com/tegonal/scripts/tree/v0.8.0/README.md).

---

**Table of Content**

- [Installation](#Installation)
- [Documentation](#documentation)
- [Contributors and contribute](#contributors-and-contribute)
- [License](#license)

# Installation

We recommend you pull the scripts with the help of [gget](https://github.com/tegonal/gget).  
Alternatively you can
[![Download](https://img.shields.io/badge/Download-v0.8.0-%23007ec6)](https://github.com/tegonal/scripts/releases/tag/v0.8.0)
the sources.

Following the commands you need to execute to setup tegonal scripts via [gget](https://github.com/tegonal/gget).

```bash
gget remote add -r tegonal-scripts -u https://github.com/tegonal/scripts
````

Now you can pull the scripts you want via:

```bash
export TEGONAL_SCRIPTS_VERSION="v0.8.0"
gget pull -r tegonal-scripts -t "$TEGONAL_SCRIPTS_VERSION" -p ...
```

Note that dependencies have to be pulled manually and almost all scripts depend on `src/setup.sh`
and many depend on scripts defined in `src/utility`.
Therefore, for simplicity reasons, we recommend you pull `src/setup.sh` all files of `src/utility` in addition:

```
export TEGONAL_SCRIPTS_VERSION="v0.8.0" 
gget pull -r tegonal-scripts -t "$TEGONAL_SCRIPTS_VERSION" -p src/setup.sh
gget pull -r tegonal-scripts -t "$TEGONAL_SCRIPTS_VERSION" -p src/utility/
```

## Sourcing functions

We recommend you use the following code at the beginning of your script in case you want to `source` a file/function
(in the example below we want to use tegonal's log functions):

<setup>

<!-- auto-generated, do not modify here but in src/setup.sh -->
```bash
#!/usr/bin/env bash
set -eu

if ! [[ -v dir_of_tegonal_scripts ]]; then
	# Assumes your script is in (root is project folder) e.g. /src or /scripts and
	# the tegonal scripts have been pulled via gget and put into /lib/tegonal-scripts
	dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi

sourceOnce "$dir_of_tegonal_scripts/utility/log.sh"
```

</setup>

# Documentation

The scripts are ordered by topic:

- [Quality Assurance](#quality-assurance)
	- [runShellcheck](#runshellcheck)
- [Releasing](#releasing)
    - [Update Version in README](#update-version-in-readme)
    - [Update Version in bash scripts](#update-version-in-bash-scripts)
    - [Toggle main/release sections](#toggle-mainrelease-sections)
    - [Hide/Show sneak-peek banner](#hideshow-sneak-peek-banner)
    - [Releasing Files](#release-files)

- [Script Utilities](#script-utilities)
    - [Parse arguments](#parse-arguments)
    - [Log functions](#log)
    - [`source` once](#source-once)
    - [git Utils](#git-utils)
    - [GPG Utils](#gpg-utils)
    - [Recursive `declare -p`](#recursive-declare--p)
    - [Replace Snippets](#replace-snippets)
    - [Update Documentation](#update-bash-documentation)

# Quality Assurance

The scripts under this topic (in directory `qa`) perform checks or execute qa tools.

## runShellcheck

A function which expects the name of an array of dirs as first argument and a source path as second argument (which is
passed to shellcheck via -P parameter). It then executes shellcheck for each *.sh in these directories with predefined
settings for shellcheck.

<qa-run-shellcheck>

<!-- auto-generated, do not modify here but in src/qa/run-shellcheck.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/qa/run-shellcheck.sh"

# shellcheck disable=SC2034
declare -a dirs=(
	"$dir_of_tegonal_scripts"
	"$dir_of_tegonal_scripts/../scripts"
	"$dir_of_tegonal_scripts/../spec"
)
declare sourcePath="$dir_of_tegonal_scripts"
runShellcheck dirs "$sourcePath"
```

</qa-run-shellcheck>

# Releasing

The scripts under this topic (in directory `releasing`) perform some steps of your release process.

## Update Version in README

Updates the version used in download badges and in the sneak peek banner.
Requires that you follow one of the following schemas for the download badges:

```
[![Download](https://img.shields.io/badge/Download-<YOUR_VERSION>-%23<YOUR_COLOR>)](<ANY_URL>/v0.2.0)
[![Download](https://img.shields.io/badge/Download-<YOUR_VERSION>-%23<YOUR_COLOR>)](<ANY_URL>=v0.2.0)
```

And it searches for the following text for the sneak peek banner:

```
For instance, the [README of <YOUR_VERSION>](<ANY_URL>/tree/<YOUR_VERSION>/...) 
```

Help:

<releasing-update-version-README-help>

<!-- auto-generated, do not modify here but in src/releasing/update-version-README.sh -->
```text
Parameters:
-v              the version which shall be used
-f|--file       (optional) the file where search & replace shall be done -- default: ./README.md
-p|--pattern    (optional) pattern which is used in a perl command (separator /) to search & replace additional occurrences. It should define two match groups and the replace operation looks as follows: \${1}$version\${2}

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
v0.9.0-SNAPSHOT
```

</releasing-update-version-README-help>

Full usage example:

<releasing-update-version-README>

<!-- auto-generated, do not modify here but in src/releasing/update-version-README.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
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
-v               the version which shall be used
-d|--directory   (optional) the working directory -- default: ./src
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
v0.9.0-SNAPSHOT
```

</releasing-update-version-scripts-help>

Full usage example:

<releasing-update-version-scripts>

<!-- auto-generated, do not modify here but in src/releasing/update-version-scripts.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

"$dir_of_tegonal_scripts/releasing/update-version-scripts.sh" -v 0.1.0

# if you use it in combination with other tegonal-scripts files, then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-README.sh"

# and then call the function
updateVersionReadme -v 0.2.0
```

</releasing-update-version-scripts>

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
-c|--command    either 'main' or 'release'
-f|--file       (optional) the file where search & replace shall be done -- default: ./README.md

--help     prints this help
--version  prints the version of this script

Examples:
# comment the release sections in ./README.md and uncomment the main sections
toggle-sections.sh -c main

# comment the main sections in ./docs/index.md and uncomment the release sections
toggle-sections.sh -c release -f ./docs/index.md

INFO: Version of toggle-sections.sh is:
v0.9.0-SNAPSHOT
```

</releasing-toggle-sections-help>

Full usage example:

<releasing-toggle-sections>

<!-- auto-generated, do not modify here but in src/releasing/toggle-sections.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
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
-c|--command    either 'show' or 'hide'
-f|--file       (optional) the file where search & replace shall be done -- default: ./README.md

--help     prints this help
--version  prints the version of this script

Examples:
# hide the sneak peek banner in ./README.md
sneak-peek-banner.sh -c hide

# show the sneak peek banner in ./docs/index.md
sneak-peek-banner.sh -c show -f ./docs/index.md

INFO: Version of sneak-peek-banner.sh is:
v0.9.0-SNAPSHOT
```

</releasing-sneak-peek-banner-help>

Full usage example:

<releasing-sneak-peek-banner>

<!-- auto-generated, do not modify here but in src/releasing/sneak-peek-banner.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

"$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh" -c hide

# if you use it in combination with other files, then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh"

# and then call the function
sneakPeekBanner -c show
```

</releasing-sneak-peek-banner>

## Release Files

Script which releases a version for a repository containing files which don't need to be compiled or packaged.
It is based on some conventions (see src/releasing/release-files.sh for more details):
- expects a version in format vX.Y.Z(-RC...)
- main is your default branch
- requires you to have a /scripts folder in your project root which contains:
  - before-pr.sh which provides a parameterless function `beforePr` and can be sourced (add `${__SOURCED__:+return}` before executing `beforePr`)
  - prepare-next-dev-cycle.sh which provides function `prepareNextDevCycle` with parameters `-v` for version
    and `-p` for additionalPattern (see source for more detail). Also this file needs to be sourcable.
- there is a public key defined at .gget/signing-key.public.asc which will be used
  to verify the signatures which will be created

It then includes the following steps:
- some checks regarding git status 
- `beforePr`
- rewrite sneak-peek banner
- toggle main/release sections in README
- update version in download badges and sneak-peek banner in README as well as   
  replace additional occurrences defined via `-p|--pattern` (see output of `--help` further below for further details) 
- update version in script headers in /src and /scripts of your project
- `beforePr`
- sign files via GPG where you define which files via `--sign-fn`
- commit
- `prepareNextDevCycle`
- push changes
- tag and push tag

Useful if you want to release e.g. scripts which can then be fetched via [gget](https://github.com/tegonal/gget).

Help:

<releasing-release-files-help>

<!-- auto-generated, do not modify here but in src/releasing/release-files.sh -->
```text
Parameters:
-v                   The version to release in the format vX.Y.Z(-RC...)
-k|--key             The GPG private key which shall be used to sign the files
--sign-fn            Function which is called to determine what files should be signed. It should be based find and allow to pass further arguments (we will i.a. pass -print0)
--project-dir        (optional) The projects directory -- default: .
-p|--pattern         (optional) pattern which is used in a perl command (separator /) to search & replace additional occurrences. It should define two match groups and the replace operation looks as follows: \${1}$version\${2}
-nv|--next-version   (optional) the version to use for prepare-next-dev-cycle -- default: is next minor based on version
--prepare-only       (optional) defines whether the release shall only be prepared (i.e. no push, no tag, no prepare-next-dev-cycle) -- default: false

--help     prints this help
--version  prints the version of this script

INFO: Version of release-files.sh is:
v0.9.0-SNAPSHOT
```

</releasing-release-files-help>

Full usage example:

<releasing-release-files>

<!-- auto-generated, do not modify here but in src/releasing/release-files.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

function findScripts() {
	find "src" -name "*.sh" -not -name "*.doc.sh" "$@"
}
# make the function visible to release-files.sh / not necessary if you source release-files.sh, see further below
declare -fx findScripts

# releases version v0.1.0 using the key 0x945FE615904E5C85 for signing
"$dir_of_tegonal_scripts/releasing/release-files.sh" -v v0.1.0 -k "0x945FE615904E5C85" --sign-fn findScripts

# releases version v0.1.0 using the key 0x945FE615904E5C85 for signing and
# searches for additional occurrences where the version should be replaced via the specified pattern in:
# - script files in ./src and ./scripts
# - ./README.md
"$dir_of_tegonal_scripts/releasing/release-files.sh" \
	-v v0.1.0 -k "0x945FE615904E5C85" --sign-fn findScripts \
	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

# in case you want to provide your own release.sh and only want to do some pre-configuration
# then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/release-files.sh"

# and then call the function with your pre-configuration settings:
# here we define the function which shall be used to find the files to be signed
# since "$@" follows afterwards, one could still override it via command line arguments.
# put "$@" first, if you don't want that a user can override your pre-configuration
releaseFiles --sign-fn findScripts "$@"
```

</releasing-release-files>

# Script Utilities

The scripts under this topic (in directory `utility`) are useful for bash programming as such.

## Parse arguments

We have two scripts helping in parsing arguments:

- parse-args.sh which expects named arguments
- parse-fn-args which is supposed to be sourced into a function

### parse-args.sh

Full usage example:

<utility-parse-args>

<!-- auto-generated, do not modify here but in src/utility/parse-args.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/parse-args.sh"

# declare all parameter names here (used as identifier afterwards)
declare pattern version directory

# parameter definitions where each parameter definition consists of three values (separated via space)
# VARIABLE_NAME PATTERN HELP_TEXT
# where the HELP_TEXT is optional in the sense of that you can use an empty string
# in case you use shellcheck then you need to suppress the warning for the last variable definition of params
# as shellcheck doesn't get that we are passing `params` to parseArguments ¯\_(ツ)_/¯ (an open issue of shellcheck)
# shellcheck disable=SC2034
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

parseArguments params "$examples" "$@"
# in case there are optional parameters, then fill them in here before calling checkAllArgumentsSet
if ! [[ -v directory ]]; then directory="."; fi
checkAllArgumentsSet params "$examples"

# pass your variables storing the arguments to other scripts
echo "p: $pattern, v: $version, d: $directory"
```

</utility-parse-args>

### parse-fn-args.sh

Full usage example:

<utility-parse-fn-args>

<!-- auto-generated, do not modify here but in src/utility/parse-fn-args.sh -->
```bash
#!/usr/bin/env bash
set -eu

if ! [[ -v dir_of_tegonal_scripts ]]; then
	# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
	dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/parse-fn-args.sh"

function myFunction() {
	# declare the variable you want to use and repeat in `declare params`
	local command dir

	# as shellcheck doesn't get that we are passing `params` to parseFnArgs ¯\_(ツ)_/¯ (an open issue of shellcheck)
	# shellcheck disable=SC2034
	local -ra params=(command dir)
	parseFnArgs params "$@"

	# pass your variables storing the arguments to other scripts
	echo "command: $command, dir: $dir"
}

function myFunctionWithVarargs() {

	# in case you want to use a vararg parameter as last parameter then name your last parameter for `params` varargs:
	local command dir varargs
	# shellcheck disable=SC2034
	local -ra params=(command dir varargs)
	parseFnArgs params "$@"

	# use varargs in another script
	echo "command: $command, dir: $dir, varargs: ${varargs*}"
}
```

</utility-parse-fn-args>

## Log

Utility functions to log messages including a severity level where logError writes to stderr

<utility-log>

<!-- auto-generated, do not modify here but in src/utility/log.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
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
# Stacktrace:
#    foo @ /opt/foo.sh:32:1
#    bar @ /opt/bar.sh:10:1
#    ...
# return 1

printStacktrace
# Stacktrace:
#    foo @ /opt/foo.sh:32:1
#    bar @ /opt/bar.sh:10:1
#   main @ /opt/main.sh:4:1
```

</utility-log>

## Source once

Establishes a guard by creating a variable based on the file which shall be sourced.

<utility-source-once>

<!-- auto-generated, do not modify here but in src/utility/source-once.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/source-once.sh"

sourceOnce "foo.sh"    # creates a variable named foo__sh which acts as guard and sources foo.sh
sourceOnce "foo.sh"    # will source nothing as foo__sh is already defined
unset foo__sh          # unsets the guard
sourceOnce "foo.sh"    # is sourced again and the guard established



# creates a variable named bar__foo__sh which acts as guard and sources bar/foo.sh
sourceOnce "bar/foo.sh"

# will source nothing, only the parent dir + file is used as identifier
# i.e. the corresponding guard is bar__foo__sh and thus this file is not sourced
sourceOnce "asdf/bar/foo.sh"
```

</utility-source-once>

## git Utils

Utility functions around git.

<utility-git-utils>

<!-- auto-generated, do not modify here but in src/utility/git-utils.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/git-utils.sh"

echo "current git branch is: $(currentGitBranch)"

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
```

</utility-git-utils>

## GPG Utils

Utility functions which hopefully make it easier for you to deal with gpg

<utility-gpg-utils>

<!-- auto-generated, do not modify here but in src/utility/gpg-utils.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/gpg-utils.sh"

# import public-key.asc into gpg store located at ~/.gpg but ask for confirmation first
importGpgKey ~/.gpg ./public-key.asc --confirmation=true

# import public-key.asc into gpg store located at ~/.gpg and trust automatically
importGpgKey ~/.gpg ./public-key.asc --confirmation=false

# import public-key.asc into gpg store located at .gget/.gpg and trust automatically
importGpgKey .gget/.gpg ./public-key.asc --confirmation=false

# trust key which is identified via info.com in gpg store located at ~/.gpg
trustGpgKey ~/.gpg info.com
```

</utility-gpg-utils>

## Recursive `declare -p`

Utility function to find out the initial `declare` statement after following `declare -n` statements

<utility-recursive-declare-p>

<!-- auto-generated, do not modify here but in src/utility/recursive-declare-p.sh -->
```bash
#!/usr/bin/env bash
# shellcheck disable=SC2034
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/recursive-declare-p.sh"

declare -i tmp=1
declare -n ref1=tmp
declare -n ref2=ref1
declare -n ref3=ref2

printf "%s\n" \
	"$(set -e; recursiveDeclareP tmp)" \
	"$(set -e; recursiveDeclareP ref1)" \
	"$(set -e; recursiveDeclareP ref2)" \
	"$(set -e; recursiveDeclareP ref3)"
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

<!-- auto-generated, do not modify here but in src/utility/replace-snippet.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/replace-snippet.sh"

declare file
file=$(mktemp)
echo "<my-script></my-script>" > "$file"

# replaceSnippet file id dir pattern snippet
replaceSnippet my-script.sh my-script-help "$(dirname "$file")" "$(basename "$file")" "$(echo "replace with your command" | grep "command")"

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

## Update Bash documentation

Updates the `Usage` section of a bash file based on a sibling doc which is named *.doc.sh (e.g foo.sh and foo.doc.sh).
Moreover, it uses [Replace Snippets](#replace-snippets) to update a corresponding snippet in the specified files.

Full usage example:

<utility-update-bash-docu>

<!-- auto-generated, do not modify here but in src/utility/update-bash-docu.sh -->
```bash
#!/usr/bin/env bash
set -eu
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/update-bash-docu.sh"

find . -name "*.sh" \
	-not -name "*.doc.sh" \
	-not -path "**.history/*" \
	-not -name "update-docu.sh" \
	-print0 |
	while read -r -d $'\0' script; do
		declare script="${script:2}"
		replaceSnippetForScript "$dir_of_tegonal_scripts/$script" "${script////-}" . README.md
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

# License

The provided scripts are licensed under [Apache 2.0](http://opensource.org/licenses/Apache2.0).
