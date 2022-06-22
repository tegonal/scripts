#!/usr/bin/env bash
set -e
declare current_dir
current_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
# Assuming update-version-scripts.sh is in the same directory as your script
"$current_dir/update-version-scripts.sh" -v 0.1.0

