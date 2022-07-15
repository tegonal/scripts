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
sourceOnce "$dir_of_tegonal_scripts/utility/log.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/toggle-sections.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-README.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-scripts.sh"
sourceOnce "$scriptsDir/update-docu.sh"

function prepareNextDevCycle() {
	if [[ -z "${1-""}" ]]; then
		returnDying "no version provided as first argument to prepare-next-dev-cycle in %s" "${BASH_SOURCE[1]}"
	fi

	version=$1
	if (($# > 1)); then
		additionalPattern=$2
	else
		# same as in release.sh, update there as well
		local -r additionalPattern="(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"
	fi
	if ! [[ "$version" =~ ^(v[0-9]+)\.([0-9]+)\.[0-9]+(-RC[0-9]+)?$ ]]; then
		returnDying "version should match vX.Y.Z(-RC...), was %s" "$version"
	fi

	echo "prepare next dev cycle for version $version"

	sneakPeekBanner -c show
	toggleSection -c main
	updateVersionReadme -v "$version-SNAPSHOT" -p "$additionalPattern"
	updateVersionScripts -v "$version-SNAPSHOT" -p "$additionalPattern" -d "$scriptsDir"

	# update docu with new version
	updateDocu

	git commit -a -m "prepare next dev cycle for $version"
}

${__SOURCED__:+return}
prepareNextDevCycle "$@"
