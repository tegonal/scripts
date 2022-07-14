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
#  Replaces the version used in download badge(s) and in the sneak peek banner
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -eu
#    declare scriptDir
#    scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
#    # Assuming update-version-README.sh is in the same directory as your script
#    "$scriptDir/update-version-README.sh" -v 0.1.0
#
###################################
set -eu

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

	local scriptDir
	scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
	local -r scriptDir
	source "$scriptDir/../utility/parse-args.sh"

	parseArguments params "$examples" "$@"
	if ! [ -v file ]; then file="./README.md"; fi
	checkAllArgumentsSet params "$examples"

	echo "set version $version for Download badges and sneak peek banner in $file"

	perl -0777 -i \
		-pe "s@(\[!\[Download\]\(https://img.shields.io/badge/Download-).*(-%23[0-9a-f]+\)\]\([^\)]+(?:=|/))[^\)]+\)@\${1}$version\${2}$version\)@g;" \
		-pe "s@(For instance, the \[README of )[^\]]+(\].*/tree/)[^/]+/@\${1}$version\${2}$version/@;" \
		"$file"
}
updateVersionReadme "$@"
