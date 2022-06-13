#!/usr/bin/env bash

declare -A params
declare -A help

# declare the variables where the arguments shall be stored (used as identifier afterwards)
declare directory pattern

# define the regex which is used to identify the argument `directory`
params[directory]='-d|--directory'
# optional: define an explanation for the argument `directory` which will show up in `--help`
help[directory]='(optional) the working directory -- default: .'

# in case you use shellcheck then you need to suppress the warning for the last variable definition of params
# as shellcheck doesn't get that we are passing `params` to parseArguments ¯\_(ツ)_/¯
# shellcheck disable=SC2034
params[pattern]='-p|--pattern'
# `help` is used implicitly in parse-args, here shellcheck cannot know it and you need to disable the rule
# shellcheck disable=SC2034
help[pattern]='pattern used during analysis'

# optional: you can define examples which are included in the help text
declare examples
# `examples` is used implicitly in parse-args, here shellcheck cannot know it and you need to disable the rule
# shellcheck disable=SC2034
examples=$(cat << EOM
# analyse in the current directory using the specified pattern
analysis.sh -p "%{21}"
EOM
)

declare current_dir
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
# Assuming parse-args.sh is in the same directory as your script
source "$current_dir/parse-args.sh"

parseArguments params "$@"
# in case there are optional parameters, then fill them in here before calling checkAllArgumentsSet
if ! [ -v directory ]; then directory="."; fi
checkAllArgumentsSet params

# pass your variables storing the arguments to other scripts
echo "d: $directory, p: $pattern"
