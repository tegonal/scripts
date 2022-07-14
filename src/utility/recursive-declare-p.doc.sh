#!/usr/bin/env bash
# shellcheck disable=SC2034
set -eu

declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
source "$dir_of_tegonal_scripts/utility/recursive-declare-p.sh"

declare -i tmp=1
declare -n ref1=tmp
declare -n ref2=ref1
declare -n ref3=ref2

printf "%s\n" \
	"$(set -e; recursiveDeclareP tmp)" \
	"$(set -e; recursiveDeclareP ref1)" \
	"$(set -e; recursiveDeclareP ref2)" \
	"$(set -e; recursiveDeclareP ref3)"
# declare -i tmp="1"
# declare -i tmp="1"
# declare -i tmp="1"
# declare -i tmp="1"
