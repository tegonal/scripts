#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
MY_LIBRARY_VERSION="v1.0.3"

if ! [[ -v dir_of_tegonal_scripts ]]; then
	# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
	source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/parse-utils.sh"

function myParseFunction() {
	while (($# > 0)); do
		if [[ $1 == "--version" ]]; then
			shift 1 || traceAndDie "could not shift by 1"
			printVersion "$MY_LIBRARY_VERSION"
		fi
		#...
	done
}

function myVersionPrinter() {
	# 3 defines that printVersion shall skip 3 stack frames to deduce the name of the script
	# makes only sense if we already know that this method is called indirectly
	printVersion "$MY_LIBRARY_VERSION" 3
}
