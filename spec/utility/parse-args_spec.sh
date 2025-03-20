# shellcheck shell=bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache License 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#
###################################

Describe 'parse-arg.sh'
	Include src/utility/parse-args.sh

	Describe 'parseArguments'
		Describe '--help'
			It 'without examples'
				# shellcheck disable=SC2034	# withoutHelp is never used but that's fine
				declare version withoutHelp
				declare params=(
					version -v 'The version'
					withoutHelp -wv ''
				)
				When call parseArguments params '' 'v1.0.0' --help
				The status should be successful
				The output should include 'Parameters'
				The output should include '-v'
				The output should include 'The version'
				The output should include '-wv'
				The output should include 'Version of evaluation.sh'
				The output should not include 'Examples'
			End
			It 'with examples'
				declare version
				declare params=(version -v 'The version')
				When call parseArguments params "example code\non multiple lines" 'v1.0.0' --help
				The status should be successful
				The output should include 'Parameters'
				The output should include '-v'
				The output should include 'The version'
				The output should include 'example code'
				The output should include 'on multiple lines'
			End
		End
		It '--version'
			declare version
			declare params=(version -v 'The version')
			When call parseArguments params "example code\non multiple lines" "v1.2.0-RC2" --version
			The status should be successful
			The output should include 'v1.2.0-RC2'
		End
		Describe 'happy cases'
			It 'does not fail if not for all parameters an argument is passed'
					declare version asdf
					declare params=(
						version -v ''
						asdf -a ''
					)
					When call parseArguments params 'example' 'v1.0.0' -v v0.1.0
					The status should be successful
					The variable version should equal "v0.1.0"
			End
			It 'does not pollute parent "scope"'
				function foo() {
					# shellcheck disable=SC2034	# asdf is not used but that's fine
					declare version asdf
					declare params=(
						version -v ''
						asdf -a ''
					)
					parseArguments params 'example' 'v1.0.0' -v v0.1.0
					echo "Version: $version"
				}
				When call foo
				The variable version should be undefined
				The output should equal "Version: v0.1.0"
			End
		End
		Describe 'errors'
			It 'not enough arguments passed'
				declare version
				declare params=(version -v '')
				When run parseArguments params
				The status should be failure
				The stderr should include 'At least three arguments need to be passed to parseArguments'
			End
			Describe 'wrong number in params'
				It 'one leftover'
					declare version
					declare params=(version -v '' leftOver1)
					When run parseArguments params '' 'v1.0.0'--help
					The status should be failure
					The stderr should include "$(printf "array \033[0;36mparams\033[0m is broken")"
					The stderr should include 'The first argument to parse_args_exitIfParameterDefinitionIsNotTriple needs to be an array with 3-tuples containing parameter definitions'
					The stderr should include 'The array needs to contain parameter definitions'
					The stderr should not include 'the first argument needs to be a non-associative array'
					The stderr should include 'leftOver1'
				End
				It 'two leftovers'
					declare version
					declare params=(version -v '' leftOver1 leftOver2)
					When run parseArguments params '' 'v1.0.0' --help
					The status should be failure
					The stderr should include "$(printf "array \033[0;36mparams\033[0m is broken")"
					The stderr should include 'The first argument to parse_args_exitIfParameterDefinitionIsNotTriple needs to be an array with 3-tuples containing parameter definitions'
					The stderr should include 'The array needs to contain parameter definitions'
					The stderr should include 'leftOver1'
					The stderr should include 'leftOver2'
				End
			End
			It 'associative array passed'
				# shellcheck disable=SC2034   # is passed by name to parseArguments
				declare -A associativeParams=([version]=-v)
				When run parseArguments associativeParams '' 'v1.0.0' --help
				The status should be failure
				The stderr should include "$(printf "array \033[0;36massociativeParams\033[0m is broken")"
				The stderr should include 'The first argument to parse_args_exitIfParameterDefinitionIsNotTriple needs to be a non-associative array containing parameter definitions'
			End
			It 'fails if variable not defined in scope'
				declare version
				declare params=(
					version -v ''
					asdf -a ''
				)
				When run parseArguments params 'example' 'v1.0.0' -v v0.1.0
				The status should be failure
				The stderr should include "$(printf "you need to \`declare\` (\`local\`) the variable \033[0;36masdf\033[0m")"
			End
		End
	End

	Describe 'exitIfNotAllArgumentsSet'
			Describe 'happy cases'
				It 'complains if not all variables are set'
					declare params=(version -v '')
					When run exitIfNotAllArgumentsSet params '' 'v1.0.0'
					The status should be failure
					The stderr should include 'version not set'
					The stderr should include 'Parameters:'
					The stderr should include '-v'
				End
			End
			Describe 'errors'
				It 'not enough arguments passed'
					declare params=(version -v '')
					When run exitIfNotAllArgumentsSet params
					The status should be failure
					The stderr should include 'Three arguments need to be passed to exitIfNotAllArgumentsSet'
				End
				Describe 'wrong number in params'
					It 'one leftover'
						declare params=(version -v '' leftOver1)
						When run exitIfNotAllArgumentsSet params '' 'v1.0.0'
						The status should be failure
						The stderr should include 'leftOver1'
					End
					It 'two leftovers'
						# shellcheck disable=SC2034   # is passed by name to exitIfNotAllArgumentsSet
						declare params=(version -v '' leftOver1 leftOver2)
						When run exitIfNotAllArgumentsSet params '' 'v1.0.0'
						The status should be failure
						The stderr should include 'leftOver1'
						The stderr should include 'leftOver2'
					End
				End
			End
		End
End
