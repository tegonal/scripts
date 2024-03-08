#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v1.4.0-SNAPSHOT
#######  Description  #############
#
#  Releasing files based on conventions:
#  - expects a version in format vX.Y.Z(-RC...)
#  - main is your default branch
#  - requires you to have a /scripts folder in your project root which contains:
#    - before-pr.sh which provides a parameterless function beforePr and can be sourced (add ${__SOURCED__:+return} before executing beforePr)
#    - prepare-next-dev-cycle.sh which provides function prepareNextDevCycle and can be sourced
#  - there is a public key defined at .gt/signing-key.public.asc which will be used
#    to verify the signatures which will be created
#
#  You can define /scripts/additional-release-files-preparations.sh which is sourced (via sourceOnce) if it exists.
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
#    # updates the version in headers of different files
#    "$dir_of_tegonal_scripts/releasing/update-version-common-steps.sh" -v v0.1.0
#
#    # 1. searches for additional occurrences where the version should be replaced via the specified pattern
#    # 2. git commit all changes and create a tag for v0.1.0
#    # 3. call scripts/prepare-next-dev-cycle.sh with nextVersion deduced from the specified version (in this case 0.2.0-SNAPSHOT)
#    # 4. git commit all changes as prepare v0.2.0 dev cycle
#    # 5. push tag and commits
#    # 6. releases version v0.1.0 using the key 0x945FE615904E5C85 for signing and
#    "$dir_of_tegonal_scripts/releasing/update-version-common-steps.sh" \
#    	-v v0.1.0 -k "0x945FE615904E5C85" \
#    	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"
#
#    # in case you want to provide your own release.sh and only want to do some pre-configuration
#    # then you might want to source it instead
#    sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-common-steps.sh"
#
#    # and then call the function with your pre-configuration settings:
#    # here we pre-define the additional pattern which shall be used in the search to replace the version
#    # since "$@" follows afterwards, one could still override it via command line arguments.
#    # put "$@" first, if you don't want that a user can override your pre-configuration
#    updateVersionCommonSteps -p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])" "$@"
#
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH
export TEGONAL_SCRIPTS_VERSION='v1.4.0-SNAPSHOT'

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/.."
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/parse-args.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/toggle-sections.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-issue-templates.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-README.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-scripts.sh"

function updateVersionCommonSteps() {
	local versionParamPatternLong additionalPatternParamPatternLong
	source "$dir_of_tegonal_scripts/releasing/shared-patterns.source.sh" || die "could not source shared-patterns.source.sh"

	local version projectsRootDir additionalPattern
	# shellcheck disable=SC2034   # is passed by name to parseArguments
	local -ra params=(
		version "$versionParamPattern" "$versionParamDocu"
		projectsRootDir "$projectsRootDirParamPattern" "$projectsRootDirParamDocu"
		additionalPattern "$additionalPatternParamPattern" "$additionalPatternParamDocu"
	)
	parseArguments params "" "$TEGONAL_SCRIPTS_VERSION" "$@"

	if ! [[ -v projectsRootDir ]]; then projectsRootDir=$(realpath "."); fi
	if ! [[ -v additionalPattern ]]; then additionalPattern="^$"; fi
	exitIfNotAllArgumentsSet params "" "$TEGONAL_SCRIPTS_VERSION"

	local -r projectsScriptsDir="$projectsRootDir/scripts"

	sneakPeekBanner -c hide || return $?
	toggleSections -c release || return $?

	updateVersionReadme "$versionParamPatternLong" "$version" \
		"$additionalPatternParamPatternLong" "$additionalPattern" || return $?

	updateVersionScripts "$versionParamPatternLong" "$version" \
		"$additionalPatternParamPatternLong" "$additionalPattern" || return $?
	updateVersionScripts "$versionParamPatternLong" "$version" \
		"$additionalPatternParamPatternLong" "$additionalPattern" \
		-d "$projectsScriptsDir" || return $?

	find "$projectsRootDir/.gt" -name "pull-hook.sh" -print0 |
		while read -r -d $'\0' script; do
			updateVersionScripts "$versionParamPatternLong" "$version" \
				"$additionalPatternParamPatternLong" "$additionalPattern" \
				-d "$script"
		done

	local -r templateDir="$projectsRootDir/./.github/ISSUE_TEMPLATE"
	if [[ -d "$templateDir" ]]; then
		updateVersionIssueTemplates "$versionParamPatternLong" "$version" -d "$templateDir"
	fi
}

${__SOURCED__:+return}
updateVersionCommonSteps "$@"
