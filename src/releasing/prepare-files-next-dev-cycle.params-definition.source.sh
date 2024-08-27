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
# defines the parameters for release-files.sh
#
###################################

# shellcheck disable=SC2154   # it is assumed dir_of_tegonal_scripts is defined where this file is sourced
source "$dir_of_tegonal_scripts/releasing/release-files.params-definition.source.sh"

# keep in sync with src/releasing/release-files.params.source.sh
local -ra prepareFilesNextDevCycleParams=(
	"${releaseTemplateParams[@]:0:3}"
	key "$keyParamPattern" "$keyParamDocu"
	findForSigning "$findForSigningParamPattern" "$findForSigningParamDocu"
	"${releaseTemplateParams[@]:6}"
)
