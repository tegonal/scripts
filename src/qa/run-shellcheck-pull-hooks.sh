#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v4.9.1
#######  Description  #############
#
#  function which analyses pull-hook.sh in the `remotes` directory of the given gt working directory.
#  runs shellcheck on each file with predefined settings i.a. sets `-s bash`
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -euo pipefail
#    shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
#    # Assumes tegonal's scripts were fetched with gt - adjust location accordingly
#    dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
#    source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
#
#    source "$dir_of_tegonal_scripts/qa/run-shellcheck-pull-hooks.sh"
#
#    # pass the working directory of gt which usually is .gt in the root of your repository
#    runShellcheckPullHooks ".gt"
#
###################################
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
unset CDPATH

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/.."
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/qa/run-shellcheck.sh"

#TODO remove file, runShellcheckPullHooks is no also in run-shellcheck.sh
function runShellcheckPullHooks() {
	logDeprecation "runShellcheckPullHooks" "please source run-shellcheck.sh instead of run-shellcheck-pull-hooks.sh -- run-shellcheck-pull-hooks.sh will be removed with v5.0.0"

	if (($# != 1)); then
		logError "Exactly one parameter needs to be passed to runShellcheckPullHooks, given \033[0;36m%s\033[0m\nFollowing a description of the parameters:" "$#"
		echo >&2 '1: gt_dir  working directory of gt'
		printStackTrace
		exit 9
	fi
	local -r gt_dir=$1

	local -r gt_remote_dir="$gt_dir/remotes/"
	logInfo "analysing $gt_remote_dir/**/pull-hook.sh"

	# shellcheck disable=SC2034   # is passed by name to runShellcheck
	local -ra dirs2=("$gt_remote_dir")
	local sourcePath="$dir_of_tegonal_scripts"
	runShellcheck dirs2 "$sourcePath" -name "pull-hook.sh"
}
