#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#
#
set -eu

if ! [ -v dir_of_tegonal_scripts ]; then
	declare dir_of_tegonal_scripts
	dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../src")"
	declare -r dir_of_tegonal_scripts
fi

source "$dir_of_tegonal_scripts/utility/update-bash-docu.sh"
source "$dir_of_tegonal_scripts/utility/replace-help-snippet.sh"

declare projectDir
projectDir="$(realpath "$dir_of_tegonal_scripts/../")"

find "$dir_of_tegonal_scripts" -name "*.sh" \
	-not -name "*.doc.sh" \
	-print0 |
	while read -r -d $'\0' script; do
		declare relative
		relative="$(realpath --relative-to="$projectDir" "$script")"
		declare id="${relative:4:-3}"

		updateBashDocumentation "$script" "${id////-}" . README.md
	done

declare executableScripts=(
	releasing/sneak-peek-banner
	releasing/toggle-sections
	releasing/update-version-README
	releasing/update-version-scripts
)

for script in "${executableScripts[@]}"; do
	replaceHelpSnippet "$dir_of_tegonal_scripts/$script.sh" "${script////-}-help" . README.md
done
