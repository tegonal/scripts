#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

# 1. git commit all changes and create a tag for v0.1.0
# 2. call scripts/prepare-next-dev-cycle.sh with nextVersion deduced from the specified version (in this case 0.2.0-SNAPSHOT)
# 3. git commit all changes as prepare v0.2.0 dev cycle
# 4. push tag and commits
"$dir_of_tegonal_scripts/releasing/release-tag-push-prepare-next.sh" -v v0.1.0

# 1. searches for additional occurrences where the version should be replaced via the specified pattern
# 2. git commit all changes and create a tag for v0.1.0
# 3. call scripts/prepare-next-dev-cycle.sh with nextVersion deduced from the specified version (in this case 0.2.0-SNAPSHOT)
# 4. git commit all changes as prepare v0.2.0 dev cycle
# 4. push tag and commits
"$dir_of_tegonal_scripts/releasing/release-tag-push-prepare-next.sh" \
	-v v0.1.0 -k "0x945FE615904E5C85" \
	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

# in case you want to provide your own release.sh and only want to do some pre-configuration
# then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/release-tag-push-prepare-next.sh"

# and then call the function with your pre-configuration settings:
# here we pre-define the additional pattern which shall be used in the search to replace the version
# since "$@" follows afterwards, one could still override it via command line arguments.
# put "$@" first, if you don't want that a user can override your pre-configuration
releaseTagPushAndPrepareNext -p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])" "$@"
