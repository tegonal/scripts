#!/usr/bin/env bash
set -eu

declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
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
