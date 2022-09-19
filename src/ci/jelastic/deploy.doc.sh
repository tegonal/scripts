#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

# typically you would define those via secrets (GitHub) or Variables (Gitlab)
JELASTIC_LOGIN='my-user'
JELASTIC_PASSWORD='access-token'
JELASTIC_PLATFORM_URL='https://...'

# the label of the docker image as pushed to the docker registry configured for the environment test
DOCKER_IMAGE_VERSION=bebea131

# executes signin and redeploycontainers via jelastic_cli
"$dir_of_tegonal_scripts/ci/jelastic/deploy.sh" -l "$JELASTIC_LOGIN" -p "$JELASTIC_PASSWORD" -u "$JELASTIC_PLATFORM_URL" -e "test" -n cp -t "$DOCKER_IMAGE_VERSION"

# you can also source
sourceOnce "$dir_of_tegonal_scripts/ci/jelastic/deploy.sh"
jelastic_deploy -l "$JELASTIC_LOGIN" -p "$JELASTIC_PASSWORD" -u "$JELASTIC_PLATFORM_URL" -e "test" -n cp -t "$DOCKER_IMAGE_VERSION"
