#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v1.4.0-SNAPSHOT
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
	readonly scriptsDir
fi

if ! [[ -v projectDir ]]; then
	projectDir="$(realpath "$scriptsDir/../")"
	readonly projectDir
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

	# similar as in prepare-next-dev-cycle.sh, you might need to update it there as well if you change something here
	local -r additionalPattern="(TEGONAL_SCRIPTS_(?:LATEST_)?VERSION=['\"])[^'\"]+(['\"])"

	releaseFiles --project-dir "$projectDir" -p "$additionalPattern" --sign-fn findScripts "$@"
}

${__SOURCED__:+return}
release "$@"
