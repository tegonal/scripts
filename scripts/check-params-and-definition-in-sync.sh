#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v4.14.0-SNAPSHOT
###################################
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
unset CDPATH

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
	readonly scriptsDir
fi
source "$scriptsDir/dirs.source.sh"
sourceOnce "$dir_of_tegonal_scripts/qa/check-params-and-definition-in-sync.sh"

function customCheckParamsAndDefinitionInSync() {
	# shellcheck disable=SC2034   # is passed by name to checkParamsAndDefinitionInSync
	local -ra dirs=(
		"$scriptsDir"
		"$dir_of_tegonal_scripts"
	)
	checkParamsAndDefinitionInSync dirs "$projectDir/src/releasing/common-constants.source.sh"
}

${__SOURCED__:+return}
customCheckParamsAndDefinitionInSync "$@"
