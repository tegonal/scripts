#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.7.1
#
###################################
set -eu
declare -x TEGONAL_SCRIPTS_VERSION='v0.7.1'

if ! [[ -v scriptDir ]]; then
	scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
	declare -r scriptDir
fi

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(realpath "$scriptDir/../src")"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi

sourceOnce "$dir_of_tegonal_scripts/utility/log.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/parse-args.sh"

if ! [[ -x "$(command -v "shellspec")" ]]; then
	die "You need to have shellspec installed if you want to create a release"
fi

declare version key nextVersion prepareOnly
# shellcheck disable=SC2034
declare params=(
	version '-v' "The version to release in the format vX.Y.Z(-RC...)"
	key '-k|--key' 'The GPG private key which shall be used to sign the files'
	nextVersion '-nv|--next-version' '(optional) the version to use for prepare-next-dev-cycle -- default: is next minor based on version'
	prepareOnly '--prepare-only' '(optional) defines whether the release shall only be prepared (i.e. no push, no tag, no prepare-next-dev-cycle) -- default: false'
)

parseArguments params "" "$TEGONAL_SCRIPTS_VERSION" "$@"

declare versionRegex="^(v[0-9]+)\.([0-9]+)\.[0-9]+(-RC[0-9]+)?$"

if ! [[ -v nextVersion ]] && [[ -v version ]] && [[ "$version" =~ $versionRegex ]]; then
	nextVersion="${BASH_REMATCH[1]}.$((BASH_REMATCH[2] + 1)).0"
else
	logInfo "cannot deduce nextVersion from version as it does not follow format vX.Y.Z(-RC...): $version"
fi
if ! [[ -v prepareOnly ]] || ! [[ "$prepareOnly" == "true" ]]; then prepareOnly=false; fi
checkAllArgumentsSet params "" "$TEGONAL_SCRIPTS_VERSION"

if ! [[ "$version" =~ $versionRegex ]]; then
	die "--version should match vX.Y.Z(-RC...), was %s" "$version"
fi

if git tag | grep "$version" >/dev/null; then
	die "tag %s already exists, delete with git tag -d %s" "$version" "$version"
fi

declare branch
branch="$(git rev-parse --abbrev-ref HEAD)"
if ! [[ $branch == "main" ]]; then
	die "you need to be on the \033[0;36mmain\033[0m branch to release, check that you have merged all changes from your current branch \033[0;36m%s\033[0m" "$branch"
fi
if ! (($(git rev-list --count origin/main..main) == 0)); then
	logError "you are ahead of origin, please push first and check if CI succeeds before releasing. Following your additional changes:"
	git -P log origin/main..main
	exit 1
fi
if ! (($(git rev-list --count main..origin/main) == 0)); then
	git fetch
	logError "you are behind of origin. I already fetched the changes for you, please check if you still want to release. Following the additional changes in origin/main"
	git -P log main..origin/main
	exit 1
fi

# make sure everything is up-to-date and works as it should
"$scriptDir/before-pr.sh"

# same as in prepare-next-dev-cycle.sh, update there as well
declare additionalPattern="(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"

"$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh" -c hide
"$dir_of_tegonal_scripts/releasing/toggle-sections.sh" -c release
"$dir_of_tegonal_scripts/releasing/update-version-README.sh" -v "$version" -p "$additionalPattern"
"$dir_of_tegonal_scripts/releasing/update-version-scripts.sh" -v "$version" -p "$additionalPattern"
"$dir_of_tegonal_scripts/releasing/update-version-scripts.sh" -v "$version" -p "$additionalPattern" -d "$scriptDir"

# update docu with new version
"$scriptDir/update-docu.sh"

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

if ! [[ $prepareOnly == true ]]; then
	git add .
	git commit -m "$version"
	git tag "$version"

	"$scriptDir/prepare-next-dev-cycle.sh" "$nextVersion"

	git push origin "$version"
	git push
else
	printf "\033[1;33mskipping commit, creating tag and prepare-next-dev-cylce due to --prepare-only\033[0m\n"
fi
