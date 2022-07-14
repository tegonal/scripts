#!/usr/bin/env bash
set -eu

function myFunction() {
	# declare the variable you want to use and repeat in `declare args`
	declare command dir

	# args is used in parse-fn-args.sh thus:
	# shellcheck disable=SC2034
	declare args=(command dir)

	# Assuming parse-fn-args.sh is in the same directory as your script
	local scriptDir
	scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
	. "$scriptDir/parse-fn-args.sh"

	# pass your variables storing the arguments to other scripts
	echo "command: $command, dir: $dir"
}

function myFunctionWithVarargs() {

	# in case you want to use a vararg parameter as last parameter then name your last parameter for `args` varargs:

	declare command dir varargs
	# shellcheck disable=SC2034
	declare args=(command dir)

	# Assuming parse-fn-args.sh is in the same directory as your script
	local scriptDir
	scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
	. "$scriptDir/parse-fn-args.sh"

	# use varargs in another script
	echo "${varargs[0]}"

}
