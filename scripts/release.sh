#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.8.0-SNAPSHOT
#
###################################
set -eu

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
	declare -r scriptsDir
fi

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(realpath "$scriptsDir/../src")"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
if ! [[ -x "$(command -v "shellspec")" ]]; then
	die "You need to have shellspec installed if you want to create a release"
fi

function findScripts() {
	find "$scriptsDir/../src" -name "*.sh" -not -name "*.doc.sh" "$@"
}
# TODO would be nicer if we could source release-files.sh because then we don't have to export the function
declare -fx findScripts

"$dir_of_tegonal_scripts/releasing/release-files.sh" "$@" \
	--scripts-dir "$scriptsDir" \
	--sign-fn findScripts \
	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"
