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
#  Replaces the version used in download badge(s) and in the sneak peek banner
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -eu
#    declare dir_of_tegonal_scripts
#    # Assuming tegonal's scripts are in the same directory as your script
#    dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
#    "$dir_of_tegonal_scripts/releasing/update-version-README.sh" -v 0.1.0
#
###################################
set -eu

if ! [[ -v dir_of_tegonal_scripts ]]; then
	declare dir_of_tegonal_scripts
	dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/..")"
	declare -r dir_of_tegonal_scripts
	source "$dir_of_tegonal_scripts/utility/source-once.sh"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/parse-args.sh"

function updateVersionReadme() {
	local version file
	# shellcheck disable=SC2034
	local -ra params=(
		version '-v|--version' 'the version which shall be used'
		file '-f|--file' '(optional) the file where search & replace shall be done -- default: ./README.md'
	)
	local -r examples=$(
		cat <<-EOM
			# update version for ./README.md
			update-version-README.sh -v v0.1.0

			# update version for ./docs/index.md
			update-version-README.sh -v v0.1.0 -f ./docs/index.md
		EOM
	)

	parseArguments params "$examples" "$@"
	if ! [[ -v file ]]; then file="./README.md"; fi
	checkAllArgumentsSet params "$examples"

	echo "set version $version for Download badges and sneak peek banner in $file"

	perl -0777 -i \
		-pe "s@(\[!\[Download\]\(https://img.shields.io/badge/Download-).*(-%23[0-9a-f]+\)\]\([^\)]+(?:=|/))[^\)]+\)@\${1}$version\${2}$version\)@g;" \
		-pe "s@(For instance, the \[README of )[^\]]+(\].*/tree/)[^/]+/@\${1}$version\${2}$version/@;" \
		"$file"
}
updateVersionReadme "$@"
