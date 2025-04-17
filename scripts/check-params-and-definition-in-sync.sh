#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v3.2.0-SNAPSHOT
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH

if ! [[ -v scriptsDir ]]; then
	scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
	readonly scriptsDir
fi

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$scriptsDir/../src"
	source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"
fi

function checkParamsAndDefinitionInSync() {
	local foundErrors=0
	local numOfFiles=0

	while read -r -d $'\0' paramsFile; do
		numOfFiles=$((numOfFiles + 1))
		local definitionFile="${paramsFile//.params.source/.params-definition.source}"
		if ! [[ -f "$definitionFile" ]]; then
			((++foundErrors))
			logError "definition file %s does not exist" "$definitionFile"
			continue
		fi
		local params paramDefinitions
		params=$(grep -E "^(# )?local" "$paramsFile") || die "could not extract params from params file %s" "$paramsFile"
		paramDefinitions=$(
			awk '
    	/^local -ra .*Params=\(/ { in_array=1; next }
    	/^\)/ { in_array=0 }
    	in_array && $1 !~ /^"/ && NF { print $1 }
    	' "$definitionFile"
		) || die "could not extract parameter names from parameter definition file %s" "$definitionFile"

		for param in $params; do
			if ! [[ $param == "local" || $param == "#" ]]; then
				if ! grep "$param" <<<"$paramDefinitions" >/dev/null; then
					((++foundErrors))
					logError "could not find param \033[0;36m%s\033[0m in definition file %s" "$param" "$definitionFile"
				fi
			fi
		done
		for param in $paramDefinitions; do
			if ! grep "$param" <<<"$params" >/dev/null; then
				((++foundErrors))
				logError "could not find param \033[0;36m%s\033[0m in source file %s" "$param" "$definitionFile"
			fi
		done
	done \
		< <(
			# using find here instead of find ... | while so that we can write foundErrors
			# we cannot do this when using the pipe approach as it will use a subshell for while
			find "$dir_of_tegonal_scripts" -name "*.params.source.sh" \
				-print0 ||
				# `while read` will fail because there is no \0
				true
		)

	if [[ $foundErrors -eq 0 ]]; then
		logSuccess "%s params.source.sh files in sync with their params-definition.source.sh" "$numOfFiles"
	else
		returnDying "%s params.source.sh files are not in sync with their definition, see errors above (%s are in sync)" "$foundErrors" "$((numOfFiles - foundErrors))"
	fi
}

${__SOURCED__:+return}
checkParamsAndDefinitionInSync "$@"
