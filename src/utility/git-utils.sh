#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.12.0-SNAPSHOT
#
#######  Description  #############
#
#  utility functions for dealing with git
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -euo pipefail
#    shopt -s inherit_errexit
#    # Assumes tegonal's scripts were fetched with gget - adjust location accordingly
#    dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
#    source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
#
#    sourceOnce "$dir_of_tegonal_scripts/utility/git-utils.sh"
#
#    declare currentBranch
#    currentBranch=$(currentGitBranch)
#    echo "current git branch is: $currentBranch"
#
#    if hasGitChanges; then
#    	echo "do whatever you want to do..."
#    fi
#
#    if localGitIsAhead "main"; then
#    	echo "do whatever you want to do..."
#    elif localGitIsAhead "main" "anotherRemote"; then
#    	echo "do whatever you want to do..."
#    fi
#
#    if localGitIsBehind "main"; then
#    	echo "do whatever you want to do..."
#    elif localGitIsBehind "main"; then
#    	echo "do whatever you want to do..."
#    fi
#
#    if hasRemoteTag "v0.1.0"; then
#    	echo "do whatever you want to do..."
#    elif hasRemoteTag "v0.1.0" "anotherRemote"; then
#    	echo "do whatever you want to do..."
#    fi
#
###################################
set -euo pipefail
shopt -s inherit_errexit

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/.."
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/log.sh"

function currentGitBranch() {
	git rev-parse --abbrev-ref HEAD
}

function hasGitChanges() {
	local gitStatus
	gitStatus=$(git status --porcelain) || die "running git status --porcelain failed, see above"
	! [[ $gitStatus == "" ]]
}

function countCommits() {
	local -r from=$1
	local -r to=$2
	shift 2
	git rev-list --count "$from..$to" || die "could not count commits for $from..$to, see above"
}

function localGitIsAhead() {
	if ! (($# == 0)) && ! (($# == 1)); then
		traceAndDie "you need to pass at least the branch name to localGitIsAhead and optionally the name of the remote (defaults to origin)"
	fi
	local -r branch=$1
	local -r remote=${2-"origin"}
	local count
	count=$(countCommits "$remote/$branch" "$branch")
	! ((count == 0))
}

function localGitIsBehind() {
	if ! (($# == 0)) && ! (($# == 1)); then
		traceAndDie "you need to pass at least the branch name to localGitIsBehind and optionally the name of the remote (defaults to origin)"
	fi
	local -r branch=$1
	local -r remote=${2-"origin"}
	local count
	count=$(countCommits "$branch" "$remote/$branch")
	! ((count == 0))
}

function hasRemoteTag() {
	if ! (($# == 0)) && ! (($# == 1)); then
		traceAndDie "you need to pass at least the tag to hasRemoteTag and optionally the name of the remote (defaults to origin)"
	fi
	local -r tag=$1
	local -r remote=${2-"origin"}
	shift 1
	git ls-remote -t "$remote" | grep "$tag" >/dev/null || false
}
