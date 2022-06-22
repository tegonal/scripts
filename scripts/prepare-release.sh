#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#
#
set -e

if [[ -z "$1" ]]; then
  echo >&2 "no version provided"
  exit 1
fi

version=$1
echo "prepare release for version $version"

declare current_dir
current_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"

# make sure documentation is up-to-date etc.
"$current_dir/update-docu.sh"

"$current_dir/../src/releasing/sneak-peek-banner.sh" -c hide
"$current_dir/../src/releasing/toggle-sections" -v release
"$current_dir/../src/releasing/update-version-README.sh" -v "$version"
"$current_dir/../src/releasing/update-version-scripts.sh" -v "$version"

