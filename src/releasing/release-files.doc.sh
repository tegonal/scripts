#!/usr/bin/env bash
set -eu
# Assuming tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

# releases version v0.1.0 using the key 0x945FE615904E5C85 for signing
"$dir_of_tegonal_scripts/releasing/release-files.sh" -v v0.1.0 -k "0x945FE615904E5C85"

# releases version v0.1.0 using the key 0x945FE615904E5C85 for signing and
# searches for additional occurrences of the version via the specified pattern in:
# - script files in ./src and ./scripts
# - ./README.md
"$dir_of_tegonal_scripts/releasing/release-files.sh" \
	-v v0.1.0 -k "0x945FE615904E5C85" -p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

