#!/usr/bin/env bash
set -eu
declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
source "$dir_of_tegonal_scripts/utility/log.sh"

logInfo "hello %s\n" "world"
# INFO: hello world

logInfo "line %s\n" 1 2 3
# INFO: line 1
# INFO: line 2
# INFO: line 3

logWarning "oho...\n"
# WARNING: oho...

logError "illegal state...\n"
# ERROR: illegal state...

seconds=54
logSuccess "import finished in %s seconds\n" "$seconds"
# SUCCESS: import finished in 54 seconds
