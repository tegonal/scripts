#!/usr/bin/env bash

# Assuming replace-help-snippet.sh is in the same directory as your script
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"
source "$current_dir/replace-help-snippet.sh"

declare file
file=$(mktemp)
echo "<my-script-help></my-script-help>" > "$file"

# replaceSnippet file id dir pattern snippet
replaceSnippet my-script.sh my-script-help "$(dirname "$file")" "$(basename "$file")"

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
