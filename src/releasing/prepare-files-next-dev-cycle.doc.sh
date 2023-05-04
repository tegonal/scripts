#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

# prepare dev cycle for version v0.2.0
"$dir_of_tegonal_scripts/releasing/prepare-files-next-dev-cycle.sh" -v v0.2.0

# prepare dev cycle for version v0.2.0 and
# searches for additional occurrences where the version should be replaced via the specified pattern in:
# - script files in ./src and ./scripts
# - ./README.md
"$dir_of_tegonal_scripts/releasing/prepare-files-next-dev-cycle.sh" -v v0.2.0 \
	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

# in case you want to provide your own release.sh and only want to do some pre-configuration
# then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/prepare-files-next-dev-cycle.sh"

# and then call the function with your pre-configuration settings:
# here we define the pattern which shall be used to replace further version occurrences
# since "$@" follows afterwards, one could still override it via command line arguments.
# put "$@" first, if you don't want that a user can override your pre-configuration
prepareNextDevCycle -p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])" "$@"
