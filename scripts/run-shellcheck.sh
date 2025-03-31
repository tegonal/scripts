#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v4.6.0-SNAPSHOT
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
sourceOnce "$dir_of_tegonal_scripts/qa/run-shellcheck.sh"

function customRunShellcheck() {
	# shellcheck disable=SC2034   # is passed by name to runShellcheck
	local -ra dirs=(
		"$dir_of_tegonal_scripts"
		"$scriptsDir"
		"$dir_of_tegonal_scripts/../spec"
	)
	local sourcePath="$dir_of_tegonal_scripts:$scriptsDir"
	runShellcheck dirs "$sourcePath" -not -name "install-*.doc.sh"

	runShellcheckPullHooks "$scriptsDir/../.gt"
}

${__SOURCED__:+return}
customRunShellcheck "$@"
