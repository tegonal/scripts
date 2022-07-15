#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.7.1
#
###################################
set -eu

if ! [[ -v scriptDir ]]; then
	scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
	declare -r scriptDir
fi

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(realpath "$scriptDir/../src")"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi

sourceOnce "$dir_of_tegonal_scripts/utility/log.sh"

if [[ -z "${1-""}" ]]; then
	die "no version provided as first argument to prepare-next-dev-cycle in %s" "${BASH_SOURCE[1]}"
fi

version=$1
if ! [[ "$version" =~ ^(v[0-9]+)\.([0-9]+)\.[0-9]+(-RC[0-9]+)?$ ]]; then
	die "version should match vX.Y.Z(-RC...), was %s" "$version"
fi

echo "prepare next dev cycle for version $version"

# same as in release.sh, update there as well
declare additionalPattern="(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

"$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh" -c show
"$dir_of_tegonal_scripts/releasing/toggle-sections.sh" -c main
"$dir_of_tegonal_scripts/releasing/update-version-scripts.sh" -v "$version-SNAPSHOT" -p "$additionalPattern"
"$dir_of_tegonal_scripts/releasing/update-version-scripts.sh" -v "$version-SNAPSHOT" -p "$additionalPattern" -d "$scriptDir"

# update docu with new version
"$scriptDir/update-docu.sh"

git commit -a -m "prepare next dev cycle for $version"
