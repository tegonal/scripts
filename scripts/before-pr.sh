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

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
	readonly scriptsDir
fi

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$scriptsDir/../src"
	source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/checks.sh"
sourceOnce "$dir_of_tegonal_scripts/qa/run-shellspec-if-installed.sh"
sourceOnce "$dir_of_tegonal_scripts/qa/run-shellspec-if-installed.sh"

sourceOnce "$scriptsDir/check-in-bug-template.sh"
sourceOnce "$scriptsDir/cleanup-on-push-to-main.sh"
sourceOnce "$scriptsDir/run-shellcheck.sh"
sourceOnce "$scriptsDir/check-params-and-definition-in-sync.sh"

function beforePr() {
	runShellspecIfInstalled --jobs 2 &&
		customRunShellcheck &&
		checkParamsAndDefinitionInSync &&
		checkInBugTemplate &&
		cleanupOnPushToMain
}

${__SOURCED__:+return}
beforePr "$@"
