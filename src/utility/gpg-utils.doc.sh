#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
# Assumes tegonal's scripts were fetched with gget - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/gpg-utils.sh"

# import public-key.asc into gpg store located at ~/.gpg but ask for confirmation first
importGpgKey ~/.gpg ./public-key.asc --confirmation=true

# import public-key.asc into gpg store located at ~/.gpg and trust automatically
importGpgKey ~/.gpg ./public-key.asc --confirmation=false

# import public-key.asc into gpg store located at .gget/.gpg and trust automatically
importGpgKey .gget/.gpg ./public-key.asc --confirmation=false

# trust key which is identified via info@tegonal.com in gpg store located at ~/.gpg
trustGpgKey ~/.gpg info@tegonal.com
