#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.4.0-SNAPSHOT
#
#######  Description  #############
#
#  Shows or hides the sneak peek banner
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -e
#    declare scriptDir
#    scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
#    # Assuming sneak-peek-banner.sh is in the same directory as your script
#    "$scriptDir/sneak-peek-banner.sh" -c hide
#
###################################
set -e

declare command file
# shellcheck disable=SC2034
declare params=(
	command '-c|--command' "either 'show' or 'hide'"
	file '-f|--file' '(optional) the file where search & replace shall be done -- default: ./README.md'
)

declare examples
examples=$(
	cat <<-EOM
		# hide the sneak peek banner in ./README.md
		sneak-peek-banner.sh -c hide

		# show the sneak peek banner in ./docs/index.md
		sneak-peek-banner.sh -c show -f ./docs/index.md
	EOM
)

declare scriptDir
scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
source "$scriptDir/../utility/parse-args.sh"

parseArguments params "$examples" "$@"
if ! [ -v file ]; then file="./README.md"; fi
checkAllArgumentsSet params "$examples"

if [ "$command" == "show" ]; then
	echo "show sneak peek banner in $file"
	perl -0777 -i -pe 's/<!(---\n❗ You are taking[\S\s]+?---)>/$1/;' "$file"
elif [ "$command" == "hide" ]; then
	echo "hide sneak peek banner in $file"
	perl -0777 -i -pe 's/((?<!<!)---\n❗ You are taking[\S\s]+?---)/<!$1>/;' "$file"
else
	echo >&2 "only 'show' and 'hide' are supported as command. Following the output of calling --help"
	printHelp params help "$examples"
fi
