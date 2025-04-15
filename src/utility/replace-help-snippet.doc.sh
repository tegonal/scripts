#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/replace-help-snippet.sh"

declare file
file=$(mktemp)
echo "<my-script-help></my-script-help>" > "$file"

# replaceHelpSnippet script id dir pattern
replaceHelpSnippet my-script.sh my-script-help "$(dirname "$file")" "$(basename "$file")"

echo "content"
cat "$file"

# will search for <my-script-help>...</my-script-help> in the temp file and replace it with the output of calling `my-script.sh --help`
# <my-script-help>
#
# <!-- auto-generated, do not modify here but in my-snippet -->
# ```
# output of executing $(my-script.sh --help)
# ```
# </my-script-help>
