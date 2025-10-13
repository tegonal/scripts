# run the install-shfmt.sh in your github/gitlab workflow
# for instance, assuming you fetched this file via gt and remote name is tegonal-scripts
# then in a github workflow you would have

jobs:
  steps:
    - name: install shfmt
      run: ./lib/tegonal-scripts/src/ci/install-shfmt.sh
    # and most likely as well
    - name: run shfmt
      run: ./scripts/run-shfmt.sh
