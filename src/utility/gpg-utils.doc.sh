#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit || { echo >&2 "please update to bash 5, see errors above" && exit 1; }
# Assumes tegonal's scripts were fetched with gt - adjust location accordingly
dir_of_tegonal_scripts="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null && pwd 2>/dev/null)/../lib/tegonal-scripts/src"
source "$dir_of_tegonal_scripts/setup_tegonal_scripts.sh" "$dir_of_tegonal_scripts"

sourceOnce "$dir_of_tegonal_scripts/utility/gpg-utils.sh"

# import public-key.asc into gpg store located at ~/.gpg and trust automatically
importGpgKey ~/.gpg ./public-key.asc

# import public-key.asc into gpg store located at ~/.gpg but ask given question first which needs to be answered with yes
importGpgKey ~/.gpg ./public-key.asc "do you want to import the shown key(s)?"

# import public-key.asc into gpg store located at .gt/remotes/tegonal-scripts/public-keys/gpg
# and trust automatically
importGpgKey .gt/remotes/tegonal-scripts/public-keys/gpg ./public-key.asc

# trust key which is identified via info@tegonal.com in gpg store located at ~/.gpg
trustGpgKey ~/.gpg info@tegonal.com

# get the gpg key data one can retrieve via --list-key --with-colons (pub or sub) for the key which signed the given file
getSigningGpgKeyData "file.sig"

# get the gpg key data one can retrieve via --list-key --with-colons (pub or sub) for the key which signed the given file
# but searches the key not in the default gpg store but in .gt/remotes/tegonal-scripts/public-keys/gpg
getSigningGpgKeyData "file.sig" .gt/remotes/tegonal-scripts/public-keys/gpg

# returns the creation date of the signature
getSigCreationDate "file.sig"

keyData="sub:-:4096:1:4B78012139378220:..."

# extract the key id from the given key data
extractGpgKeyIdFromKeyData "$keyData"
# extract the expiration timestamp from the given key data
extractExpirationTimestampFromKeyData "$keyData"

# returns with 0 if the given key data (the key respectively) is expired, non-zero otherwise
isGpgKeyInKeyDataExpired "$keyData"
# returns with 0 if the given key data  (the key respectively) was revoked, non-zero otherwise
isGpgKeyInKeyDataRevoked "$keyData"

# returns the revocation data one can retrieve via --list-sigs --with-colons (rev) for the given key
getRevocationData 4B78012139378220

# returns the revocation data one can retrieve via --list-sigs --with-colons (rev) for the given key
# but searches the revocation not in the default gpg store but in .gt/remotes/tegonal-scripts/public-keys/gpg
getRevocationData 4B78012139378220 .gt/remotes/tegonal-scripts/public-keys/gpg

# extract the creation timestamp from the given revocation data
extractCreationTimestampFromRevocationData

# list all signatures of the given key and highlights it in the output (which especially useful if the key is a subkey
# and there are other subkeys)
listSignaturesAndHighlightKey 4B78012139378220

# list all signatures of the given key and highlights it in the output (which especially useful if the key is a subkey
# and there are other subkeys) but searches the revocation not in the default gpg store but in
# .gt/remotes/tegonal-scripts/public-keys/gpg
listSignaturesAndHighlightKey 4B78012139378220 .gt/remotes/tegonal-scripts/public-keys/gpg
