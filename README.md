<!-- for main -->
<!--
[![Download](https://img.shields.io/badge/Download-v0.2.1-%23007ec6)](https://github.com/tegonal/scripts/releases/tag/v0.2.1)
[![Apache 2.0](https://img.shields.io/badge/%E2%9A%96-Apache%202.0-%230b45a6)](http://opensource.org/licenses/Apache2.0 "License")
[![Code Quality](https://github.com/tegonal/scripts/workflows/Code%20Quality/badge.svg?event=push&branch=main)](https://github.com/tegonal/scripts/actions/workflows/code-quality.yml?query=branch%3Amain)
[![Newcomers Welcome](https://img.shields.io/badge/%F0%9F%91%8B-Newcomers%20Welcome-blueviolet)](https://github.com/tegonal/scripts/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22 "Ask in discussions for help")
-->
<!-- for main end -->
<!-- for release -->

[![Download](https://img.shields.io/badge/Download-v0.2.1-%23007ec6)](https://github.com/tegonal/scripts/releases/tag/v0.2.1)
[![Apache 2.0](https://img.shields.io/badge/%E2%9A%96-Apache%202.0-%230b45a6)](http://opensource.org/licenses/Apache2.0 "License")
[![Newcomers Welcome](https://img.shields.io/badge/%F0%9F%91%8B-Newcomers%20Welcome-blueviolet)](https://github.com/tegonal/scripts/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22 "Ask in discussions for help")

<!-- for release end -->

# Scripts of Tegonal

There are scripts which we use over and over again in different projects.
As they might be usable for you as well, we are publishing them here.
Feel free to use it and report bugs if you should find one.

<!---
❗ You are taking a _sneak peek_ at the next version.
Please have a look at the README of the git tag in case you are looking for the documentation of the corresponding version.
For instance, the [README of v0.2.1](https://github.com/tegonal/scripts/tree/v0.2.1/README.md).

--->

The scripts are ordered by topic:

- [Releasing](#releasing)
  - [Update Version in README](#update-version-in-readme)
  - [Update Version in bash scripts](#update-version-in-bash-scripts)
  - [Toggle main/release sections](#toggle-mainrelease-sections)
  - [Hide/Show sneak-peek banner](#hideshow-sneak-peek-banner)

- [Script Utilities](#script-utilities)
  - [Parse arguments](#parse-arguments)
  - [Replace Snippets](#replace-snippets)
  - [Update Documentation](#update-bash-documentation)

See also:
- [Contributors and contribute](#contributors-and-contribute)
- [License](#license)

# Releasing

The scripts under this topic perform some steps of your release process.

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
-f|--file            (optional) the file where search & replace shall be done -- default: ./README.md
-v|--version         the version which shall be used

Examples:
# update version for ./README.md
update-version-README.sh -v v0.1.0

# update version for ./docs/index.md
update-version-README.sh -v v0.1.0 -f ./docs/index.md
```

</releasing-update-version-README-help>

Full usage example:

<releasing-update-version-README>

<!-- auto-generated, do not modify here but in src/releasing/update-version-README.sh -->
```bash
#!/usr/bin/env bash
set -e
declare current_dir
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
# Assuming update-version-README.sh is in the same directory as your script
"$current_dir/update-version-README.sh" -v 0.1.0
```

</releasing-update-version-README>


## Update Version in bash scripts

Sets the version placed before the `Description` section accordingly.

Help:

<releasing-update-version-scripts-help>

<!-- auto-generated, do not modify here but in src/releasing/update-version-scripts.sh -->
```text
Parameters:
-d|--directory       (optional) the working directory -- default: ./src
-v|--version         the version which shall be used

Examples:
# update version to v0.1.0 for all *.sh in ./src and subdirectories
update-version-scripts.sh -v v0.1.0

# update version to v0.1.0 for all *.sh in ./scripts and subdirectories
update-version-scripts.sh -v v0.1.0 -d ./scripts
```

</releasing-update-version-scripts-help>

Full usage example:

<releasing-update-version-scripts>

<!-- auto-generated, do not modify here but in src/releasing/update-version-scripts.sh -->
```bash
#!/usr/bin/env bash
set -e
declare current_dir
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
# Assuming update-version-scripts.sh is in the same directory as your script
"$current_dir/update-version-scripts.sh" -v 0.1.0
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
-f|--file            (optional) the file where search & replace shall be done -- default: ./README.md
-c|--command         either 'main' or 'release'

Examples:
# comment the release sections in ./README.md and uncomment the main sections
toggle-sections.sh -c main

# comment the main sections in ./docs/index.md and uncomment the release sections
toggle-sections.sh -c release -f ./docs/index.md
```

</releasing-toggle-sections-help>

Full usage example:

<releasing-toggle-sections>

<!-- auto-generated, do not modify here but in src/releasing/toggle-sections.sh -->
```bash
#!/usr/bin/env bash
set -e
declare current_dir
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
# Assuming sneak-peek-banner.sh is in the same directory as your script
"$current_dir/sneak-peek-banner.sh" -c hide
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
-f|--file            (optional) the file where search & replace shall be done -- default: ./README.md
-c|--command         either 'show' or 'hide'

Examples:
# hide the sneak peek banner in ./README.md
sneak-peek-banner.sh -c hide

# show the sneak peek banner in ./docs/index.md
sneak-peek-banner.sh -c show -f ./docs/index.md
```

</releasing-sneak-peek-banner-help>

Full usage example:

<releasing-sneak-peek-banner>

<!-- auto-generated, do not modify here but in src/releasing/sneak-peek-banner.sh -->
```bash
#!/usr/bin/env bash
set -e
declare current_dir
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
# Assuming sneak-peek-banner.sh is in the same directory as your script
"$current_dir/sneak-peek-banner.sh" -c hide
```

</releasing-sneak-peek-banner>

# Script Utilities

The scripts under this topic are useful for bash programming as such.

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

declare -A params
declare -A help

# declare the variables where the arguments shall be stored (used as identifier afterwards)
declare directory pattern

# define the regex which is used to identify the argument `directory`
params[directory]='-d|--directory'
# optional: define an explanation for the argument `directory` which will show up in `--help`
help[directory]='(optional) the working directory -- default: .'

# in case you use shellcheck then you need to suppress the warning for the last variable definition of params
# as shellcheck doesn't get that we are passing `params` to parseArguments ¯\_(ツ)_/¯
# shellcheck disable=SC2034
params[pattern]='-p|--pattern'
# `help` is used implicitly in parse-args, here shellcheck cannot know it and you need to disable the rule
# shellcheck disable=SC2034
help[pattern]='pattern used during analysis'

# optional: you can define examples which are included in the help text
declare examples
# `examples` is used implicitly in parse-args, here shellcheck cannot know it and you need to disable the rule
# shellcheck disable=SC2034
examples=$(cat << EOM
# analyse in the current directory using the specified pattern
analysis.sh -p "%{21}"
EOM
)

declare current_dir
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
# Assuming parse-args.sh is in the same directory as your script
source "$current_dir/parse-args.sh"

parseArguments params "$@"
# in case there are optional parameters, then fill them in here before calling checkAllArgumentsSet
if ! [ -v directory ]; then directory="."; fi
checkAllArgumentsSet params

# pass your variables storing the arguments to other scripts
echo "d: $directory, p: $pattern"
```

</utility-parse-args>

### parse-fn-args.sh

Full usage example:

<utility-parse-fn-args>

<!-- auto-generated, do not modify here but in src/utility/parse-fn-args.sh -->
```bash
#!/usr/bin/env bash

function myFunction() {
  # declare the variable you want to use and repeat in `declare args`
  declare command dir

  # args is used in parse-fn-args.sh thus:
  # shellcheck disable=SC2034
  declare args=(command dir)

  # Assuming parse-fn-args.sh is in the same directory as your script
  current_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
  . "$current_dir/parse-fn-args.sh"

  # pass your variables storing the arguments to other scripts
  echo "command: $command, dir: $dir"
}

function myFunctionWithVarargs() {

  # in case you want to use a vararg parameter as last parameter then name your last parameter for `args` varargs:

  declare command dir varargs
  # shellcheck disable=SC2034
  declare args=(command dir)

  # Assuming parse-fn-args.sh is in the same directory as your script
  current_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
  . "$current_dir/parse-fn-args.sh"

  # use varargs in another script
  echo "${varargs[0]}"

}
```

</utility-parse-fn-args>

## Replace Snippets

If you want to include some code in markdown files (or any other HTML-like file) then replace-snippet.sh could come in handy.

Full usage example:

<utility-replace-snippet>

<!-- auto-generated, do not modify here but in src/utility/replace-snippet.sh -->
```bash
#!/usr/bin/env bash

# Assuming replace-snippet.sh is in the same directory as your script
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"
source "$current_dir/replace-snippet.sh"

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
set -e
declare current_dir
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

# Assuming update-bash-docu.sh is in the same directory as your script
source "$current_dir/update-bash-docu.sh"
find . -name "*.sh" \
  -not -name "*.doc.sh" \
  -not -path "**.history/*" \
  -not -name "update-docu.sh" \
  -print0 | while read -r -d $'\0' script
    do
      declare script="${script:2}"
      replaceSnippetForScript "$current_dir/$script" "${script////-}" . README.md
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
