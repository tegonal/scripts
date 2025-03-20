#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache License 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v4.5.0-SNAPSHOT
#
#######  Description  #############
#
#  utility functions for secret-tool
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
#    source "$dir_of_tegonal_scripts/utility/string-utils.sh"
#
#    # will output v4\.2\.0
#    escapeRegex "v4.2.0"
#
#    # useful in combination with grep which does not support literal searches:
#    # escapes to tegonal\+
#    pattern=$(escapeRegex "tegonal+")
#    grep -E "$pattern"
#
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/.."
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi

function readSecretOrPromptAndStore() {
    exitIfCommandDoesNotExist "secret-tool" "install it via 'sudo apt install libsecret-tools'"

    if ! (($# == 5)); then
        logError "readSecretOrPromptAndStore requires exactly 4 arguments, given \033[0;36m%s\033[0m\nFollowing a description of the parameters:\n" "$#"
        echo >&2 '1: group   the group in which the secret shall be stored'
        echo >&2 '2: key     the secret key'
        echo >&2 '3: label   the description of this key (will be shown in seahorse)'
        echo >&2 '4: prompt  the text used in case the secret does not yet exist'
        echo >&2 '5: outVar  variable name where the secret shall be stored'
        exit 1
    fi
    local -r readSecretOrPromptAndStore_group=$1
    local -r readSecretOrPromptAndStore_key=$2
    local -r readSecretOrPromptAndStore_label=$3
    local -r readSecretOrPromptAndStore_prompt=$4
    local -r readSecretOrPromptAndStore_outVar=$5

    exitIfVariablesNotDeclared "$readSecretOrPromptAndStore_outVar"

    local secret
    secret=$(secret-tool lookup "$readSecretOrPromptAndStore_group" "$readSecretOrPromptAndStore_key" || echo '')
    if [[ -z $secret ]]; then
        # shellcheck disable=SC2059 # we want to be able to use newline in the $prompt, hence OK
        printf "$readSecretOrPromptAndStore_prompt"
        read -r -s secret

        if [[ -z $secret ]]; then
            die "looks like you pressed ENTER too early, secret %s was not set, was %s" "$readSecretOrPromptAndStore_key" "$secret"
        fi
        printf "\n"
        echo -n "$secret" | secret-tool store --label="$readSecretOrPromptAndStore_label" "$readSecretOrPromptAndStore_group" "$readSecretOrPromptAndStore_key"
    fi
    	# that's where the black magic happens, we are assigning to global (not local to this function) variables here
    printf -v "$readSecretOrPromptAndStore_outVar" "%s" "$secret"
}
