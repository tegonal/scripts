#!/usr/bin/env bash
set -eu
declare scriptDir
scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
# Assuming sneak-peek-banner.sh is in the same directory as your script
"$scriptDir/sneak-peek-banner.sh" -c hide
