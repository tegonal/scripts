#!/usr/bin/env bash
set -euo pipefail

if ! [[ -v dir_of_tegonal_scripts ]]; then
	# Assumes your script is in (root is project folder) e.g. /src or /scripts and
	# the tegonal scripts have been pulled via gget and put into /lib/tegonal-scripts
	dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi

sourceOnce "$dir_of_tegonal_scripts/utility/log.sh"
