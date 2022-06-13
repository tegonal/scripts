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

declare current_dir
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

source "$current_dir/utility/update-bash-docu.sh"
find . -name "*.sh" \
  -not -name "*.doc.sh" \
  -not -path "**.history/*" \
  -not -name "update-docu.sh" \
  -print0 | while read -r -d $'\0' script
    do
      declare id="${script:2:-3}"
      replaceSnippetForScript "$current_dir/$script" "${id////-}" . README.md
    done
