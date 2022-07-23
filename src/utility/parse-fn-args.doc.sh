#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit

if ! [[ -v dir_of_tegonal_scripts ]]; then
	# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
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
