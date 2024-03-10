#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v2.1.0-SNAPSHOT
#######  Description  #############
#
#  prepare the next dev cycle for files based on conventions:
#  - expects a version in format vX.Y.Z(-RC...)
#  - main is your default branch
#  - requires you to have a /scripts folder in your project root which contains:
#    - before-pr.sh which provides function beforePr and updateDocu and can be sourced (add ${__SOURCED__:+return} before executing beforePr)
#
#  You can define a /scripts/additional-prepare-files-next-dev-cycle-steps.sh which is sourced (via sourceOnce) if it exists
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -euo pipefail
#    shopt -s inherit_errexit
#    # Assumes tegonal's scripts were fetched with gt - adjust location accordingly
#    dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
#    source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
#
#    # prepare dev cycle for version v0.2.0
#    "$dir_of_tegonal_scripts/releasing/prepare-files-next-dev-cycle.sh" -v v0.2.0
#
#    # prepare dev cycle for version v0.2.0 and
#    # searches for additional occurrences where the version should be replaced via the specified pattern in:
#    # - script files in ./src and ./scripts
#    # - ./README.md
#    "$dir_of_tegonal_scripts/releasing/prepare-files-next-dev-cycle.sh" -v v0.2.0 \
#    	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"
#
#    # in case you want to provide your own release.sh and only want to do some pre-configuration
#    # then you might want to source it instead
#    sourceOnce "$dir_of_tegonal_scripts/releasing/prepare-files-next-dev-cycle.sh"
#
#    # and then call the function with your pre-configuration settings:
#    # here we define the pattern which shall be used to replace further version occurrences
#    # since "$@" follows afterwards, one could still override it via command line arguments.
#    # put "$@" first, if you don't want that a user can override your pre-configuration
#    prepareNextDevCycle -p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])" "$@"
#
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH
export TEGONAL_SCRIPTS_VERSION='v2.1.0-SNAPSHOT'

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/.."
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/parse-args.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-common-steps.sh"

function prepareFilesNextDevCycle() {
	local versionRegex versionParamPatternLong projectsRootDirParamPatternLong
	local additionalPatternParamPatternLong forReleaseParamPatternLong
	source "$dir_of_tegonal_scripts/releasing/common-constants.source.sh" || die "could not source common-constants.source.sh"

	local version projectsRootDir additionalPattern
	# shellcheck disable=SC2034   # is passed by name to parseArguments
	local -ra params=(
		version "$versionParamPattern" 'the version for which we prepare the dev cycle'
		projectsRootDir "$projectsRootDirParamPattern" "$projectsRootDirParamDocu"
		additionalPattern "$additionalPatternParamPattern" "$additionalPatternParamDocu"
	)
	parseArguments params "" "$TEGONAL_SCRIPTS_VERSION" "$@"
	if ! [[ -v projectsRootDir ]]; then projectsRootDir=$(realpath ".") || die "could not determine realpath of ."; fi
	if ! [[ -v additionalPattern ]]; then additionalPattern="^$"; fi
	exitIfNotAllArgumentsSet params "" "$TEGONAL_SCRIPTS_VERSION"

	if ! [[ "$version" =~ $versionRegex ]]; then
		die "version should match vX.Y.Z(-RC...), was %s" "$version"
	fi

	exitIfGitHasChanges

	logInfo "prepare next dev cycle for version $version"

	local -r projectsScriptsDir="$projectsRootDir/scripts"
	local -r devVersion="$version-SNAPSHOT"

	updateVersionCommonSteps \
		"$forReleaseParamPatternLong" false \
		"$versionParamPatternLong" "$devVersion" \
		"$projectsRootDirParamPatternLong" "$projectsRootDir" \
		"$additionalPatternParamPatternLong" "$additionalPattern"

	local -r additionalSteps="$projectsScriptsDir/additional-prepare-files-next-dev-cycle-steps.sh"
	if [[ -f $additionalSteps ]]; then
		logInfo "found $additionalSteps going to source it"
		# shellcheck disable=SC2310			# we are aware of that || will disable set -e for sourceOnce
		sourceOnce "$additionalSteps" || die "could not source $additionalSteps"
	fi

	# shellcheck disable=SC2310			# we are aware of that || will disable set -e for sourceOnce
	sourceOnce "$projectsScriptsDir/before-pr.sh" || die "could not source before-pr.sh"

	# check if we accidentally have broken something, run formatting or whatever is done in beforePr
	beforePr || return $?

	git commit -a -m "prepare next dev cycle for $version"
}

${__SOURCED__:+return}
prepareFilesNextDevCycle "$@"
