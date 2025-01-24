#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit

projectDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/.."

# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$projectDir/lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/date-utils.sh"

# converts the unix timestamp to a date with time in format Y-m-dTH:M:S
timestampToDateTime 1662981524 # outputs 2022-09-12T13:18:44

# converts the unix timestamp to a date in format Y-m-d
timestampToDate 1662981524 # outputs 2022-09-12

# converts the unix timestamp to a date in format as defined by LC_TIME
# (usually as defined by the user in the system settings)
timestampToDateInUserFormat 1662981524 # outputs 12.09.2022 for ch_DE

dateToTimestamp "2024-03-01" # outputs 1709247600
dateToTimestamp "2022-09-12T13:18:44" # outputs 1662981524

