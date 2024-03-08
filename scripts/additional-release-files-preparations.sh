#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v2.1.0-SNAPSHOT
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
	readonly scriptsDir
fi

if ! [[ -v projectDir ]]; then
	projectDir="$(realpath "$scriptsDir/../")"
	readonly projectDir
fi

if ! [[ -v dir_of_github_commons ]]; then
	dir_of_github_commons="$projectDir/.gt/remotes/tegonal-gh-commons/lib/src"
	readonly dir_of_github_commons
fi

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$projectDir/src"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_github_commons/gt/pull-hook-functions.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/checks.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-scripts.sh"
sourceOnce "$dir_of_tegonal_scripts/releasing/update-version-issue-templates.sh"

function additionalReleasePrepareSteps() {
	# keep in sync with local -r further below (3 lines at the time of writing)
	exitIfVarsNotAlreadySetBySource version additionalPattern
	# we help shellcheck to realise that these variables are initialised
	local -r version="$version" additionalPattern="$additionalPattern"

	# same as in pull-hook.sh
	local -r githubUrl="https://github.com/tegonal/scripts"
	replaceTagInPullRequestTemplate "$projectDir/.github/PULL_REQUEST_TEMPLATE.md" "$githubUrl" "$version" || die "could not fill the placeholders in PULL_REQUEST_TEMPLATE.md"
}
additionalReleasePrepareSteps
