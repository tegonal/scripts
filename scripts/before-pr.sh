#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.13.0-SNAPSHOT
#
###################################
set -euo pipefail
shopt -s inherit_errexit

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
	declare -r scriptsDir
fi

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$scriptsDir/../src"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/checks.sh"

sourceOnce "$scriptsDir/check-in-bug-template.sh"
sourceOnce "$scriptsDir/run-shellcheck.sh"
sourceOnce "$scriptsDir/update-docu.sh"

function beforePr() {
	if checkCommandExists "shellspec" 2>/dev/null; then
		logInfo "Running shellspec..."
		shellspec
	else
		logWarning "shellspec is not installed, skipping running specs.\nConsider to install it https://github.com/shellspec/shellspec#installation"
	fi

	# using && in case this function is used in one of: if while until or left side of || &&
	# this way we still have fail fast behaviour and don't mask/hide a non-zero exit code
	checkInBugTemplate && \
	customRunShellcheck && \
	updateDocu
}

${__SOURCED__:+return}
beforePr "$@"
