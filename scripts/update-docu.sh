#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.16.0-SNAPSHOT
#
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../src"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi

if ! [[ -v projectDir ]]; then
	projectDir="$(realpath "$dir_of_tegonal_scripts/../")"
	readonly projectDir
fi

sourceOnce "$dir_of_tegonal_scripts/utility/replace-help-snippet.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/update-bash-docu.sh"

function updateDocu() {
	local script
	find "$dir_of_tegonal_scripts" -name "*.sh" \
		-not -name "*.doc.sh" \
		-print0 |
		while read -r -d $'\0' script; do
			local relative
			relative="$(realpath --relative-to="$projectDir" "$script")" || return $?
			local id="${relative:4:-3}"
			updateBashDocumentation "$script" "${id////-}" . README.md || return $?
		done || die "updating bash documentation failed, see above"

	local -ra scriptsWithHelp=(
		releasing/sneak-peek-banner
		releasing/toggle-sections
		releasing/release-files
		releasing/update-version-README
		releasing/update-version-scripts
	)

	for script in "${scriptsWithHelp[@]}"; do
		replaceHelpSnippet "$dir_of_tegonal_scripts/$script.sh" "${script////-}-help" . README.md
	done || die "replacing help snippets failed, see above"

	logSuccess "Updating bash docu and README completed"
}

${__SOURCED__:+return}
updateDocu "$@"
