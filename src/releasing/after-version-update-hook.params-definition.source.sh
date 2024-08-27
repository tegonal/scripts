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
# defines the parameters for afterVersionUpdateHook functions
#
###################################

# keep in sync with src/releasing/after-version-update-hook.params.source.sh
local -ra afterVersionHookParams=(
	version "$versionParamPattern" "$versionParamDocu"
	branch "$branchParamPattern" "$branchParamDocu"
	projectsRootDir "$projectsRootDirParamPattern" "$projectsRootDirParamDocu"
	additionalPattern "$additionalPatternParamPattern" "$additionalPatternParamDocu"
)
