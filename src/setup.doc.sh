#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo "please update to bash 5, see errors above"; exit 1; }

if ! [[ -v dir_of_tegonal_scripts ]]; then
	# Assumes your script is in (root is project folder) e.g. /src or /scripts and
	# the tegonal scripts have been pulled via gt and put into /lib/tegonal-scripts
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi

sourceOnce "$dir_of_tegonal_scripts/utility/io.sh"
