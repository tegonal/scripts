#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.6.0-SNAPSHOT
#
#######  Description  #############
#
#  Updates the version which is placed before the `Description` section in bash files (line 8 in this file).
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -eu
#    declare dir_of_tegonal_scripts
#    # Assuming tegonal's scripts are in the same directory as your script
#    dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
#    "$dir_of_tegonal_scripts/releasing/update-version-scripts.sh" -v 0.1.0
#
###################################
set -eu

if ! [ -v dir_of_tegonal_scripts ]; then
	declare dir_of_tegonal_scripts
	dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/..")"
	declare -r dir_of_tegonal_scripts
fi

function updateVersionScripts() {
	source "$dir_of_tegonal_scripts/utility/parse-args.sh"

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
