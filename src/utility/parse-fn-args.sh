#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.5.0-SNAPSHOT
#
#######  Description  #############
#
# Intended to parse positional function parameters including assignment and check if there are enough arguments
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -eu
#
#    if [ -v dir_of_tegonal_scripts ]; then
#    	declare dir_of_tegonal_scripts
#    	# Assuming tegonal's scripts are in the same directory as your script
#    	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
#    fi
#
#    function myFunction() {
#    	# declare the variable you want to use and repeat in `declare args`
#    	local command dir
#
#    	# as shellcheck doesn't get that we are passing `params` to parseFnArgs ¯\_(ツ)_/¯ (an open issue of shellcheck)
#    	# shellcheck disable=SC2034
#    	local -ra params=(command dir)
#
#    	source "$dir_of_tegonal_scripts/utility/parse-fn-args.sh"
#    	parseFnArgs params "$@"
#
#    	# pass your variables storing the arguments to other scripts
#    	echo "command: $command, dir: $dir"
#    }
#
#    function myFunctionWithVarargs() {
#
#    	# in case you want to use a vararg parameter as last parameter then name your last parameter for `params` varargs:
#    	local command dir varargs
#    	# shellcheck disable=SC2034
#    	local -ra params=(command dir)
#
#    	source "$dir_of_tegonal_scripts/utility/parse-fn-args.sh"
#    	parseFnArgs params "$@"
#
#    	# use varargs in another script
#    	echo "${varargs[0]}"
#
#    }
#
#######	Limitations	#############
#
#	1. Does not support named arguments (see parse-args.sh if you want named arguments for your function)
#
###################################
set -eu

if ! [ -v dir_of_tegonal_scripts ]; then
	declare dir_of_tegonal_scripts
	dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/..")"
	declare -r dir_of_tegonal_scripts
fi

function parseFnArgs() {
	source "$dir_of_tegonal_scripts/utility/log.sh"

	if (($# < 2)); then
		logError "At least two arguments need to be passed to parseFnArgs.\nGiven \033[0;36m%s\033[0m in \033[0;36m%s\033[0m\nFollowing a description of the parameters:" "$#" "${BASH_SOURCE[1]}"
		echo >&2 '1. params		 an array with the parameter names'
		echo >&2 '2... args...	the arguments as such, typically "$@"'
		return 9
	fi

	local -n paramArr1=$1
	shift

	local withVarArgs
	if declare -p varargs >/dev/null 2>&1; then
		withVarArgs=true
	else
		withVarArgs=false
	fi

	if (($# < ${#paramArr1[@]})); then
		logError "Not enough arguments supplied to \033[0m\033[0;36m%s\033[0m: expected %s, given %s\nFollowing a listing of the arguments (red means missing):" "${FUNCNAME[2]:-${FUNCNAME[1]}}" "${#paramArr1[@]}" "$#"

		local -i i=1
		for name in "${paramArr1[@]}"; do
			printf "\033[0m"
			if ((i - 1 < $#)); then
				printf "\033[0;32m"
			else
				printf "\033[0;31m"
			fi
			printf >&2 "%2s: %s\n" "$i" "$name"
			((i = i + 1))
		done
		printf "\033[0m"
		return 9
	fi

	if ! [ "$withVarArgs" ] && ! (($# == ${#paramArr1[@]})); then
		logError "more arguments supplied than expected to \033[0m\033[0;36m%s\033[0m: expected %s, given %s" "${FUNCNAME[1]}" "${#paramArr1[@]}" "$#"
		echo >&2 "in case you wanted your last parameter to be a vararg parameter, then use 'vararg' as last variable name your array containing the parameter names"
		return 9
	fi

	# assign arguments to specified variables
	for name in "${paramArr1[@]}"; do
		printf -v "${name}" "%s" "$1"
		shift
	done

	# assign rest to varags if declared
	if $withVarArgs; then
		# is used afterwards
		# shellcheck disable=SC2034
		varargs=("$@")
	fi
}
