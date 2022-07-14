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
