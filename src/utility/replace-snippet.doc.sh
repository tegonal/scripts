#!/usr/bin/env bash
set -eu

# Assuming replace-snippet.sh is in the same directory as your script
scriptDir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"
source "$scriptDir/replace-snippet.sh"

declare file
file=$(mktemp)
echo "<my-script></my-script>" > "$file"

# replaceSnippet file id dir pattern snippet
replaceSnippet my-script.sh my-script-help "$(dirname "$file")" "$(basename "$file")" "$(echo "replace with your command" | grep "command")"

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
