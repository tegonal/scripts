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

if ! [ -v scriptDir ]; then
	declare scriptDir
	scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
	declare -r scriptDir
fi

if ! [ -v dir_of_tegonal_scripts ]; then
	declare dir_of_tegonal_scripts
	dir_of_tegonal_scripts="$(realpath "$scriptDir/../src")"
	declare -r dir_of_tegonal_scripts
fi

source "$dir_of_tegonal_scripts/utility/log.sh"

declare foundIssues=false
while read -r -d $'\0' script; do
	declare output=
	output=$(shellcheck -C -s bash -S info -x -o all -e SC2312 -P "$scriptDir/../src/" "$script" || true)
	if ! [ "$output" == "" ]; then
		printf "%s\n" "$output"
		foundIssues=true
	fi
done < <(find "$scriptDir/../src" "$scriptDir/../scripts" "$scriptDir/../spec" -name '*.sh' -print0)

if [ "$foundIssues" == true ]; then
	die "found shellcheck issues, aborting"
fi
