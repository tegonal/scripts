#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/git-utils.sh"

declare currentBranch
currentBranch=$(currentGitBranch)
echo "current git branch is: $currentBranch"

if hasGitChanges; then
	echo "do whatever you want to do..."
fi

if localGitIsAhead "main"; then
	echo "do whatever you want to do..."
elif localGitIsAhead "main" "anotherRemote"; then
	echo "do whatever you want to do..."
fi

if localGitIsBehind "main"; then
	echo "do whatever you want to do..."
elif localGitIsBehind "main"; then
	echo "do whatever you want to do..."
fi

if hasRemoteTag "v0.1.0"; then
	echo "do whatever you want to do..."
elif hasRemoteTag "v0.1.0" "anotherRemote"; then
	echo "do whatever you want to do..."
fi

echo "all existing tags on remote origin, starting from smallest to biggest version number"
remoteTagsSorted

# if you specify the name of the remote, then all additional arguments are passed to `sort` which is used internally
echo "all existing tags on remote upstream, starting from smallest to biggest version number"
remoteTagsSorted upstream -r

declare latestTag
latestTag=$(latestRemoteTag)
echo "latest tag on origin: $latestTag"
latestTag=$(latestRemoteTag upstream)
echo "latest tag on upstream: $latestTag"
latestTag=$(latestRemoteTag origin "^v1\.[0-9]+\.[0-9]+$")
echo "latest tag in the major 1.x.x series on origin without release candidates: $latestTag"
