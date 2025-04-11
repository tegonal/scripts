#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

source "$dir_of_tegonal_scripts/utility/source-once.sh"

sourceOnce "foo.sh"    # creates a variable named sourceOnceGuard_foo__sh which acts as guard and sources foo.sh
sourceOnce "foo.sh"    # will source nothing as sourceOnceGuard_foo__sh is already defined
unset sourceOnceGuard_foo__sh          # unsets the guard
sourceOnce "foo.sh"    # is sourced again and the guard established
# you can also use sourceAlways instead of unsetting and using sourceOnce.
sourceAlways "foo.sh"

# creates a variable named sourceOnceGuard_bar__foo__sh which acts as guard and sources bar/foo.sh
sourceOnce "bar/foo.sh"

# will source nothing, only the parent dir + file is used as identifier
# i.e. the corresponding guard is sourceOnceGuard_bar__foo__sh and thus this file is not sourced
sourceOnce "asdf/bar/foo.sh"

declare guard
guard=$(determineSourceOnceGuard "src/bar.sh")
# In case you don't want that a certain file is sourced, then you can define the guard yourself
# this will prevent that */src/bar.sh is sourced
printf -v "$guard" "%s" "true"
