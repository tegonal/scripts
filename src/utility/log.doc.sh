#!/usr/bin/env bash
set -eu
declare scriptDir
scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
# Assuming log.sh is in the same directory as your script
source "$scriptDir/log.sh"

logInfo "hello %s\n" "world"
# INFO: hello world

logInfo "line %\n" 1 2 3
# INFO: line 1
# INFO: line 2
# INFO: line 3

logWarning "oho...\n"
# WARNING: oho...

logError "illegal state...\n"
# ERROR: illegal state...
