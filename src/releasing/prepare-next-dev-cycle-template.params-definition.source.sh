#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2168
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/gt
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under European Union Public License 1.2
#         /___/                           Please report bugs and contribute back your improvements
#                                         Version: v3.2.0-SNAPSHOT
#######  Description  #############
#
# defines local variables for the parameters defined in releaseTemplateParams
#
###################################

# shellcheck disable=SC2154   # it is assumed dir_of_tegonal_scripts is defined where this file is sourced
source "$dir_of_tegonal_scripts/releasing/after-version-update-hook.params-definition.source.sh"

# kep in sync with src/releasing/release-template.params.source.sh and release-template.default-args.source.sh
local -ra prepareNextDevCycleTemplateParams=(
	version "$versionParamPattern" 'The version for which we prepare the dev cycle'
	branch "$branchParamPattern" '(optional) The branch on which we develop the next version'
	"${afterVersionHookParams[@]:9}"
	beforePrFn "$beforePrFnParamPattern" "$beforePrFnParamDocu"
	afterVersionUpdateHook "$afterVersionUpdateHookParamPattern" "$afterVersionUpdateHookParamDocu"
)
