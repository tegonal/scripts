#!/usr/bin/env bash
set -eu
declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
source "$dir_of_tegonal_scripts/utility/log.sh"

logInfo "hello %s" "world"
# INFO: hello world

logInfo "line %s" 1 2 3
# INFO: line 1
# INFO: line 2
# INFO: line 3

logWarning "oho..."
# WARNING: oho...

logError "illegal state..."
# ERROR: illegal state...

seconds=54
logSuccess "import finished in %s seconds" "$seconds"
# SUCCESS: import finished in 54 seconds

die "fatal error, shutting down"
# ERROR: fatal error, shutting down
# exit 1

returnDying "fatal error, shutting down"
# ERROR: fatal error, shutting down
# return 1

# in case you don't want a newline at the end of the message, then use one of
logInfoWithoutNewline "hello"
# INFO: hello%
logWarningWithoutNewline "be careful"
logErrorWithoutNewline "oho"
logSuccessWithoutNewline "yay"
