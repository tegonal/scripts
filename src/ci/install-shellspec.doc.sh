# run the install-shellspec in your github/gitlab workflow
# for instance, assuming you fetched this file via gt and remote name is tegonal-scripts
# then in a github workflow you would have

jobs:
  steps:
    - name: install shellspec
      run: ./lib/tegonal-scripts/src/ci/install-shellspec.sh
    # and most likely as well
    - name: run shellspec
      run: shellspec

