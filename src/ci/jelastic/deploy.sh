#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache License 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v1.3.0-SNAPSHOT
#
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
#    # typically you would define those via secrets (GitHub) or Variables (Gitlab)
#    JELASTIC_LOGIN='my-user'
#    JELASTIC_PASSWORD='access-token'
#    JELASTIC_PLATFORM_URL='https://...'
#
#    # the label of the docker image as pushed to the docker registry configured for the environment test
#    DOCKER_IMAGE_VERSION=bebea131
#
#    # executes signin and redeploycontainers via jelastic_cli
#    "$dir_of_tegonal_scripts/ci/jelastic/deploy.sh" -l "$JELASTIC_LOGIN" -p "$JELASTIC_PASSWORD" -u "$JELASTIC_PLATFORM_URL" -e "test" -n cp -t "$DOCKER_IMAGE_VERSION"
#
#    # you can also source
#    sourceOnce "$dir_of_tegonal_scripts/ci/jelastic/deploy.sh"
#    jelastic_deploy -l "$JELASTIC_LOGIN" -p "$JELASTIC_PASSWORD" -u "$JELASTIC_PLATFORM_URL" -e "test" -n cp -t "$DOCKER_IMAGE_VERSION"
#
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH
export TEGONAL_SCRIPTS_VERSION='v1.3.0-SNAPSHOT'

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../.."
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/parse-args.sh"
sourceOnce "$dir_of_tegonal_scripts/ci/jelastic/utils.sh"

function jelastic_deploy() {
	local login password url env nodeGroup tag
	# shellcheck disable=SC2034
	local -ra params=(
		login '-l|--login' 'The user who logs in'
		password '-p|--password' 'The access token of the user'
		url '-u|--url' 'The platformUrl to the jelastic instance'
		env '-e|--env' 'The environment to use'
		nodeGroup '-n|--nodeGroup' 'The nodeGroup to use'
		tag '-t|--tag' 'The tag which shall be deployed'
	)
	parseArguments params "" "$TEGONAL_SCRIPTS_VERSION" "$@"
	exitIfNotAllArgumentsSet params "" "$TEGONAL_SCRIPTS_VERSION"

	jelastic_signin "$url" "$login" "$password" || die "could not login to jelastic instance"

	echo "deploying $tag to env '$env' and nodeGroup '$nodeGroup' ..."
	jelastic_exec "environment/control/redeploycontainers" \
		--envName "$env" --nodeGroup "$nodeGroup" --tag "$tag" > /dev/null || returnDying "deploy failed" || return $?

	logSuccess "deployment finished"
}

${__SOURCED__:+return}
jelastic_deploy "$@"
