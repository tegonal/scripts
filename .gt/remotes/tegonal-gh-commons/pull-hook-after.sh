#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v4.14.0-SNAPSHOT
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../../../scripts"
	readonly scriptsDir
fi
source "$scriptsDir/dirs.source.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/parse-fn-args.sh"

function pull_hook_after() {
	local _currentTag _tag source target
	# shellcheck disable=SC2034   # is passed to parseFnArgs by name
	local -ra params=(_currentTag _tag source target)
	parseFnArgs params "$@" || return $?

	if [[ $source =~ .*/src/gt/signing-key.public.asc.actual_sig ]]; then
		mv "$target" "$(dirname "$target")/signing-key.public.asc.sig"
	fi
}
pull_hook_after "$@"
