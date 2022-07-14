#!/usr/bin/env bash
set -eu

if [ -v dir_of_tegonal_scripts ]; then
	declare dir_of_tegonal_scripts
	# Assuming tegonal's scripts are in the same directory as your script
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
fi

function myFunction() {
	# declare the variable you want to use and repeat in `declare args`
	declare command dir

	# args is used in parse-fn-args.sh thus:
	# shellcheck disable=SC2034
	declare args=(command dir)

	source "$dir_of_tegonal_scripts/utility/parse-fn-args.sh"

	# pass your variables storing the arguments to other scripts
	echo "command: $command, dir: $dir"
}

function myFunctionWithVarargs() {

	# in case you want to use a vararg parameter as last parameter then name your last parameter for `args` varargs:

	declare command dir varargs
	# shellcheck disable=SC2034
	declare args=(command dir)

	source "$dir_of_tegonal_scripts/utility/parse-fn-args.sh"

	# use varargs in another script
	echo "${varargs[0]}"

}
