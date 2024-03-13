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
#    # 1. git commit all changes and create a tag for v0.1.0
#    # 2. call prepareNextDevCycle with nextVersion deduced from the specified version (in this case 0.2.0-SNAPSHOT)
#    # 3. git commit all changes as prepare v0.2.0 dev cycle
#    # 4. push tag and commits
#    "$dir_of_tegonal_scripts/releasing/release-tag-prepare-next-push.sh" -v v0.1.0
#
#    # 1. searches for additional occurrences where the version should be replaced via the specified pattern
#    # 2. git commit all changes and create a tag for v0.1.0
#    # 3. call prepareNextDevCycle with nextVersion deduced from the specified version (in this case 0.2.0-SNAPSHOT)
#    # 4. git commit all changes as prepare v0.2.0 dev cycle
#    # 4. push tag and commits
#    "$dir_of_tegonal_scripts/releasing/release-tag-prepare-next-push.sh" \
#    	-v v0.1.0 -k "0x945FE615904E5C85" \
#    	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"
#
#    # in case you want to provide your own release.sh and only want to do some pre-configuration
#    # then you might want to source it instead
#    sourceOnce "$dir_of_tegonal_scripts/releasing/release-tag-prepare-next-push.sh"
#
#    # and then call the function with your pre-configuration settings:
#    # here we pre-define the additional pattern which shall be used in the search to replace the version
#    # since "$@" follows afterwards, one could still override it via command line arguments.
#    # put "$@" first, if you don't want that a user can override your pre-configuration
#    releaseTagPrepareNextAndPush -p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])" "$@"
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
sourceOnce "$dir_of_tegonal_scripts/utility/git-utils.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/gpg-utils.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/ask.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/parse-args.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/pre-release-checks-git.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/toggle-sections.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-common-steps.sh"

function releaseTagPrepareNextAndPush() {
	source "$dir_of_tegonal_scripts/releasing/common-constants.source.sh" || die "could not source common-constants.source.sh"

	local version additionalPattern nextVersion
	# shellcheck disable=SC2034   # is passed by name to parseArguments
	local -ra params=(
		version "$versionParamPattern" "$versionParamDocu"
		additionalPattern "$additionalPatternParamPattern" "$additionalPatternParamDocu"
		nextVersion "$nextVersionParamPattern" "$nextVersionParamDocu"
	)

	parseArguments params "" "$TEGONAL_SCRIPTS_VERSION" "$@"

	# deduces nextVersion based on version if not already set (and if version set)
	source "$dir_of_tegonal_scripts/releasing/deduce-next-version.source.sh"
	if ! [[ -v additionalPattern ]]; then additionalPattern="^$"; fi
	exitIfNotAllArgumentsSet params "" "$TEGONAL_SCRIPTS_VERSION"

	git add . || return $?
	git commit -m "$version" || return $?
	git tag "$version" || return $?

	prepareNextDevCycle -v "$nextVersion" -p "$additionalPattern" || die "could not prepare next dev cycle for version %s" "$nextVersion"

	git push origin "$version" || die "could not push tag %s to origin" "$version"
	git push || die "could not push commits"
}

${__SOURCED__:+return}
releaseTagPrepareNextAndPush "$@"
