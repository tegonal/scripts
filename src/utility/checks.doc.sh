#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/checks.sh"

function foo() {
	# shellcheck disable=SC2034
	local -rn arr=$1
	local -r fn=$2

	# resolves arr recursively via recursiveDeclareP and check that is a non-associative array
	checkArgIsArray arr 1       # same as exitIfArgIsNotArray if set -e has an effect on this line
	checkArgIsFunction "$fn" 2   # same as exitIfArgIsNotFunction if set -e has an effect on this line

	exitIfArgIsNotArray arr 1
	exitIfArgIsNotFunction "$fn" 2
}

if checkCommandExists "cat"; then
	echo "do whatever you want to do..."
fi

# give a hint how to install the command
checkCommandExists "git" "please install it via https://git-scm.com/downloads"

# same as checkCommandExists but exits instead of returning non-zero in case command does not exist
exitIfCommandDoesNotExist "git" "please install it via https://git-scm.com/downloads"

