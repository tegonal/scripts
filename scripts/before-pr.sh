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

if [ -x "$(command -v "shellspec")" ]; then
  shellspec
else
  printf "\033[1;33mWarning\033[0m: shellspec is not installed, skipping tests\n"
fi

"$current_dir/run-shellcheck.sh"
"$current_dir/check-in-bug-template.sh"
"$current_dir/update-docu.sh"
