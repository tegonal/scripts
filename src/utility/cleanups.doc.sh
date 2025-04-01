#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo "please update to bash 5, see errors above"; exit 1; }

projectDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/.."

# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$projectDir/lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/cleanups.sh"

# e.g. in scripts/cleanup-on-push-to-main.sh
function cleanupOnPushToMain() {
	removeUnusedSignatures "$projectDir"
	logSuccess "cleanup done"
}
