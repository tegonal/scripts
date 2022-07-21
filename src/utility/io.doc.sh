#!/usr/bin/env bash
set -euo pipefail
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/io.sh"

function readFile() {
	cat "$1" >&3
	echo "reading from 4 which was written to 3"
	local line
	while read -u 4 -r line; do
		echo "$line"
	done
}

# creates file descriptors 3 (output) and 4 (input) based on temporary files
# executes readFile and closes the file descriptors again
withCustomOutputInput 3 4 readFile
