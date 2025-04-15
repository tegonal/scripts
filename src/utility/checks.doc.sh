#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/checks.sh"

function foo() {
	# shellcheck disable=SC2034   # is passed by name to checkArgIsArray
	local -rn arr=$1
	local -r fn=$2
	local -r bool=$3
	local -r version=$4

	# resolves arr recursively via recursiveDeclareP and check that is a non-associative array
	checkArgIsArray arr 1        		# same as exitIfArgIsNotArray if set -e has an effect on this line
	checkArgIsFunction "$fn" 2   		# same as exitIfArgIsNotFunction if set -e has an effect on this line
	checkArgIsBoolean "$bool" 3   	# same as exitIfArgIsNotBoolean if set -e has an effect on this line
	checkArgIsVersion "$version" 4  # same as exitIfArgIsNotVersion if set -e has an effect on this line

	# shellcheck disable=SC2317   # is passed by name to checkArgIsArrayWithTuples
	function describeTriple() {
		echo >&2 "array contains 3-tuples with names where the first value is the first-, the second the middle- and the third the lastname"
	}
	# check array with 3-tuples
	checkArgIsArrayWithTuples arr 3 "names" 1 describeTriple

	exitIfArgIsNotArray arr 1
	exitIfArgIsNotArrayOrIsEmpty arr 1
	exitIfArgIsNotArrayOrIsNonEmpty arr 1
	exitIfArgIsNotFunction "$fn" 2
	exitIfArgIsNotBoolean "$bool" 3
	exitIfArgIsNotVersion "$version" 4

	# shellcheck disable=SC2317   # is passed by name to exitIfArgIsNotArrayWithTuples
	function describePair() {
		echo >&2 "array contains 2-tuples with names where the first value is the first-, and the second the last name"
	}
	# check array with 2-tuples
	exitIfArgIsNotArrayWithTuples arr 2 "names" 1 describePair

	# returns 0 if the array was initialised (i.e. a value assigned) and non-0 otherwise
	checkIsInitialisedArray arr
}

if checkCommandExists "cat"; then
	echo "do whatever you want to do..."
fi

# give a hint how to install the command
checkCommandExists "git" "please install it via https://git-scm.com/downloads"

# same as checkCommandExists but exits instead of returning non-zero in case command does not exist
exitIfCommandDoesNotExist "git" "please install it via https://git-scm.com/downloads"

# meant to be used in a file which is sourced where a contract exists between the file which `source`s and the sourced file
exitIfVarsNotAlreadySetBySource myVar1 var2 var3

declare myVar4
exitIfVariablesNotDeclared myVar4 myVar5 # would exit because myVar5 is not set
echo "myVar4 $myVar4"

declare currentDir
currentDir=$(pwd)
checkPathNamedIsInsideOf "$myVar4" "source directory" "$currentDir" # same as exitIfPathNamedIsOutsideOf if set -e has an effect on this line
exitIfPathNamedIsOutsideOf "$myVar4/plugins.txt" "plugins" "$currentDir"
