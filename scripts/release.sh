#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.14.0
#
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH

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
sourceOnce "$dir_of_tegonal_scripts/releasing/release-files.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/checks.sh"

function release() {
	if ! checkCommandExists "shellspec" "please install https://github.com/shellspec/shellspec#installation"; then
		die "You need to have shellspec installed if you want to create a release."
	fi

	function findScripts() {
		find "$dir_of_tegonal_scripts" -name "*.sh" -not -name "*.doc.sh" "$@"
	}

	# same as in prepare-next-dev-cycle.sh, update there as well
	local -r additionalPattern="(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

	releaseFiles --project-dir "$projectDir" -p "$additionalPattern" --sign-fn findScripts "$@"
}

${__SOURCED__:+return}
release "$@"
