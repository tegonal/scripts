#!/usr/bin/env bash
set -euo pipefail
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

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

# In case you have a cyclic dependency (a.sh sources b.sh and b.sh source a.sh),
# then you can define the guard in file a yourself (before sourcing b.sh) so that b.sh does no longer source file a
printf -v "$(set -e && determineSourceOnceGuard "src/b.sh")" "%s" "true"
