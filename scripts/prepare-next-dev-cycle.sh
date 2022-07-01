#!/usr/bin/env bash
set -e

if [[ -z "$1" ]]; then
  echo >&2 "no version provided"
  exit 1
fi

version=$1
if ! [[ "$version" =~ ^(v[0-9]+)\.([0-9]+)\.[0-9]+(-RC[0-9]+)?$ ]]; then
  printf >&2 "\033[1;31mERROR\033[0m: version should match vX.Y.Z(-RC...), was %s\n" "$version"
  exit 1
fi

echo "prepare next dev cycle for version $version"

current_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"

"$current_dir/../src/releasing/sneak-peek-banner.sh" -c show
"$current_dir/../src/releasing/toggle-sections.sh" -c main
"$current_dir/../src/releasing/update-version-scripts.sh" -v "$version-SNAPSHOT"

git commit -a -m "prepare next dev cycle for $version"
