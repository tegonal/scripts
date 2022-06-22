#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.1.0
#
#######  Description  #############
#
#  Replaces the version used in download badge(s) and in the sneak peek banner
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -e
#    declare current_dir
#    current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
#    # Assuming update-version-README.sh is in the same directory as your script
#    "$current_dir/update-version-README.sh" -v 0.1.0
#
###################################
set -e

declare -A params
declare -A help

declare version file

params[version]='-v|--version'
help[version]='the version which shall be used'

# shellcheck disable=SC2034
params[file]='-f|--file'
# shellcheck disable=SC2034
help[file]='(optional) the file where search & replace shall be done -- default: ./README.md'

declare examples
# shellcheck disable=SC2034
examples=$(cat << EOM
# update version for ./README.md
update-version-README.sh -v v0.1.0

# update version for ./docs/index.md
update-version-README.sh -v v0.1.0 -f ./docs/index.md

EOM
)

declare current_dir
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
# Assuming parse-args.sh is in the same directory as your script
source "$current_dir/../utility/parse-args.sh"

parseArguments params "$@"
# in case there are optional parameters, then fill them in here before calling checkAllArgumentsSet
if ! [ -v file ]; then file="./README.md"; fi
checkAllArgumentsSet params

echo "set version $version for Download badges and sneak peek banner in $file"

perl -0777 -i \
  -pe "s@(\[!\[Download\]\(https://img.shields.io/badge/Download-).*(-%23[0-9a-f]+\)\]\([^\)]+(?:=|/))[^\)]+\)@\${1}$version\${2}$version\)@g;" \
  -pe "s@(For instance, the \[README of )[^\]]+(\].*/tree/)[^/]+/@\${1}$version\${2}$version/@;" \
  "$file"
