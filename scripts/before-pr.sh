#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v3.5.0-SNAPSHOT
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
	readonly scriptsDir
fi

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$scriptsDir/../src"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/checks.sh"

sourceOnce "$scriptsDir/check-in-bug-template.sh"
sourceOnce "$scriptsDir/cleanup-on-push-to-main.sh"
sourceOnce "$scriptsDir/run-shellcheck.sh"

function beforePr() {
	if checkCommandExists "shellspec" 2>/dev/null; then
		logInfo "Running shellspec..."
		shellspec
	else
		logWarning "shellspec is not installed, skipping running specs.\nConsider to install it https://github.com/shellspec/shellspec#installation"
	fi

	# using && because this function is used on the left side of an || in releaseFiles
	# this way we still have fail fast behaviour and don't mask/hide a non-zero exit code
	checkInBugTemplate && \
	customRunShellcheck && \
	cleanupOnPushToMain
}

${__SOURCED__:+return}
beforePr "$@"
