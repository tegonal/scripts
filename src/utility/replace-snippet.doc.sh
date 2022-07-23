#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/replace-snippet.sh"

declare file
file=$(mktemp)
echo "<my-script></my-script>" > "$file"

declare dir fileName output
dir=$(dirname "$file")
fileName=$(basename "$file")
output=$(echo "replace with your command" | grep "command")

# replaceSnippet file id dir pattern snippet
replaceSnippet my-script.sh my-script-help "$dir" "$fileName" "$output"

echo "content"
cat "$file"

# will search for <my-script-help>...</my-script-help> in the temp file and replace it with
# <my-script-help>
#
# <!-- auto-generated, do not modify here but in my-snippet -->
# ```
# output of executing $(myCommand)
# ```
# </my-script-help>
