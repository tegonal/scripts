#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/scripts
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.18.0-SNAPSHOT
#
#######  Description  #############
#
#  utility function dealing with fetching files via http
#
#######  Usage  ###################
#
#    #!/usr/bin/env bash
#    set -euo pipefail
#    shopt -s inherit_errexit
#    # Assumes tegonal's scripts were fetched with gget - adjust location accordingly
#    dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
#    source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
#
#    sourceOnce "$dir_of_tegonal_scripts/utility/http.sh"
#
#    # downloads https://.../signing-key.public.asc and https://.../signing-key.public.asc.sig and verifies it with gpg
#    wgetAndVerify "https://github.com/tegonal/gget/.gget/signing-key.public.asc"
#
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH
export TEGONAL_SCRIPTS_VERSION='v0.18.0-SNAPSHOT'

if ! [[ -v dir_of_tegonal_scripts ]]; then
	dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/.."
	source "$dir_of_tegonal_scripts/setup.sh" "$dir_of_tegonal_scripts"
fi

function wgetAndVerify() {
	exitIfCommandDoesNotExist "wget"

	local url gpgDir
	# shellcheck disable=SC2034   # is passed to parseArguments by name
	local -ar params=(
		url "-u|--url" "the url which shall be fetched"
		gpgDir "--gpg-homedir" "(optional) can be used to specify a different home directory for gpg -- default: \$HOME/.gnupg"
	)
	local -r examples=$(
		# shellcheck disable=SC2312
		cat <<-EOM
			# updates gget to the latest tag
			gget self-update

			# updates gget to the latest tag and downloads the sources even if already on the latest
			gget self-update --force
		EOM
	)
	parseArguments params "$examples" "$TEGONAL_SCRIPTS_VERSION" "$@"
	if ! [[ -v gpgDir ]]; then gpgDir="$HOME/.gnupg"; fi
	exitIfNotAllArgumentsSet params "$examples" "$TEGONAL_SCRIPTS_VERSION"

	local fileName
	fileName=$(basename "$url")
	local currentDir
	currentDir=$(pwd)

	for name in "$fileName" "$fileName.sig"; do
	if [[ -f $name ]]; then
  		logInfo "there is already a file named %s in %s, going to override" "$name" "$currentDir"
  	fi
	done

	wget -O "$url" || die "could not download %s" "$url"
	wget -O "$url.sig" || die "could not download %s" "$url.sig"
	gpg --homedir "$gpgDir" --verify "./$fileName.sig" "./$fileName"
}
