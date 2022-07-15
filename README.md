<!-- for main -->

[![Download](https://img.shields.io/badge/Download-v0.6.0-%23007ec6)](https://github.com/tegonal/scripts/releases/tag/v0.6.0)
[![Apache 2.0](https://img.shields.io/badge/%E2%9A%96-Apache%202.0-%230b45a6)](http://opensource.org/licenses/Apache2.0 "License")
[![Code Quality](https://github.com/tegonal/scripts/workflows/Code%20Quality/badge.svg?event=push&branch=main)](https://github.com/tegonal/scripts/actions/workflows/code-quality.yml?query=branch%3Amain)
[![Newcomers Welcome](https://img.shields.io/badge/%F0%9F%91%8B-Newcomers%20Welcome-blueviolet)](https://github.com/tegonal/scripts/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22 "Ask in discussions for help")

<!-- for main end -->
<!-- for release -->
<!--
[![Download](https://img.shields.io/badge/Download-v0.6.0-%23007ec6)](https://github.com/tegonal/scripts/releases/tag/v0.6.0)
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
Please have a look at the README of the git tag in case you are looking for the documentation of the corresponding version.
For instance, the [README of v0.6.0](https://github.com/tegonal/scripts/tree/v0.6.0/README.md).

---

**Table of Content**
- [Installation](#Installation)
- [Documentation](#documentation)
- [Contributors and contribute](#contributors-and-contribute)
- [License](#license)

# Installation

We recommend you pull the scripts with the help of [gget](https://github.com/tegonal/gget).  
Alternatively you can 
[![Download](https://img.shields.io/badge/Download-v0.6.0-%23007ec6)](https://github.com/tegonal/scripts/releases/tag/v0.6.0)
the sources.

Following the commands you need to execute to setup tegonal scripts via [gget](https://github.com/tegonal/gget).
```bash
TEGONAL_SCRIPTS_VERSION="v0.6.0" && \
gget remote add -r tegonal-scripts -u https://github.com/tegonal/scripts
````

Now you can pull the scripts you want via:
```bash
gget pull -r tegonal-scripts -t "$TEGONAL_SCRIPTS_VERSION" -p ...
```

Note that dependencies have to be pulled manually and almost all scripts depend on `src/setup.sh` 
and many depend on scripts defined in `src/utility`.
Therefore, for simplicity reasons, we recommend you pull `src/setup.sh` all files of `src/utility` in addition:
```
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

- [Script Utilities](#script-utilities)
  - [Parse arguments](#parse-arguments)
  - [Log functions](#log)
  - [`source` once](#source-once)
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
declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
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
v0.7.0-SNAPSHOT
```

</releasing-update-version-README-help>

Full usage example:

<releasing-update-version-README>

<!-- auto-generated, do not modify here but in src/releasing/update-version-README.sh -->
```bash
#!/usr/bin/env bash
set -eu
declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
"$dir_of_tegonal_scripts/releasing/update-version-README.sh" -v 0.1.0
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
v0.7.0-SNAPSHOT
```

</releasing-update-version-scripts-help>

Full usage example:

<releasing-update-version-scripts>

<!-- auto-generated, do not modify here but in src/releasing/update-version-scripts.sh -->
```bash
#!/usr/bin/env bash
set -eu
declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
"$dir_of_tegonal_scripts/releasing/update-version-scripts.sh" -v 0.1.0
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
v0.7.0-SNAPSHOT
```

</releasing-toggle-sections-help>

Full usage example:

<releasing-toggle-sections>

<!-- auto-generated, do not modify here but in src/releasing/toggle-sections.sh -->
```bash
#!/usr/bin/env bash
set -eu
declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
"$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh" -c hide
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
v0.7.0-SNAPSHOT
```

</releasing-sneak-peek-banner-help>

Full usage example:

<releasing-sneak-peek-banner>

<!-- auto-generated, do not modify here but in src/releasing/sneak-peek-banner.sh -->
```bash
#!/usr/bin/env bash
set -eu
declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
"$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh" -c hide
```

</releasing-sneak-peek-banner>

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

# declare the variables where the arguments shall be stored (used as identifier afterwards)
declare directory pattern version

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

declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
source "$dir_of_tegonal_scripts/utility/parse-args.sh"

parseArguments params "$examples" "$@"
# in case there are optional parameters, then fill them in here before calling checkAllArgumentsSet
if ! [[ -v directory ]]; then directory="."; fi
checkAllArgumentsSet params "$examples"

# pass your variables storing the arguments to other scripts
echo "d: $directory, p: $pattern, v: $version"
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
	declare dir_of_tegonal_scripts
	# Assuming tegonal's scripts are in the same directory as your script
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
fi

function myFunction() {
	# declare the variable you want to use and repeat in `declare args`
	local command dir

	# as shellcheck doesn't get that we are passing `params` to parseFnArgs ¯\_(ツ)_/¯ (an open issue of shellcheck)
	# shellcheck disable=SC2034
	local -ra params=(command dir)

	source "$dir_of_tegonal_scripts/utility/parse-fn-args.sh"
	parseFnArgs params "$@"

	# pass your variables storing the arguments to other scripts
	echo "command: $command, dir: $dir"
}

function myFunctionWithVarargs() {

	# in case you want to use a vararg parameter as last parameter then name your last parameter for `params` varargs:
	local command dir varargs
	# shellcheck disable=SC2034
	local -ra params=(command dir)

	source "$dir_of_tegonal_scripts/utility/parse-fn-args.sh"
	parseFnArgs params "$@"

	# use varargs in another script
	echo "${varargs[0]}"

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
declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
source "$dir_of_tegonal_scripts/utility/log.sh"

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

# in case you don't want a newline at the end of the message, then use one of
logInfoWithoutNewline "hello"
# INFO: hello%
logWarningWithoutNewline "be careful"
logErrorWithoutNewline "oho"
logSuccessWithoutNewline "yay"
```

</utility-log>

## Source once

Establishes a guard by creating a variable based on the file which shall be sourced

## Recursive `declare -p`

Utility function to find out the initial `declare` statement after following `declare -n` statements

<utility-recursive-declare-p>

<!-- auto-generated, do not modify here but in src/utility/recursive-declare-p.sh -->
```bash
#!/usr/bin/env bash
# shellcheck disable=SC2034
set -eu

declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
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

If you want to include some code in markdown files (or any other HTML-like file) then replace-snippet.sh could come in handy.

Full usage example:

<utility-replace-snippet>

<!-- auto-generated, do not modify here but in src/utility/replace-snippet.sh -->
```bash
#!/usr/bin/env bash
set -eu

declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
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

declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
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
- Open a [new discussion](https://github.com/tegonal/scripts/discussions/new?category=ideas) if you are missing a feature
- [ask a question](https://github.com/tegonal/scripts/discussions/new?category=q-a)
  so that we better understand where our scripts need to improve.
- have a look at the [help wanted issues](https://github.com/tegonal/scripts/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
  if you would like to code.

# License

The provided scripts are licensed under [Apache 2.0](http://opensource.org/licenses/Apache2.0).
