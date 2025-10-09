# spec/utility/parse-fn-args_spec.sh
# shellcheck shell=bash
#
# Tests for src/utility/parse-fn-args.sh (positional arguments parser)
#
# The parser is expected to:
#  - be sourced (Include ...)
#  - accept the NAME of an array with parameter names as first arg
#  - assign positional args to caller-declared variables
#  - optionally support "varargs" as last parameter in the params array
#  - return non-zero / print helpful messages on error
#

Describe 'parse-fn-args.sh (positional args)'
    Include "src/utility/parse-fn-args.sh"

    # Caller-declared variables expected to be set by parseFnArgs (must exist before call)
    declare command dir
    declare -a varargs=()

    # parameter arrays (pass name of these arrays to parseFnArgs)
    declare -a PARAMS_SIMPLE=(command dir)
    declare -a PARAMS_WITH_VARARGS=(command dir varargs)

    Describe 'parseFnArgs positional behavior'

        BeforeEach '{
            # Reset caller variables (simulate how a caller would declare them)
            command=""
            dir=""
            varargs=()
        }'

        Describe 'happy cases'
            It 'assigns two positional arguments to the declared variables'
                # NOTE: do NOT pass a "function name" — parseFnArgs expects only the array name and then args
                When call parseFnArgs "PARAMS_SIMPLE" "firstArg" "secondArg"
                The variable command should equal 'firstArg'
                The variable dir should equal 'secondArg'
                The status should be successful
            End

            It 'assigns varargs when last param is "varargs" in the params array'
                When call parseFnArgs "PARAMS_WITH_VARARGS" "cmd" "/tmp" "a" "b" "c"
                The variable command should equal 'cmd'
                The variable dir should equal '/tmp'
                The variable 'varargs[0]' should equal 'a'
                The variable 'varargs[1]' should equal 'b'
                The variable 'varargs[2]' should equal 'c'
                The status should be successful
            End
        End

        Describe 'error cases'
            It 'fails when not enough arguments are provided'
                When run parseFnArgs "PARAMS_SIMPLE" "onlyOneArg"
                The status should be failure
                The stderr should include "Not enough arguments"
            End

            It 'fails when more arguments are supplied than expected and no varargs declared'
                When run parseFnArgs "PARAMS_SIMPLE" "a" "b" "c"
                The status should be failure
                The stderr should include "more arguments supplied"
            End

            It 'fails when first parameter is not an array name'
                When run parseFnArgs "NOT_AN_ARRAY" "a" "b"
                The status should be failure
                # exitIfArgIsNotArray prints an "array" related message — check for that substring
                The stderr should include "array"
            End

            Describe 'missing caller declarations'
                Before '{
                    # remove declarations to simulate caller forgetting to declare variables
                    unset command dir || true
                    unset varargs || true
                }'

                It 'fails when caller did not pre-declare expected variables'
                    When run parseFnArgs "PARAMS_SIMPLE" "x" "y"
                    The status should be failure
                    # exitIfVariablesNotDeclared prints guidance mentioning 'declare' — check that substring
                    The stderr should include "declare"
                End
            End
        End
    End
End
