#!/usr/bin/env bash
# shellcheck disable=SC2059
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.5.0-SNAPSHOT
#
#######  Description  #############
#
#  Utility functions wrapping printf and prefixing the message with a coloured INFO, WARNING or ERROR.
#  logError writes to stderr and logWarning and logInfo to stdout
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -eu
#    declare scriptDir
#    scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
#    # Assuming log.sh is in the same directory as your script
#    source "$scriptDir/log.sh"
#
#    logInfo "hello %s\n" "world"
#    # INFO: hello world
#
#    logInfo "line %\n" 1 2 3
#    # INFO: line 1
#    # INFO: line 2
#    # INFO: line 3
#
#    logWarning "oho...\n"
#    # WARNING: oho...
#
#    logError "illegal state...\n"
#    # ERROR: illegal state...
#
###################################
set -eu

function logInfo() {
	local msg=$1
	shift
	printf "\033[0;34mINFO\033[0m: $msg" "$@"
}
function logWarning() {
	local msg=$1
	shift
	printf "\033[0;93mWARNING\033[0m: $msg" "$@"
}
function logError() {
	local msg=$1
	shift
	printf >&2 "\033[0;31mERROR\033[0m: $msg" "$@"
}
