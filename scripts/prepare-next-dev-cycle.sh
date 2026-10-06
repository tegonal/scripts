#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v4.13.0-SNAPSHOT
###################################
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
unset CDPATH
export TEGONAL_SCRIPTS_VERSION='v4.13.0-SNAPSHOT'

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
	readonly scriptsDir
fi
source "$scriptsDir/dirs.source.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/prepare-files-next-dev-cycle.sh"
sourceOnce "$scriptsDir/before-pr.sh"

function prepareNextDevCycle() {
	source "$scriptsDir/params/prepare-next-dev-cycle.params.source.sh" || traceAndDie "could not source prepare-next-dev-cycle.params.source.sh"
	source "$scriptsDir/params/prepare-next-dev-cycle.params-definition.source.sh" || traceAndDie "could not source prepare-next-dev-cycle.params-definition.source.sh"
	parseArguments prepareNextDevCycleParams "" "$TEGONAL_SCRIPTS_VERSION" "$@" || return $?
	source "$scriptsDir/params/prepare-next-dev-cycle.default-args.source.sh" || die "could not source prepare-next-dev-cycle.default-args.source.sh"
	exitIfNotAllArgumentsSet prepareNextDevCycleParams "" "$TEGONAL_SCRIPTS_VERSION"

	local -a prepareFilesNextDevCycleArgs
	addLocalVarMatchingParamNamesToArgs prepareFilesNextDevCycleParams prepareFilesNextDevCycleArgs

	# similar as in release.sh, you might need to update it there as well if you change something here
	local -r additionalPattern="(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

	prepareFilesNextDevCycle "${prepareFilesNextDevCycleArgs[@]}" \
		"$additionalPatternParamPatternLong" "$additionalPattern"
}

${__SOURCED__:+return}
prepareNextDevCycle "$@"
