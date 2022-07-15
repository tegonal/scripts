#!/usr/bin/env bash
set -eu
# Assuming tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/parse-args.sh"

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

parseArguments params "$examples" "$@"
# in case there are optional parameters, then fill them in here before calling checkAllArgumentsSet
if ! [[ -v directory ]]; then directory="."; fi
checkAllArgumentsSet params "$examples"

# pass your variables storing the arguments to other scripts
echo "d: $directory, p: $pattern, v: $version"
