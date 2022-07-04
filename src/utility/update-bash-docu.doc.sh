#!/usr/bin/env bash
set -e
declare current_dir
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

# Assuming update-bash-docu.sh is in the same directory as your script
source "$current_dir/update-bash-docu.sh"
find . -name "*.sh" \
	-not -name "*.doc.sh" \
	-not -path "**.history/*" \
	-not -name "update-docu.sh" \
	-print0 | while read -r -d $'\0' script
		do
			declare script="${script:2}"
			replaceSnippetForScript "$current_dir/$script" "${script////-}" . README.md
		done
