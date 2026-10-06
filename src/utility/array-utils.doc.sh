#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"

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

# shellcheck disable=SC2034	# passed by name to arrPartitionTuples
declare -a attendees=(
	alice 30 berlin
	bob 25 zurich
	carol 41 lausanne
)
declare -a youngerThan30 olderOr30
function isYoungerThan30() {
	(($2 < 30))
}
# fills the arrays youngerThan30 and olderOr30m with the tuples from the array attendees
# based on the result of the function isYoungerThan30. The second argument defines the size of the tuples in attendees.
arrPartitionTuples attendees 3 youngerThan30 olderOr30 isYoungerThan30
declare -p youngerThan30
declare -p olderOr30

declare -a alineAndBob
# fills the array alineAndBob with the tuples from the array attendees which have either alice or bob as first
# element of the tuple where each tuple has 3 elements (defined by the second argument).
arrKeepTuplesByKey attendees 3 alice bob
declare -p alineAndBob

declare -a withoutBobAndCarol
# fills the array withoutBobAndCarol with the tuples from the array attendees which have neither bob nor carol as first
# element of the tuple where each tuple has 3 elements (defined by the second argument).
arrDropTuplesByKey attendees 3 bob carol
declare -p withoutBobAndCarol
