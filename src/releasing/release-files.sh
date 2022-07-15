#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.1.0-SNAPSHOT
#
#######  Description  #############
#
#  Releasing files based on conventions:
#  - expects a version in format vX.Y.Z(-RC...)
#  - main is your default branch
#  - requires you to have a scripts folder in your root which contains:
#    - before--pr.sh
#    - prepare-next-dev-cycle.sh
#    - update-docu.sh
#  - there is a public key defined at .gget/signing-key.public.asc which will be used
#    to verify the signatures which will be created
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -eu
#    # Assuming tegonal's scripts were fetched with gget - adjust location accordingly
#    dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src")"
#    source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
#
#    # releases version v0.1.0 using the key 0x945FE615904E5C85 for signing
#    "$dir_of_tegonal_scripts/releasing/release-files.sh" -v v0.1.0 -k "0x945FE615904E5C85"
#
#    # releases version v0.1.0 using the key 0x945FE615904E5C85 for signing and
#    # searches for additional occurrences of the version via the specified pattern in:
#    # - script files in ./src and ./scripts
#    # - ./README.md
#    "$dir_of_tegonal_scripts/releasing/release-files.sh" \
#    	-v v0.1.0 -k "0x945FE615904E5C85" -p "(TEGONAL_SCRIPTS_VERSION=['\"])[^'\"]+(['\"])"
#
###################################
set -eu
declare -x TEGONAL_SCRIPTS_VERSION='v0.8.0-SNAPSHOT'

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)/..")"
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi
sourceOnce "$dir_of_tegonal_scripts/utility/gpg-utils.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/log.sh"
sourceOnce "$dir_of_tegonal_scripts/utility/parse-args.sh"

function releaseFiles() {
	local version key scriptsDir findForSigning
	# shellcheck disable=SC2034
	local -ra params=(
		version '-v' "The version to release in the format vX.Y.Z(-RC...)"
		key '-k|--key' 'The GPG private key which shall be used to sign the files'
		scriptsDir '--scripts-dir' 'The directory which needs to contain before-pr.sh etc.'
		findForSigning '--sign-fn' 'Function which is called to determine what files should be signed. It should be based find and allow to pass further arguments (we will i.a. pass -print0)'
		additionalPattern '-p|--pattern' '(optional) pattern which is used in a perl command (separator /) to search & replace additional occurrences. It should define two match groups and the replace operation looks as follows: '"\\\${1}\$version\\\${2}"
		nextVersion '-nv|--next-version' '(optional) the version to use for prepare-next-dev-cycle -- default: is next minor based on version'
		prepareOnly '--prepare-only' '(optional) defines whether the release shall only be prepared (i.e. no push, no tag, no prepare-next-dev-cycle) -- default: false'
	)

	parseArguments params "" "$TEGONAL_SCRIPTS_VERSION" "$@"

	local -r versionRegex="^(v[0-9]+)\.([0-9]+)\.[0-9]+(-RC[0-9]+)?$"

	if ! [[ -v nextVersion ]] && [[ -v version ]] && [[ "$version" =~ $versionRegex ]]; then
		nextVersion="${BASH_REMATCH[1]}.$((BASH_REMATCH[2] + 1)).0"
	else
		logInfo "cannot deduce nextVersion from version as it does not follow format vX.Y.Z(-RC...): $version"
	fi
	if ! [[ -v additionalPattern ]]; then additionalPattern=""; fi
	if ! [[ -v prepareOnly ]] || ! [[ "$prepareOnly" == "true" ]]; then prepareOnly=false; fi
	checkAllArgumentsSet params "" "$TEGONAL_SCRIPTS_VERSION"

	if ! [[ "$version" =~ $versionRegex ]]; then
		returnDying "--version should match vX.Y.Z(-RC...), was %s" "$version"
	fi

	if git tag | grep "$version" >/dev/null; then
		returnDying "tag %s already exists, adjust version or delete it with: git tag -d %s" "$version" "$version"
	fi

	if ! git status --porcelain; then
		returnDying "you have uncommitted changes (see above) please commit/stash first"
	fi

#	local -r branch="$(git rev-parse --abbrev-ref HEAD)"
#	if ! [[ $branch == "main" ]]; then
#		returnDying "you need to be on the \033[0;36mmain\033[0m branch to release, check that you have merged all changes from your current branch \033[0;36m%s\033[0m" "$branch"
#	fi
#	if ! (($(git rev-list --count origin/main..main) == 0)); then
#		logError "you are ahead of origin, please push first and check if CI succeeds before releasing. Following your additional changes:"
#		git -P log origin/main..main
#		return 1
#	fi
#	if ! (($(git rev-list --count main..origin/main) == 0)); then
#		git fetch
#		logError "you are behind of origin. I already fetched the changes for you, please check if you still want to release. Following the additional changes in origin/main"
#		git -P log main..origin/main
#		return 1
#	fi

	# make sure everything is up-to-date and works as it should
	"$scriptsDir/before-pr.sh"

	"$dir_of_tegonal_scripts/releasing/sneak-peek-banner.sh" -c hide
	"$dir_of_tegonal_scripts/releasing/toggle-sections.sh" -c release
	"$dir_of_tegonal_scripts/releasing/update-version-README.sh" -v "$version" -p "$additionalPattern"
	"$dir_of_tegonal_scripts/releasing/update-version-scripts.sh" -v "$version" -p "$additionalPattern" -d "$scriptsDir"
	source "$scriptsDir/additional-release-preparations.sh"

	# update docu with new version
	"$scriptsDir/update-docu.sh"

	local -r ggetDir="$scriptsDir/../.gget"
	local -r gpgDir="$ggetDir/gpg"
	rm -rf "$gpgDir"
	mkdir "$gpgDir"
	chmod 700 "$gpgDir"

	gpg --homedir "$gpgDir" --import "$ggetDir/signing-key.public.asc"
	trustGpgKey "$gpgDir" "info@tegonal.com"

	"$findForSigning" -print0 |
		while read -r -d $'\0' script; do
			echo "signing $script"
			gpg --detach-sign --batch --yes -u "$key" -o "${script}.sig" "$script"
			gpg --homedir "$gpgDir" --batch --verify "${script}.sig" "$script"
		done

	if ! [[ $prepareOnly == true ]]; then
		git add .
		git commit -m "$version"
		git tag "$version"

		"$scriptsDir/prepare-next-dev-cycle.sh" "$nextVersion"

		git push origin "$version"
		git push
	else
		printf "\033[1;33mskipping commit, creating tag and prepare-next-dev-cylce due to --prepare-only\033[0m\n"
	fi
}
releaseFiles "$@"
