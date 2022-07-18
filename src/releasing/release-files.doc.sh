#!/usr/bin/env bash
set -euo pipefail
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

function findScripts() {
	find "src" -name "*.sh" -not -name "*.doc.sh" "$@"
}
# make the function visible to release-files.sh / not necessary if you source release-files.sh, see further below
declare -fx findScripts

# releases version v0.1.0 using the key 0x945FE615904E5C85 for signing
"$dir_of_tegonal_scripts/releasing/release-files.sh" -v v0.1.0 -k "0x945FE615904E5C85" --sign-fn findScripts

# releases version v0.1.0 using the key 0x945FE615904E5C85 for signing and
# searches for additional occurrences where the version should be replaced via the specified pattern in:
# - script files in ./src and ./scripts
# - ./README.md
"$dir_of_tegonal_scripts/releasing/release-files.sh" \
	-v v0.1.0 -k "0x945FE615904E5C85" --sign-fn findScripts \
	-p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

# in case you want to provide your own release.sh and only want to do some pre-configuration
# then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/release-files.sh"

# and then call the function with your pre-configuration settings:
# here we define the function which shall be used to find the files to be signed
# since "$@" follows afterwards, one could still override it via command line arguments.
# put "$@" first, if you don't want that a user can override your pre-configuration
releaseFiles --sign-fn findScripts "$@"
