#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.5.0-SNAPSHOT
#
#######  Description  #############
#
#  Updates the version which is placed before the `Description` section in bash files (line 8 in this file).
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -eu
#    declare scriptDir
#    scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
#    # Assuming update-version-scripts.sh is in the same directory as your script
#    "$scriptDir/update-version-scripts.sh" -v 0.1.0
#
###################################
set -eu

declare dir_of_updateVersionScripts
dir_of_updateVersionScripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
declare -r dir_of_updateVersionScripts

function updateVersionScripts() {
	local version directory
	# shellcheck disable=SC2034
	local -ra params=(
		version '-v|--version' 'the version which shall be used'
		directory '-d|--directory' '(optional) the working directory -- default: ./src'
	)

	local -r examples=$(
		cat <<-EOM
			# update version to v0.1.0 for all *.sh in ./src and subdirectories
			update-version-scripts.sh -v v0.1.0

			# update version to v0.1.0 for all *.sh in ./scripts and subdirectories
			update-version-scripts.sh -v v0.1.0 -d ./scripts
		EOM
	)

	source "$dir_of_updateVersionScripts/../utility/parse-args.sh"

	parseArguments params "$examples" "$@"
	if ! [ -v directory ]; then directory="./src"; fi
	checkAllArgumentsSet params "$examples"

	find "$directory" -name "*.sh" \
		-print0 | while read -r -d $'\0' script; do
		perl -0777 -i \
			-pe "s/Version:.+(\n[\S\s]+?###+\s+Description)/Version: $version\$1/g;" \
			"$script"
	done
}
updateVersionScripts "$@"
