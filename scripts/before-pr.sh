#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#
#
set -eu

if ! [[ -v scriptDir ]]; then
	declare scriptDir
	scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
	declare -r scriptDir
fi

if ! [[ -v dir_of_tegonal_scripts ]]; then
	declare dir_of_tegonal_scripts
	dir_of_tegonal_scripts="$(realpath "$scriptDir/../src")"
	declare -r dir_of_tegonal_scripts
fi

source "$dir_of_tegonal_scripts/utility/log.sh"

if [[ -x "$(command -v "shellspec")" ]]; then
	shellspec
else
	logWarning "shellspec is not installed, skipping running specs"
fi

"$scriptDir/check-in-bug-template.sh"
"$scriptDir/run-shellcheck.sh"
"$scriptDir/update-docu.sh"
