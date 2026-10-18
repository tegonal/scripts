#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"

# replaces all urls matching https://github.com/tegonal/scripts/(blob|tree)/main/...
# with https://github.com/tegonal/scripts/$1/v1.5.0/... in README.md
"$dir_of_tegonal_scripts/releasing/update-ref-in-repo-urls.sh" \
	--repo-url 'https://github.com/tegonal/scripts/' \
	--from-ref main --to-ref v1.5.0

# if you use it in combination with other files, then you might want to source it instead
sourceOnce "$dir_of_tegonal_scripts/releasing/update-ref-in-repo-urls.sh"

# replaces all urls matching https://gitlab.com/foo/bar/-/(blob|tree)/v1.5.0/...
# with https://gitlab.com/foo/bar/-/$1/develop/... in README.md
updateRefInRepoUrls \
	--repo-url 'https://gitlab.com/foo/bar/' \
	--from-ref v1.5.0 --to-ref develop
