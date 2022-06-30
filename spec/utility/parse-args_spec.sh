# shellcheck shell=bash

Describe 'parse_arg.sh'
  Include src/utility/parse-args.sh

  Describe 'parseArguments'
    Describe '--help'
      It 'without examples'
        declare params=(
          version -v 'The version'
          withoutHelp -wv ''
        )
        When run parseArguments params '' --help
        The status should be success
        The output should include 'Parameters'
        The output should include '-v'
        The output should include '-wv'
        The output should include 'The version'
        The output should not include 'Examples'
      End
      It 'with examples'
        declare params=(version -v 'The version')
        When run parseArguments params "example code\non multiple lines" --help
        The status should be success
        The output should include 'Parameters'
        The output should include '-v'
        The output should include 'The version'
        The output should include 'example code'
        The output should include 'on multiple lines'
      End
    End
    Describe 'happy cases'
      It 'does not fail if not for all parameters an argument is passed'
          declare version
          declare params=(
            version -v ''
            asdf -a ''
          )
          When call parseArguments params 'example' -v v0.1.0
          The status should be success
          The value "$version" should equal "v0.1.0"
      End
    End
    Describe 'errors'
      It 'not enough arguments passed'
        declare params=(version -v '')
        When run parseArguments params
        The status should be failure
        The stderr should include 'At least three arguments need to be passed to parseArguments'
      End
      Describe 'wrong number in params'
        It 'one leftover'
          declare params=(version -v '' leftOver1)
          When run parseArguments params '' --help
          The status should be failure
          The stderr should include 'leftOver1'
        End
        It 'two leftovers'
          declare params=(version -v '' leftOver1 leftOver2)
          When run parseArguments params '' --help
          The status should be failure
          The stderr should include 'leftOver1'
          The stderr should include 'leftOver2'
        End
      End
    End
  End

  Describe 'checkAllArgumentsSet'
      Describe 'happy cases'
        It 'complains if not all variables are set'
          declare params=(version -v '')
          When run checkAllArgumentsSet params ''
          The status should be failure
          The stderr should include 'version not set'
          The stderr should include 'Parameters:'
          The stderr should include '-v'
        End
      End
      Describe 'errors'
        It 'not enough arguments passed'
          declare params=(version -v '')
          When run checkAllArgumentsSet params
          The status should be failure
          The stderr should include 'Two arguments need to be passed to checkAllArgumentsSet'
        End
        Describe 'wrong number in params'
          It 'one leftover'
            declare params=(version -v '' leftOver1)
            When run checkAllArgumentsSet params ''
            The status should be failure
            The stderr should include 'leftOver1'
          End
          It 'two leftovers'
            # shellcheck disable=SC2034
            declare params=(version -v '' leftOver1 leftOver2)
            When run checkAllArgumentsSet params ''
            The status should be failure
            The stderr should include 'leftOver1'
            The stderr should include 'leftOver2'
          End
        End
      End
    End
End
