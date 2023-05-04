#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

"$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh" -c hide

# if you use it in combination with other files, then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh"

# and then call the function
sneakPeekBanner -c show
