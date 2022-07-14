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

if ! [ -v dir_of_tegonal_scripts ]; then
	declare dir_of_tegonal_scripts
	dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../src")"
	declare -r dir_of_tegonal_scripts
fi

source "$dir_of_tegonal_scripts/qa/run-shellcheck.sh"

# shellcheck disable=SC2034
declare -a dirs=(
	"$dir_of_tegonal_scripts"
	"$dir_of_tegonal_scripts/../scripts"
	"$dir_of_tegonal_scripts/../spec"
)
declare sourcePath="$dir_of_tegonal_scripts"
runShellcheck dirs "$sourcePath"
