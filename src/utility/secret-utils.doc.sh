#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/secret-utils.sh"

# stores the entered password into the variable `secret`
promptForSecret "enter your password: " secret

# retrieves a secret identified by `group` and `key` via secret-tool from the login keyring
# shellcheck disable=SC2034	# we know secret is not used, only a sample
secret="$(getSecretViaSecretTool "group" "key")"

# stores the secret identified by `group` and `key` and value `mySecret` via secret-tool into the login keyring
storeSecretViaSecretTool "group" "key" "label as shown in e.g. seahorse" "mySecret"

# stores the secret identified by `group` and `key` via secret-tool into the login keyring
# uses stdin as input (prompts for a password if there is no input)
storeSecretViaSecretTool "group" "key" "label as shown in e.g. seahorse"

# retrieves a secret identified by `group` and `key` via secret-tool from the login keyring and
# stores it in the variable password. If the secret does not exist yet, then the given prompt is used and the secret is
# stores accordingly
getSecretViaSecretToolOrPromptAndStore "group" "key" "label as shown in e.g. seahorse" "enter your password: " password
