# run the install-shellcheck.sh in your github/gitlab workflow
# for instance, assuming you fetched this file via gt and remote name is tegonal-scripts
# then in a github workflow you would have

jobs:
  steps:
    - name: install shellspec v0.28.1
      run: ./lib/tegonal-scripts/src/ci/install-shellspec.sh
    # and most likely as well
    - name: run shellspec
      run: shellspec

