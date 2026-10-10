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
shopt -s inherit_errexit
unset CDPATH
TEGONAL_SCRIPTS_LATEST_VERSION="v4.13.0"

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../../../scripts"
	readonly scriptsDir
fi
source "$scriptsDir/dirs.source.sh"
sourceOnce "$dir_of_github_commons/gt/pull-hook-functions.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/parse-fn-args.sh"

function pull_hook_before() {
	local _currentTag _tag source _target
	# shellcheck disable=SC2034   # is passed to parseFnArgs by name
	local -ra params=(_currentTag _tag source _target)
	parseFnArgs params "$@" || return $?

	replaceTegonalGhCommonsPlaceholders_Tegonal "$source" "tegonal-scripts" "$TEGONAL_SCRIPTS_LATEST_VERSION" "scripts"
}
pull_hook_before "$@"
