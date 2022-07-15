#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.6.0
#
#######  Description  #############
#
#  script which should be sourced and sets up variables and functions for the scripts
#
#######  Usage  ###################
#
###################################

if ! (($# == 1)); then
	printf >&2 "\033[0;31mERROR\033[0m: You need to pass the path to the tegonal scripts directory as first argument. Following an example\n"
	echo >&2 "source \"\$dir_of_tegonal_scripts/setup.sh\" \"\$dir_of_tegonal_scripts\""
	exit
fi

declare -r dir_of_tegonal_scripts="$1"
source "$dir_of_tegonal_scripts/utility/source-once.sh"
