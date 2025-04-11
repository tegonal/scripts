#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/ask.sh"

if askYesOrNo "shall I say hello"; then
	echo "hello"
fi

function noAnswerCallback {
	echo "hm... no answer, I am sad :("
}
timeoutInSeconds=30
readArgs='' # i.e. no additional args passed to read
answer='default value used if there is no answer'
askWithTimeout "some question" "$timeoutInSeconds" noAnswerCallback answer "$readArgs"
echo "$answer"
