#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit

projectDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/.."

# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$projectDir/lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/date-utils.sh"

# converts the unix timestamp to a date in format Y-m-dTH:M:S
timestampToDateTime 1662981524 # outputs 2022-09-12T13:18:44

dateToTimestamp "2024-03-01" # outputs 1709247600
dateToTimestamp "2022-09-12T13:18:44" # outputs 1662981524

