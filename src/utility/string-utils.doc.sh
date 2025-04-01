#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo "please update to bash 5, see errors above"; exit 1; }
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/string-utils.sh"

# will output v4\.2\.0
escapeRegex "v4.2.0"

# useful in combination with grep which does not support literal searches:
# escapes to tegonal\+
pattern=$(escapeRegex "tegonal+")
grep -E "$pattern"
