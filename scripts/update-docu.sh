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
shopt -s inherit_errexit

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../src"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi

if ! [[ -v projectDir ]]; then
	projectDir="$(realpath "$dir_of_tegonal_scripts/../")"
	declare -r projectDir
fi

sourceOnce "$dir_of_tegonal_scripts/utility/log.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/replace-help-snippet.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/update-bash-docu.sh"

function updateDocu() {
	find "$dir_of_tegonal_scripts" -name "*.sh" \
		-not -name "*.doc.sh" \
		-print0 |
		while read -r -d $'\0' script; do
			declare relative
			relative="$(realpath --relative-to="$projectDir" "$script")"
			declare id="${relative:4:-3}"

			updateBashDocumentation "$script" "${id////-}" . README.md
		done

	local -ra scriptsWithHelp=(
		releasing/sneak-peek-banner
		releasing/toggle-sections
		releasing/release-files
		releasing/update-version-README
		releasing/update-version-scripts
	)

	for script in "${scriptsWithHelp[@]}"; do
		replaceHelpSnippet "$dir_of_tegonal_scripts/$script.sh" "${script////-}-help" . README.md
	done

	logSuccess "Updating bash docu and README completed"
}

${__SOURCED__:+return}
updateDocu "$@"
