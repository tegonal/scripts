#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.12.0-SNAPSHOT
#
###################################
set -euo pipefail
shopt -s inherit_errexit

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
	declare -r scriptsDir
fi

if ! [[ -v projectDir ]]; then
	projectDir="$(realpath "$scriptsDir/../")"
	declare -r projectDir
fi

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$projectDir/src"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/releasing/prepare-files-next-dev-cycle.sh"

function prepareNextDevCycle() {
	# same as in release.sh, update there as well
	local -r additionalPattern="(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

	prepareFilesNextDevCycle --project-dir "$projectDir" -p "$additionalPattern" "$@"
}

${__SOURCED__:+return}
prepareNextDevCycle "$@"
