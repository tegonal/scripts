#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
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
