#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
MY_LIBRARY_VERSION="v1.0.3"

if ! [[ -v dir_of_tegonal_scripts ]]; then
	# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/parse-utils.sh"

function myParseFunction() {
	while (($# > 0)); do
		if [[ $1 == "--version" ]]; then
			shift || die "could not shift by 1"
			printVersion "$MY_LIBRARY_VERSION"
		fi
		#...
	done
}
