#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
MY_LIB_VERSION="v1.1.0"

# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/parse-commands.sh"

# command definitions where each command definition consists of two values (separated via space)
# COMMAND_NAME HELP_TEXT
# where the HELP_TEXT is optional in the sense of that you can use an empty string
# shellcheck disable=SC2034   # is passed to parseCommands by name
declare commands=(
	add 'command to add people to your list'
	config 'manage configuration'
	login ''
)

# the function which is responsible to load the corresponding file which contains the function of this particular command
function sourceCommand() {
	local -r command=$1
	shift
	sourceOnce "my-lib-$command.sh"
}

parseCommands commands "$MY_LIB_VERSION" sourceCommand my_lib_ "$@"

