#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/array-utils.sh"

declare regex
regex=$(joinByChar '|' my regex alternatives)
declare -a commands=(add delete list config)
regex=$(joinByChar '|' "${commands[@]}")

joinByString ', ' a list of strings and the previously defined "$regex"
declare -a names=(alwin darius fabian mike mikel robert oliver thomas)
declare employees
employees=$(joinByString ", " "${names[@]}")
echo ""
echo "Tegonal employees are currently: $employees"

function startingWithA() {
	[[ $1 == a* ]]
}
declare -a namesStartingWithA=()
arrFilter names namesStartingWithA startingWithA
declare -p namesStartingWithA

declare -a everySecondName
arrTakeEveryX names everySecondName 2 0
declare -p everySecondName
declare -a everySecondNameStartingFrom1
arrTakeEveryX names everySecondNameStartingFrom1 2 1
declare -p everySecondNameStartingFrom1

arrStringEntryMaxLength names # 6
