#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v4.14.0-SNAPSHOT
###################################
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
unset CDPATH
export TEGONAL_SCRIPTS_VERSION='v4.14.0-SNAPSHOT'

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
	readonly scriptsDir
fi
source "$scriptsDir/dirs.source.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/release-files-template.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/array-utils.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/checks.sh"
sourceOnce "$dir_of_github_commons/gt/pull-hook-functions.sh"
sourceOnce "$scriptsDir/before-pr.sh"
sourceOnce "$scriptsDir/prepare-next-dev-cycle.sh"

function release() {
	if ! checkCommandExists "shellspec" "please install https://github.com/shellspec/shellspec#installation"; then
		die "You need to have shellspec installed if you want to create a release."
	fi

	source "$scriptsDir/params/release.params.source.sh" || traceAndDie "could not source release.params.source.sh"
	source "$scriptsDir/params/release.params-definition.source.sh" || traceAndDie "could not source release.params-definition.source.sh"
	parseArguments releaseParams "" "$TEGONAL_SCRIPTS_VERSION" "$@" || return $?
	source "$scriptsDir/params/release.default-args.source.sh" || die "could not source release.default-args.source.sh"
	exitIfNotAllArgumentsSet releaseParams "" "$TEGONAL_SCRIPTS_VERSION"

	local -a releaseFilesTemplateArgs
	addLocalVarMatchingParamNamesToArgs releaseFilesTemplateParams releaseFilesTemplateArgs

	function findScripts() {
		find "$dir_of_tegonal_scripts" -name "*.sh" -not -name "*.doc.sh" "$@"
	}

	function release_afterVersionHook() {
		source "$dir_of_tegonal_scripts/releasing/params/after-version-update-hook.params.source.sh" || traceAndDie "could not source after-version-update-hook.params.source.sh"
		source "$dir_of_tegonal_scripts/releasing/params/after-version-update-hook.params-definition.source.sh" || traceAndDie "could not source after-version-update-hook.params-definition.source.sh"
		parseArguments afterVersionHookParams "" "$TEGONAL_SCRIPTS_VERSION" "$@" || return $?
		exitIfNotAllArgumentsSet afterVersionHookParams "" "$TEGONAL_SCRIPTS_VERSION"

		# same as in pull-hook.sh
		local -r githubUrl="https://github.com/tegonal/scripts"
		replaceTagInPullRequestTemplate "$projectsRootDir/.github/PULL_REQUEST_TEMPLATE.md" "$githubUrl" "$version" || die "could not fill the placeholders in PULL_REQUEST_TEMPLATE.md"
	}

	# similar as in prepare-next-dev-cycle.sh, you might need to update it there as well if you change something here
	local -r additionalPattern="(TEGONAL_SCRIPTS_(?:LATEST_)?VERSION=['\"])[^'\"]+(['\"])"

	releaseFilesTemplate \
		"${releaseFilesTemplateArgs[@]}" \
		"$projectsRootDirParamPatternLong" "$projectDir" \
		"$additionalPatternParamPatternLong" "$additionalPattern" \
		"$findForSigningParamPatternLong" findScripts \
		"$afterVersionUpdateHookParamPatternLong" release_afterVersionHook
}

${__SOURCED__:+return}
release "$@"
