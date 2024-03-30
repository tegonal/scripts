#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v3.2.0-SNAPSHOT
#######  Description  #############
#
#  function which helps deploying an image to a jelastic instance
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -euo pipefail
#    shopt -s inherit_errexit
#    # Assumes tegonal's scripts were fetched with gt - adjust location accordingly
#    dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
#    source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
#
#    sourceOnce "$dir_of_tegonal_scripts/ci/jelastic/jelastic-utils.sh"
#
#    # typically you would define those via secrets (GitHub) or Variables (Gitlab)
#    JELASTIC_LOGIN='my-user'
#    JELASTIC_PASSWORD='access-token'
#    JELASTIC_PLATFORM_URL='https://...'
#
#    # before doing anything with jelastic cli, you need to signin
#    # this is just a helper function you could also use jelastic_exec and pass users/authentication/signin as command
#    jelastic_signin "$JELASTIC_PLATFORM_URL" "$JELASTIC_LOGIN" "$JELASTIC_PASSWORD"
#
#    # generic utility which executes the jelastic_cli with the corresponding command and args but,
#    # in contrast to the cli, it checks whether the response contained `result: 0` or not
#    jelastic_exec "environment/control/redeploycontainers" --envName "test" --nodeGroup "cp" --tag "a123e2"
#
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH
export TEGONAL_SCRIPTS_VERSION='v3.2.0-SNAPSHOT'

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../.."
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/parse-fn-args.sh"

function jelastic_exec() {
	local -r command=$1
	shift 1 || die "could not shift by 1"

	local -r jelastic_cliHome="${JELASTIC_CLI_HOME:-${HOME:-~}}/jelastic"
	if ! [[ -f "$jelastic_cliHome/$command" ]]; then
		die "looks like jelastic-cli is not installed at %s or $command does no longer exist" "$jelastic_cliHome"
	fi

	local response
	response=$("$jelastic_cliHome/$command" "$@") || returnDying "executing %s, see above" "$command" || return $?
	local -r expected="\"result\": 0"
	if ! grep -q "$expected" <<<"$response"; then
		returnDying "could not find \033[0;36m\"%s\033[0m in the response, was:\n%s" "$expected" "$response"
	else
		echo "jelastic response:"
		echo "$response"
	fi
}

function jelastic_signin() {
	local url login password
	# params is required for parseFnArgs thus:
	# shellcheck disable=SC2034
	local -ra params=(url login password)
	parseFnArgs params "$@"

	echo "Signing in..."
	jelastic_exec "users/authentication/signin" --login "$login" --password "$password" --platformUrl "$url" >/dev/null
	logSuccess "signed in"
}
