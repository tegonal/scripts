#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo "please update to bash 5, see errors above"; exit 1; }
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/ci/jelastic/jelastic-utils.sh"

# typically you would define those via secrets (GitHub) or Variables (Gitlab)
JELASTIC_LOGIN='my-user'
JELASTIC_PASSWORD='access-token'
JELASTIC_PLATFORM_URL='https://...'

# before doing anything with jelastic cli, you need to signin
# this is just a helper function you could also use jelastic_exec and pass users/authentication/signin as command
jelastic_signin "$JELASTIC_PLATFORM_URL" "$JELASTIC_LOGIN" "$JELASTIC_PASSWORD"

# generic utility which executes the jelastic_cli with the corresponding command and args but,
# in contrast to the cli, it checks whether the response contained `result: 0` or not
jelastic_exec "environment/control/redeploycontainers" --envName "test" --nodeGroup "cp" --tag "a123e2"
