#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v4.10.0-SNAPSHOT
###################################
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
unset CDPATH
export TEGONAL_SCRIPTS_VERSION='v4.10.0-SNAPSHOT'

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
	source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/releasing/prepare-files-next-dev-cycle.sh"
sourceOnce "$scriptsDir/before-pr.sh"

function prepareNextDevCycle() {
	source "$dir_of_tegonal_scripts/releasing/common-constants.source.sh" || traceAndDie "could not source common-constants.source.sh"

	# shellcheck disable=SC2034   # they seem unused but are necessary in order that parseArguments doesn't create global readonly vars
	local version projectsRootDir additionalPattern beforePrFn
	# shellcheck disable=SC2034   # is passed by name to parseArguments
	local -ra params=(
		version "$versionParamPattern" 'the version for which we prepare the dev cycle'
		projectsRootDir "$projectsRootDirParamPattern" "$projectsRootDirParamDocu"
		additionalPattern "$additionalPatternParamPattern" "is ignored as additional pattern is specified internally, still here as release-files uses this argument"
		beforePrFn "$beforePrFnParamPattern" "$beforePrFnParamDocu"
	)
	parseArguments params "" "$TEGONAL_SCRIPTS_VERSION" "$@" || return $?
	# we don't check if all args are set (and neither set default values) as we currently don't use
	# any param in here but just delegate to prepareFilesNextDevCycle.

	# similar as in release.sh, you might need to update it there as well if you change something here
	local -r additionalPattern="(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

	prepareFilesNextDevCycle --project-dir "$projectDir" "$@" -p "$additionalPattern"
}

${__SOURCED__:+return}
prepareNextDevCycle "$@"
