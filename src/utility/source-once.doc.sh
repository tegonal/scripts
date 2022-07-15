#!/usr/bin/env bash
set -eu

declare dir_of_tegonal_scripts
# Assuming tegonal's scripts are in the same directory as your script
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
source "$dir_of_tegonal_scripts/utility/source-once.sh"

sourceOnce "foo.sh"    # creates a variable named foo__sh which acts as guard and sources foo.sh
sourceOnce "foo.sh"    # will source nothing as foo__sh is already defined
unset foo__sh          # unsets the guard
sourceOnce "foo.sh"    # is sourced again and the guard established



# creates a variable named bar__foo__sh which acts as guard and sources bar/foo.sh
sourceOnce "bar/foo.sh"

# will source nothing, only the parent dir + file is used as identifier
# i.e. the corresponding guard is bar__foo__sh and thus this file is not sourced
sourceOnce "asdf/bar/foo.sh"
