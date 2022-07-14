#!/usr/bin/env bash
set -eu
declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
"$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh" -c hide
