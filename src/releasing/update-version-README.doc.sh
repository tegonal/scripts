#!/usr/bin/env bash
set -eu
declare scriptDir
scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
# Assuming update-version-README.sh is in the same directory as your script
"$scriptDir/update-version-README.sh" -v 0.1.0
