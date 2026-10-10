#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2168
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under Apache License 2.0
#         /___/                           Please report bugs and contribute back your improvements
#
#                                         Version: v4.14.0-SNAPSHOT
###################################
{
	# shellcheck disable=SC2154   # it is assumed dir_of_tegonal_scripts is defined where this file is sourced
	source "$dir_of_tegonal_scripts/releasing/params/prepare-files-next-dev-cycle-template.params-definition.source.sh" ||
		traceAndDie "could not source prepare-files-next-dev-cycle-template.params-definition.source.sh"
}

local -a prepareNextDevCycle_withoutAdditionalPattern=()
arrDropTuplesByKey prepareFilesNextDevCycleTemplateParams 3 prepareNextDevCycle_withoutAdditionalPattern additionalPattern

local -ra prepareNextDevCycleParams=(
	"${prepareNextDevCycle_withoutAdditionalPattern[@]}"
	additionalPattern "$additionalPatternParamPattern" "is ignored because the function itself overwrites it, still here as release-files-template uses this argument"
)
