# run the install-shellcheck.sh in your github/gitlab workflow
# for instance, assuming you fetched this file via gt and remote name is tegonal-scripts
# then in a github workflow you would have

jobs:
  steps:
    - name: install shellcheck v0.9.0
      run: ./lib/tegonal-scripts/src/ci/install-shellcheck.sh
    # and most likely as well
    - name: run shellcheck
      run: ./scripts/run-shellcheck.sh

