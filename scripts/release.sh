#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#
#
set -e

if ! [ -x "$(command -v "shellspec")" ]; then
	echo >&2 "\033[1;31mERROR\033[0m: You need to have shellspec installed if you want to create a release"
	exit 2
fi

declare version key nextVersion prepareOnly
# shellcheck disable=SC2034
declare params=(
	version '-v|--version' "The version to release in the format vX.Y.Z(-RC...)"
	key '-k|--key' 'The GPG private key which shall be used to sign the files'
	nextVersion '-nv|--next-version' '(optional) the version to use for prepare-next-dev-cycle -- default: is next minor based on version'
	prepareOnly '--prepare-only' '(optional) defines whether the release shall only be prepared (i.e. no push, no tag, no prepare-next-dev-cycle) -- default: false'
)

declare scriptDir
scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
# shellcheck disable=SC1091
source "$scriptDir/../src/utility/parse-args.sh"
parseArguments params "" "$@"

declare versionRegex="^(v[0-9]+)\.([0-9]+)\.[0-9]+(-RC[0-9]+)?$"

if [[ -z "$nextVersion" ]] && [[ "$version" =~ $versionRegex ]]; then
	nextVersion="${BASH_REMATCH[1]}.$((BASH_REMATCH[2] + 1)).0"
fi
if [[ -z "$prepareOnly" ]] || ! [[ "$prepareOnly" == "true" ]]; then prepareOnly=false; fi
checkAllArgumentsSet params ""

if ! [[ "$version" =~ $versionRegex ]]; then
	printf >&2 "\033[1;31mERROR\033[0m: --version should match vX.Y.Z(-RC...), was %s\n" "$version"
	exit 1
fi

if git tag | grep "$version" >/dev/null; then
	printf >&2 "\033[1;31mERROR\033[0m: tag %s already exists, delete with git tag -d %s\n" "$version" "$version"
	exit 1
fi

git checkout main
git pull

# make sure everything is up-to-date and works as it should
"$scriptDir/before-pr.sh"

"$scriptDir/../src/releasing/sneak-peek-banner.sh" -c hide
"$scriptDir/../src/releasing/toggle-sections.sh" -c release
"$scriptDir/../src/releasing/update-version-README.sh" -v "$version"
"$scriptDir/../src/releasing/update-version-scripts.sh" -v "$version"

rm -rf "$scriptDir/../.gget/gpg"
mkdir "$scriptDir/../.gget/gpg"
chmod 700 "$scriptDir/../.gget/gpg"

gpg --homedir "$scriptDir/../.gget/gpg" --import "$scriptDir/../.gget/signing-key.public.asc"
echo -e "5\ny\n" | gpg --homedir "$scriptDir/../.gget/gpg" --command-fd 0 --edit-key info@tegonal.com trust

find "$scriptDir/../src" -name "*.sh" \
	-not -name "*.doc.sh" \
	-print0 |
	while read -r -d $'\0' script; do
		echo "signing $script"
		gpg --detach-sign --batch --yes -u "$key" -o "${script}.sig" "$script"
		gpg --homedir "$scriptDir/../.gget/gpg" --batch --verify "${script}.sig" "$script"
	done

if ! [ "$prepareOnly" == "true" ]; then
	git add .
	git commit -m "$version"
	git push
	git tag "$version"

	"$scriptDir/prepare-next-dev-cycle.sh" "$nextVersion"

	git push origin "$version"
	git push
else
	printf "\033[1;33mskipping commit, creating tag and prepare-next-dev-cylce due to --prepare-only\033[0m\n"
fi
