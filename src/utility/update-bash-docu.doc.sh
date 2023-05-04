#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/update-bash-docu.sh"

find . -name "*.sh" \
	-not -name "*.doc.sh" \
	-print0 |
	while read -r -d $'\0' script; do
		declare script="${script:2}"
		updateBashDocumentation "$dir_of_tegonal_scripts/$script" "${script////-}" . README.md
	done
