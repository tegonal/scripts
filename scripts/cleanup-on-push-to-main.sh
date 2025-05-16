#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v4.8.1
###################################
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
unset CDPATH

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
	readonly scriptsDir
fi

if ! [[ -v projectDir ]]; then
	projectDir="$(realpath "$scriptsDir/../")"
	readonly projectDir
fi

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$scriptsDir/../src"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi

sourceOnce "$dir_of_tegonal_scripts/utility/cleanups.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/replace-help-snippet.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/update-bash-docu.sh"

function cleanupOnPushToMain() {
	removeUnusedSignatures "$projectDir"

	local script
	find "$dir_of_tegonal_scripts" -name "*.sh" \
		-not -name "*.doc.sh" \
		-not -name "*.source.sh" \
		-print0 |
		while read -r -d $'\0' script; do
			local relative
			relative="$(realpath --relative-to="$projectDir" "$script")" || return $?
			local id="${relative:4:-3}"
			updateBashDocumentation "$script" "${id////-}" . README.md || return $?
		done || die "updating bash documentation failed, see above"

	local -ra scriptsWithHelp=(
		ci/jelastic/deploy
		releasing/pre-release-checks-git
		releasing/prepare-files-next-dev-cycle
		releasing/prepare-next-dev-cycle-template
		releasing/release-files
		releasing/release-template
		releasing/sneak-peek-banner
		releasing/toggle-sections
		releasing/update-version-common-steps
		releasing/update-version-README
		releasing/update-version-scripts
		releasing/update-version-issue-templates
	)

	for script in "${scriptsWithHelp[@]}"; do
		replaceHelpSnippet "$dir_of_tegonal_scripts/$script.sh" "${script////-}-help" . README.md || returnDying "replacing help snippets failed, see above"
	done

	logSuccess "Updating bash docu and README completed"
}

${__SOURCED__:+return}
cleanupOnPushToMain "$@"
