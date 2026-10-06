#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v4.13.0-SNAPSHOT
#######  Description  #############
#
#  function which checks that params.source.sh and params-definition.source.sh are in sync
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -euo pipefail
#    shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
#    scriptsDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)"
#    # Assumes tegonal's scripts were fetched with gt - adjust location accordingly
#    dir_of_tegonal_scripts="scriptsDir/../lib/tegonal-scripts/src"
#    source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"
#    source "$dir_of_tegonal_scripts/qa//check-params-and-definition-in-sync.sh"
#
#    # shellcheck disable=SC2034   # is passed by name to runShellcheck
#    declare -a dirs=(
#    	"$scriptsDir"
#    	"$scriptsDir/../src/releasing"
#    )
#
#    # check params.source.sh found in all dirs are in sync with params-definition.source.sh and
#    # params-definition.source.sh include the corresponding ParamsPatternLong definitions.
#    checkParamsAndDefinitionInSync dirs
#
#    # check params.source.sh found in all dirs are in sync with params-definition.source.sh and
#    # params-definition.source.sh or common-constants.source.sh include the corresponding
#    # ParamsPatternLong definitions.
#    checkParamsAndDefinitionInSync dirs "$scriptsDir/../src/releasing/common-constants.source.sh"
#
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/.."
	source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/array-utils.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/checks.sh"

function checkParamsAndDefinitionInSync() {
	if (($# < 1)); then
		logError "At least one argument needs to be passed to checkParamsAndDefinitionInSync, given \033[0;36m%s\033[0m\nFollowing a description of the parameters:" "$#"
		echo >&2 '1: paths          name of array which contains paths in which *.params.source.sh files are searched'
		echo >&2 '2: ...constants   (optional) one or more paths to files which contain ParamPatternLong definitions'
		printStackTrace
		exit 9
	fi
	local -rn checkParamsAndDefinitionInSync_paths=$1
	shift 1 || traceAndDie "could not shift by 1"
	local constantsFile
	local constants=""
	if (($# >= 1)); then
		local constantsFile
		for constantsFile in "$@"; do
			constants+="$(cat "$constantsFile")"$'\n' || die "could not read $constantsFile"
		done
	fi

	exitIfArgIsNotArrayOrIsEmpty checkParamsAndDefinitionInSync_paths 1

	local path
	for path in "${checkParamsAndDefinitionInSync_paths[@]}"; do
		if ! find "$path" -maxdepth 1 -path "$path" >/dev/null; then
			die "cannot find in path %s, see above" "$path"
		fi
	done

	local -i foundErrors=0
	local -i numOfFiles=0

	logInfo "checking if params.source.sh is in sync with params-definition.source.sh"

	local paramsFile
	if ! while read -r -d $'\0' paramsFile; do
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
        	in_array && $1 !~ /^"/ && NF { print $1":"$2 }
        	' "$definitionFile"
		) || die "could not extract parameter names and patterns from parameter definition file %s" "$definitionFile"

		local param
		for param in $params; do
			[[ $param == "local" || $param == "#" ]] && continue

			if ! grep "$param" <<<"$paramDefinitions" >/dev/null; then
				((++foundErrors))
				logError "could not find param \033[0;36m%s\033[0m in definition file %s" "$param" "$definitionFile"
			fi
			local paramPatternLong="${param}ParamPatternLong"
			if ! grep -P "local -r $paramPatternLong" <<<"$constants\n$paramDefinitions" >/dev/null; then
				((++foundErrors))
				if [[ -z "$constants" ]]; then
					logError "could not find paramPatternLong definition \033[0;36mlocal -r %s\033[0m in definition file %s" "$paramPatternLong" "$definitionFile"
				else
					logError "could not find paramPatternLong definition \033[0;36mlocal -r %s\033[0m in definition file %s nor in constants file %s" "$paramPatternLong" "$definitionFile" "$constantsFile"
				fi
			fi
		done

		local paramDefinition param patternVar expectedPatternVar expectedPatternVarLong
		for paramDefinition in $paramDefinitions; do
			IFS=: read -r param patternVar <<<"$paramDefinition"
			[[ $param == "#" ]] && continue

			if ! grep "$param" <<<"$params" >/dev/null; then
				((++foundErrors))
				logError "could not find local argument \033[0;36m%s\033[0m (also not commented out) in source file %s" "$param" "$paramsFile"
			fi

			expectedPatternVar="\"\$${param}ParamPattern\""
			expectedPatternVarLong="\"\$${param}ParamPatternLong\""
			if [[ $patternVar != "$expectedPatternVar" && $patternVar != "$expectedPatternVarLong" ]]; then
				((++foundErrors))
				logError "pattern variable \033[0;36m%s\033[0m used for param \033[0;36m%s\033[0m in %s does not follow the naming convention \033[0;36m%s\033[0m or \033[0;36m%s\033[0m" \
					"$patternVar" "$param" "$definitionFile" "$expectedPatternVar" "$expectedPatternVarLong"
			fi
		done
	done < <(
		# using find here instead of find ... | while so that we can write foundErrors
		# we cannot do this when using the pipe approach as it will use a subshell for while
		find "${checkParamsAndDefinitionInSync_paths[@]}" -name '*.params.source.sh' -print0 ||
			# `while read` will fail because there is no \0
			true
	); then
		printf "\n"
		die "problem during while read or find, see above"
	fi

	if [[ $foundErrors -eq 0 ]]; then
		local checkParamsAndDefinitionInSync_paths_as_string
		checkParamsAndDefinitionInSync_paths_as_string=$(joinByChar $'\n' "${checkParamsAndDefinitionInSync_paths[@]}")
		logSuccess "%s params.source.sh files in sync with their params-definition.source.sh in paths:\n%s" "$numOfFiles" "$checkParamsAndDefinitionInSync_paths_as_string"
	else
		returnDying "%s params.source.sh files are not in sync with their params-definition.source.sh, see errors above (%s are in sync)" "$foundErrors" "$((numOfFiles - foundErrors))"
	fi
}

${__SOURCED__:+return}
checkParamsAndDefinitionInSync "$@"
