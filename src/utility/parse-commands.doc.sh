#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
MY_LIB_VERSION="v1.1.0"

# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/parse-commands.sh"

# command definitions where each command definition consists of two values (separated via space)
# COMMAND_NAME HELP_TEXT
# where the HELP_TEXT is optional in the sense of that you can use an empty string
# shellcheck disable=SC2034   # is passed by name to parseCommands
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

# pass:
# 1. supported commands
# 2. version which shall be shown in --version and --help
# 3. source command, responsible to load the files
# 4. the prefix used for the commands. e.g. command show with prefix my_lib_ results in calling a
#    function my_lib_show if the users wants to execute command show
# 5. arguments passed to the corresponding function
parseCommands commands "$MY_LIB_VERSION" sourceCommand "my_lib_" "$@"
