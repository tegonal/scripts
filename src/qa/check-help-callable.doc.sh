#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$scriptsDir/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"
source "$dir_of_tegonal_scripts/qa/check-help-callable.sh"

# shellcheck disable=SC2034   # is passed by name to checkHelpCallable
declare -a scripts=(
	"$scriptsDir/release.sh"
	"$scriptsDir/prepare-next-dev-cycle.sh"
)
checkHelpCallable scripts
