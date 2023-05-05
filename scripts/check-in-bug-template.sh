#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache License 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v1.1.0-SNAPSHOT
#
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

function checkInBugTemplate() {
	local -r bugReportPath='.github/ISSUE_TEMPLATE/bug_report.yaml'

	local missingInBugTemplate
	missingInBugTemplate=$(
		find "$dir_of_tegonal_scripts" -name "*.sh" \
			-not -name "*.doc.sh" \
			-print0 |
			while read -r -d $'\0' script; do
				declare path=${script:(${#dir_of_tegonal_scripts} + 1)}
				if ! grep "$path" "$scriptsDir/../$bugReportPath" >/dev/null; then
					echo "- $path"
				fi
			done
	) || die "could not determine whether files are missing in %s or not, see above" "$bugReportPath"

	if [[ $missingInBugTemplate != "" ]]; then
		returnDying "you forgot to add the following files to %s:\n%s" "$bugReportPath" "$missingInBugTemplate"
	else
		logSuccess "all scripts are listed in the bug template"
	fi
}

${__SOURCED__:+return}
checkInBugTemplate "$@"
