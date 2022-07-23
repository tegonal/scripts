#!/usr/bin/env bash
# shellcheck disable=SC2034
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/recursive-declare-p.sh"

declare -i tmp=1
declare -n ref1=tmp
declare -n ref2=ref1
declare -n ref3=ref2

declare r0 r1 r2 r3
r0=$(recursiveDeclareP tmp)
r1=$(recursiveDeclareP ref1)
r2=$(recursiveDeclareP ref2)
r3=$(recursiveDeclareP ref3)

printf "%s\n" "$r0" "$r1" "$r2" "$r3"
# declare -i tmp="1"
# declare -i tmp="1"
# declare -i tmp="1"
# declare -i tmp="1"
