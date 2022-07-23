#!/usr/bin/env bash
set -euo pipefail
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/qa/run-shellcheck.sh"

# shellcheck disable=SC2034
declare -a dirs=(
	"$dir_of_tegonal_scripts"
	"$dir_of_tegonal_scripts/../scripts"
	"$dir_of_tegonal_scripts/../spec"
)
declare sourcePath="$dir_of_tegonal_scripts"
runShellcheck dirs "$sourcePath"
