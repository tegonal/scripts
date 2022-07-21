#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.12.0-SNAPSHOT
#
###################################
set -euo pipefail

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
	declare -r scriptsDir
fi

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(realpath "$scriptsDir/../src")"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/log.sh"

function checkInBugTemplate() {
	find "$dir_of_tegonal_scripts" -name "*.sh" \
		-not -name "*.doc.sh" \
		-print0 |
		while read -r -d $'\0' script; do
			declare path=${script:(${#dir_of_tegonal_scripts} + 1)}
			grep "$path" "$scriptsDir/../.github/ISSUE_TEMPLATE/bug_report.yaml" >/dev/null || (die "you forgot to add \033[0;36m%s\033[0m to .github/ISSUE_TEMPLATE/bug_report.yaml" "$path")
		done

	logSuccess "all scripts are listed in the bug template"
}

${__SOURCED__:+return}
checkInBugTemplate "$@"

