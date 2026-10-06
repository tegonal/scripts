#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="scriptsDir/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"
source "$dir_of_tegonal_scripts/qa//check-params-and-definition-in-sync.sh"

# shellcheck disable=SC2034   # is passed by name to runShellcheck
declare -a dirs=(
	"$scriptsDir"
	"$scriptsDir/../src/releasing"
)

# check params.source.sh found in all dirs are in sync with params-definition.source.sh and
# params-definition.source.sh include the corresponding ParamsPatternLong definitions.
checkParamsAndDefinitionInSync dirs

# check params.source.sh found in all dirs are in sync with params-definition.source.sh and
# params-definition.source.sh or common-constants.source.sh include the corresponding
# ParamsPatternLong definitions.
checkParamsAndDefinitionInSync dirs "$scriptsDir/../src/releasing/common-constants.source.sh"
