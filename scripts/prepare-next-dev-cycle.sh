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

source "$dir_of_tegonal_scripts/utility/log.sh"

if ! [[ -v "$1" ]]; then
	die "no version provided as first argument"
fi

version=$1
if ! [[ "$version" =~ ^(v[0-9]+)\.([0-9]+)\.[0-9]+(-RC[0-9]+)?$ ]]; then
	die "version should match vX.Y.Z(-RC...), was %s" "$version"
fi

echo "prepare next dev cycle for version $version"

"$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh" -c show
"$dir_of_tegonal_scripts/releasing/toggle-sections.sh" -c main
"$dir_of_tegonal_scripts/releasing/update-version-scripts.sh" -v "$version-SNAPSHOT"

git commit -a -m "prepare next dev cycle for $version"
