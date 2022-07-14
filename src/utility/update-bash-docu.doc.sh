#!/usr/bin/env bash
set -eu

declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
source "$dir_of_tegonal_scripts/utility/update-bash-docu.sh"

find . -name "*.sh" \
	-not -name "*.doc.sh" \
	-not -path "**.history/*" \
	-not -name "update-docu.sh" \
	-print0 | while read -r -d $'\0' script
		do
			declare script="${script:2}"
			replaceSnippetForScript "$dir_of_tegonal_scripts/$script" "${script////-}" . README.md
		done
