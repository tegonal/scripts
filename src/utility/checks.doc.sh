#!/usr/bin/env bash
set -euo pipefail
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/checks.sh"

function foo() {
	# shellcheck disable=SC2034
	local -rn arr=$1
	local -r fn=$2

	# resolves arr recursively via recursiveDeclareP and check that is a non-associative array
	checkArgIsArray arr 1
	checkArgIsFunction "$fn" 2
}

checkCommandExists "cat"

# give a hint how to install the command
checkCommandExists "git" "please install it via https://git-scm.com/downloads"
