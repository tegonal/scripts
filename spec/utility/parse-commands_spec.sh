# shellcheck shell=bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache License 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#
###################################

# the function which is responsible to load the corresponding file which contains the function of this particular command
function sourceCommand() {
	local -r command=$1
	shift
	echo "would source file for command $command"
}
function my_lib_login() {
	echo "called my_lib_login"
}
function my_lib_self_update() {
	echo "called my_lib_self_updatelogin"
}

Describe 'parse-commands.sh'
	Include src/utility/parse-commands.sh

	Describe 'parseCommands'
		Describe '--help'
			It 'shows command and help text'
				declare commands=(
        	add 'command to add people to your list'
        	config 'manage configuration'
        	login ''
        )
				When call parseCommands commands "v1.0.0" sourceCommand "my_lib_" --help
				The status should be successful
				The output line 1 should include 'Commands'
				The output line 2 should include 'add'
				The output line 2 should include 'command to add people to your list'
				The output line 3 should include 'config'
				The output line 3 should include 'manage configuration'
				The output line 4 should include 'login'
				The output line 6 should include '--help'
				The output line 6 should include 'prints this help'
				The output line 7 should include '--version'
				The output line 7 should include 'prints the version of this script'
				The output line 9 should include 'Version of evaluation.sh is:'
				The output line 10 should include 'v1.0.0'
			End
		End
		It '--version'
			declare commands=(login '')
			When call parseCommands commands "v1.2.0-RC2" sourceCommand "my_lib_" --version
			The status should be successful
			The output line 1 should include 'Version of dsl.sh is:'
			The output line 2 should include '1.2.0-RC2'
		End
		Describe 'happy cases'
			It 'tries to source the corresponding file and call the function'
					declare commands=(login '')
					When call parseCommands commands "v1.2.0-RC2" sourceCommand "my_lib_" login
					The status should be successful
					The output should include 'would source file for command login'
					The output should include 'called my_lib_login'
			End
			It 'same same also if command has hyphens in it'
					declare commands=(self-update '')
					When call parseCommands commands "v1.2.0-RC2" sourceCommand "my_lib_" self-update
					The status should be successful
					The output should include 'would source file for command self-update'
					The output should include 'called my_lib_self_update'
			End
		End
		Describe 'errors'
		 	It 'errors if no command is passed and shows help'
		 		declare commands=(login '')
				When run parseCommands commands "v1.2.0-RC2" sourceCommand "my_lib_"
				The status should be failure
				The stderr should include 'no command passed to evaluation.sh'
				The stderr should include 'Commands'
				The stderr should include 'login'
		 	End
			It 'errors if non-existing command and shows help'
				# shellcheck disable=SC2034   # is passed by name to parseCommands
				declare commands=(login '')
				When run parseCommands commands "v1.2.0-RC2" sourceCommand "my_lib_" non-existing
				The status should be failure
				The stderr should include "$(printf "unknown command \033[0;36mnon-existing\033[0m")"
				The stderr should include 'Commands'
				The stderr should include 'login'
			End
			It 'errors if command differs regarding - in name'
				# shellcheck disable=SC2034   # is passed by name to parseCommands
				declare commands=(do-login '')
				When run parseCommands commands "v1.2.0-RC2" sourceCommand "my_lib_" do-lo-gin
				The status should be failure
				The stderr should include "$(printf "unknown command \033[0;36mdo-lo-gin\033[0m")"
				The stderr should include 'Commands'
				The stderr should include 'do-login'
			End
			It 'errors if command is not fully matched'
				# shellcheck disable=SC2034   # is passed by name to parseCommands
				declare commands=(
					reset ""
					update ""
					self-update "" # matches update but not self-update
				)
				When run parseCommands commands "v1.2.0-RC2" sourceCommand "my_lib_" "selfupdate"
				The status should be failure
				The stderr should include "$(printf "unknown command \033[0;36mselfupdate\033[0m")"
				The stderr line 3 should include 'Command'
				The stderr line 4 should include 'reset'
				The stderr line 5 should include 'update'
				The stderr line 6 should include 'self-update'
			End
		End
	End
End
