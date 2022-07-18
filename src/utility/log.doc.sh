#!/usr/bin/env bash
set -euo pipefail
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/log.sh"

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

traceAndDie "fatal error, shutting down"
# ERROR: fatal error, shutting down
#
# Stacktrace:
#    foo @ /opt/foo.sh:32:1
#    bar @ /opt/bar.sh:10:1
#    ...
# exit 1

traceAndReturnDying "fatal error, shutting down"
# ERROR: fatal error, shutting down
#
# Stacktrace:
#    foo @ /opt/foo.sh:32:1
#    bar @ /opt/bar.sh:10:1
#    ...
# return 1

printStackTrace
# Stacktrace:
#    foo @ /opt/foo.sh:32:1
#    bar @ /opt/bar.sh:10:1
#   main @ /opt/main.sh:4:1
