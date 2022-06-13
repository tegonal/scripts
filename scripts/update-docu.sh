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

declare projectDir
projectDir="$(realpath "$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )/../")";

source "$projectDir/src/utility/update-bash-docu.sh"
find ./src -name "*.sh" \
  -not -name "*.doc.sh" \
  -not -path "**.history/*" \
  -print0 | while read -r -d $'\0' script
    do
      declare id="${script:6:-3}"
      updateBashDocumentation "$projectDir/$script" "${id////-}" . README.md
    done
