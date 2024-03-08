#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2168
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/gt
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        Copyright 2022 Tegonal Genossenschaft <info@tegonal.com>
#  \__/\__/\_, /\___/_//_/\_,_/_/         It is licensed under European Union Public License 1.2
#         /___/                           Please report bugs and contribute back your improvements
#                                         Version: v2.0.0
#######  Description  #############
#
#  constants intended to be sourced into a function
#
###################################

local -r versionParamPatternLong='-v'
local -r versionParamPattern="$versionParamPatternLong"
local -r versionParamDocu='The version to release in the format vX.Y.Z(-RC...)'

local -r keyParamPatternLong='key'
local -r keyParamPattern="-k|$keyParamPatternLong"
local -r keyParamDocu='The GPG private key which shall be used to sign the files'

local -r findForSigningParamPatternLong='--sign-fn'
local -r findForSigningParamPattern="$findForSigningParamPatternLong"
local -r findForSigningParamDocu='Function which is called to determine what files should be signed. It should be based find and allow to pass further arguments (we will i.a. pass -print0)'

local -r branchParamPatternLong='--branch'
local -r branchParamPattern="-b|$branchParamPatternLong"
local -r branchParamDocu='(optional) The expected branch which is currently checked out -- default: main'


local -r projectsRootDirParamPatternLong='--project-dir'
local -r projectsRootDirParamPattern="$projectsRootDirParamPatternLong"
local -r projectsRootDirParamDocu='(optional) The projects directory -- default: .'

local -r additionalPatternParamPatternLong='--pattern'
local -r additionalPatternParamPattern="-p|$additionalPatternParamPatternLong"
local -r additionalPatternParamDocu='(optional) pattern which is used in a perl command (separator /) to search & replace additional occurrences. It should define two match groups and the replace operation looks as follows: '"\\\${1}\$version\\\${2}"

local -r nextVersionParamPatternLong='--next-version'
local -r nextVersionParamPattern="-nv|$nextVersionParamPatternLong"
local -r nextVersionParamDocu='(optional) the version to use for prepare-next-dev-cycle -- default: is next minor based on version'

local -r prepareOnlyParamPatternLong='--prepare-only'
local -r prepareOnlyParamPattern="$prepareOnlyParamPatternLong"
local -r prepareOnlyParamDocu='(optional) defines whether the release shall only be prepared (i.e. no push, no tag, no prepare-next-dev-cycle) -- default: false'
