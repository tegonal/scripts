#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
MY_LIB_VERSION="v1.1.0"

# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/execute-if-defined.sh"

function foo() {
	executeIfFunctionNameDefined "$1" "1" "args" "passed" "to" "function"
}

function bar() {
	local findFn
	# shellcheck disable=SC2034   # is passed by name to parseArguments
	declare params=(
		findFn '--find-fn' ''
	)
	parseArguments params "" "$MY_LIB_VERSION" "$@"

	executeIfFunctionNameDefined "$findFn" "--find-fn" "args" "passed" "to" "function"
}

# calls myFun and passing the following as arguments: "args" "passed" "to" "function"
executeIfFunctionNameDefined "myFun" "-" "args" "passed" "to" "function"
