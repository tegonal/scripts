#!/usr/bin/env bash
set -euo pipefail
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

"$dir_of_tegonal_scripts/releasing/update-version-README.sh" -v 0.1.0

# if you use it in combination with other tegonal-scripts files, then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-README.sh"

# and then call the function
updateVersionReadme -v 0.2.0
