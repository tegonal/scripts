#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.3.0-SNAPSHOT-SNAPSHOT
#
#######  Description  #############
#
#  Shows or hides the sneak peek banner
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -e
#    declare current_dir
#    current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
#    # Assuming sneak-peek-banner.sh is in the same directory as your script
#    "$current_dir/sneak-peek-banner.sh" -c hide
#
###################################
set -e

declare -A params
declare -A help

declare command file

params[command]='-c|--command'
help[command]="either 'show' or 'hide'"

# shellcheck disable=SC2034
params[file]='-f|--file'
# shellcheck disable=SC2034
help[file]='(optional) the file where search & replace shall be done -- default: ./README.md'

declare examples
# shellcheck disable=SC2034
examples=$(cat << EOM
# hide the sneak peek banner in ./README.md
sneak-peek-banner.sh -c hide

# show the sneak peek banner in ./docs/index.md
sneak-peek-banner.sh -c show -f ./docs/index.md

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

if [ "$command" == "show" ]; then
  echo "show sneak peek banner in $file"
  perl -0777 -i -pe 's/<!(---\n❗ You are taking[\S\s]+?---)>/$1/;' "$file"
elif [  "$command" == "hide" ]; then
  echo "hide sneak peek banner in $file"
  perl -0777 -i -pe 's/((?<!<!)---\n❗ You are taking[\S\s]+?---)/<!$1>/;' "$file"
else
  echo >&2 "only 'show' and 'hide' are supported as command. Following the output of calling --help"
  printHelp params
fi


