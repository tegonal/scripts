#!/usr/bin/env bash
set -eu
declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"

function foo() {
	source "$dir_of_tegonal_scripts/qa/checks.sh"

	# shellcheck disable=SC2034
	local -n arr=$1
	checkArgIsArray arr 1
}
