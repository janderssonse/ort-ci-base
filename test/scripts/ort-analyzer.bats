# SPDX-FileCopyrightText: 2022 Josef Andersson
#
# SPDX-License-Identifier: MIT

# Bats tests.
# https://github.com/bats-core/bats-core
# One can argue we test implementation details (did value X get set and exported),
# but as bash is quite brittle this is relevant in bug hunting.

# shellcheck disable=SC2148
setup() {
  TEST_LIB_PREFIX="${PWD}/test/lib/"
  load "${TEST_LIB_PREFIX}bats-support/load.bash"
  load "${TEST_LIB_PREFIX}bats-assert/load.bash"
  load "${TEST_LIB_PREFIX}bats-file/load.bash"
  # get the containing directory of this file
  # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
  # as those will point to the bats executable's location or the preprocessed file respectively
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
  # make executables in src/ visible to PATH
  PATH="$DIR/../src:$PATH"

  TEST_TEMP_DIR="$(temp_make --prefix 'ort-ci-analyzer-')"
}

mock_setup() {

  export ORT_CLI="echo"

  pushd() {
    echo "mock pushd with arg $*"

  }
  rm() {
    echo "mock rm with arg $*"

  }
  git() {
    echo "mock git with arg $*"

  }
  grep() {
    echo "mock grep with arg $*"

  }
  awk() {
    echo "mock awk with arg $*"

  }
  sed() {
    echo "mock sed with arg $*"

  }
  xargs() {
    echo "mock xargs with arg $*"

  }
  popd() {
    echo "mock popd"

  }

  export -f pushd
  export -f popd
  export -f git
  export -f rm
  export -f grep
  export -f awk
  export -f sed
  export -f xargs

}

env_setup() {

  export CI_PROJECT_DIR='ci_project_dir'
  export VCS_TYPE=''
  #export ORT_ANALYZER_OPTIONS='analyzer_options'
  # export ORT_ANALYZER_OPTIONS='/VCS_PATH'
  export ORT_OPTIONS='ort_options'
  export ORT_LOG_LEVEL='log_level'
  export ANALYZER_INPUT_DIR='anlyzer_dir'
  export ORT_RESULTS_DIR='result_dir'
  export CI_PIPELINE_URL='ci_pipeline_url'

  export ORT_CONFIG_CURATIONS_DIR='curdir'
  export SW_NAME='SW_NAME'
  export SW_VERSION='SW_VERSION'
  export VCS_URL='VCS_URL'
  export VCS_REVISION='VCS_REVISION'
  export VCS_PATH='VCS_PATH'
  export LABELS=''
  export ORT_CONFIG_FILE='ORT_CONFIG_FILE'
  export ORT_CONFIG_REPO_URL='ORT_CONFIG_REPO_URL'
  export ORT_CONFIG_REVISION='ORT_CONFIG_REVISION'
  export ALLOW_DYNAMIC_VERSIONS='ORT_ALLOW_DYNAMIC_VERSIONS'
  export DISABLE_SHALLOW_CLONE='DISABLE_SHALLOW_CLONE'
  export ORT_VERSION='ORT_VERSION'
  export UPSTREAM_BRANCH='UPSTREAM_BRANCH'
  export UPSTREAM_PROJECT_PATH='UPSTREAM_PROJECT_PATH'
  export UPSTREAM_PROJECT_TITLE='UPSTREAM_PROJECT_TITLE'
  export UPSTREAM_PROJECT_ID='UPSTREAM_PROJECT_ID'
  export UPSTREAM_USER_LOGIN='UPSTREAM_USER_LOGIN'
  export UPSTREAM_PROJECT_URL='UPSTREAM_PROJECT_URL'
  export UPSTREAM_MERGE_REQUEST_IID='UPSTREAM_MERGE_REQUEST_IID'
  export UPSTREAM_PIPELINE_URL='UPSTREAM_PIPELINE_URL'
  export CI_PIPELINE_URL='CI_PIPELINE_URL'
  export CI_JOB_URL='CI_JOB_URL'

}

function on_basic_script_execute_advisor_is_called_ort_cli_is_called_with_these_arguments { #@test

  mock_setup
  env_setup

  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  assert_success
  assert_output --partial '--log_level --stacktrace ort_options analyze -i /VCS_PATH -o result_dir -f JSON -l GITLAB_PIPELINE_URL=CI_PIPELINE_URL -l SW_NAME=SW_NAME -l SW_VERSION=SW_VERSION -l VCS_TYPE= -l VCS_URL=VCS_URL -l VCS_REVISION=VCS_REVISION -l VCS_PATH=VCS_PATH -l LABELS= -l ORT_CONFIG_FILE=ORT_CONFIG_FILE -l ORT_CONFIG_REPO_URL=ORT_CONFIG_REPO_URL -l ORT_CONFIG_REVISION=ORT_CONFIG_REVISION -l ALLOW_DYNAMIC_VERSIONS= -l DISABLE_SHALLOW_CLONE=DISABLE_SHALLOW_CLONE -l ORT_LOG_LEVEL=log_level -l ORT_VERSION=ORT_VERSION -l UPSTREAM_BRANCH=UPSTREAM_BRANCH -l UPSTREAM_PROJECT_PATH=UPSTREAM_PROJECT_PATH -l UPSTREAM_PROJECT_TITLE=UPSTREAM_PROJECT_TITLE -l UPSTREAM_PROJECT_ID=UPSTREAM_PROJECT_ID -l UPSTREAM_USER_LOGIN=UPSTREAM_USER_LOGIN -l UPSTREAM_PROJECT_URL=UPSTREAM_PROJECT_URL -l UPSTREAM_MERGE_REQUEST_IID=UPSTREAM_MERGE_REQUEST_IID -l UPSTREAM_PIPELINE_URL=UPSTREAM_PIPELINE_URL -l CI_PIPELINE_URL=CI_PIPELINE_URL -l CI_JOB_URL=CI_JOB_URL'

}

function if_vcs_type_is_git_run_deeper_git_function { #@test

  mock_setup
  env_setup

  export VCS_TYPE='notgit'

  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  assert_success
  refute_output --partial "mock git"

  export VCS_TYPE='git'

  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  printf "%s/n" "mock pushd with arg" \
    "mock git with arg ls-remote --tags" \
    "mock git with arg log --pretty=format:%H" \
    "mock grep with arg -Ff" \
    "mock awk with arg {print $2}" \
    "mock sed with arg s/\^{}//" \
    "mock xargs with arg -r -I tag git fetch origin tag:tag" \
    "mock rm with arg" \
    "mock popd" | assert_output --partial

  export DISABLE_SHALLOW_CLONE='true'
  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  assert_success

  printf "%s/n" "mock pushd with arg" \
    "mock git with arg fetch --unshallow" \
    "mock popd" | assert_output --partial

  # printf "%s/n" \
  # "mock git with arg ls-remote --tags" \
  # "mock git with arg log --pretty=format:%H" \
  # "mock grep with arg -Ff" \
  # "mock awk with arg {print $2}" \
  # "mock sed with arg s/\^{}//" \
  # "mock xargs with arg -r -I tag git fetch origin tag:tag" \
  # "mock rm with arg" | refute_output --partial
}

function set_ort_analyzer_options_sets_var() { #@test

  mock_setup
  env_setup

  touch "${TEST_TEMP_DIR}/tmpconf"

  export CI_PROJECT_DIR='ci_project_dir'
  export ORT_CONFIG_CURATIONS_DIR=''
  export ORT_CONFIG_CURATIONS_FILE=''
  export ORT_CONFIG_FILE=''

  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  # not set
  assert_success
  assert_output --partial "analyze -i"

  export ORT_CONFIG_FILE=$TEST_TEMP_DIR/tmpconf
  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  assert_success
  assert_output --partial "analyze --repository-configuration-file ci_project_dir/${TEST_TEMP_DIR}/tmpconf"

  export ORT_CONFIG_CURATIONS_FILE=$TEST_TEMP_DIR/tmpconf
  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  assert_success
  assert_output --partial "analyze --package-curations-file ${TEST_TEMP_DIR}/tmpconf"

  export ORT_CONFIG_CURATIONS_DIR=$TEST_TEMP_DIR
  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  assert_success
  assert_output --partial "analyze --package-curations-dir ${TEST_TEMP_DIR}"

}

function set_ort_options_sets_var() { #@test

  mock_setup
  env_setup

  #inital values
  export PROJECT_DIR='project_dir'
  export ORT_CONFIG_CURATIONS_DIR=''
  export ORT_CONFIG_CURATIONS_FILE=''
  export ORT_CONFIG_FILE=''

  export ORT_OPTIONS=''
  export ORT_ALLOW_DYNAMIC_VERSIONS=''
  export VCS_TYPE=''
  export VCS_PATH=''
  export ANALYZER_INPUT_DIR=''

  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  assert_success
  assert_output --partial "--stacktrace analyze -i"

  export ORT_ALLOW_DYNAMIC_VERSIONS='true'
  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  assert_success
  assert_output --partial "--stacktrace -P ort.analyzer.allowDynamicVersions=true analyze -i"

  export VCS_TYPE='git-repo'
  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  assert_success
  assert_output --partial "--stacktrace -P ort.analyzer.allowDynamicVersions=true analyze -i project_dir"

  export VCS_TYPE=''
  export VCS_PATH='vcs_path'
  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  assert_success
  assert_output --partial "--stacktrace -P ort.analyzer.allowDynamicVersions=true analyze -i project_dir/vcs_path"

  export VCS_TYPE=''
  export VCS_TYPE='vcs_path'
  export PROJECT_DIR=''
  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  assert_success
  assert_output --partial '--stacktrace -P ort.analyzer.allowDynamicVersions=true analyze -i /vcs_path'
}

function call_to_convert_labels_set_expected_vars() { #@test

  mock_setup
  env_setup

  #inital values
  export LABELS=''
  export LABELS_OPTIONS='key=value'

  # shellcheck source=/dev/null
  run src/scripts/ort-analyzer.sh

  assert_success
  refute_output --partial 'key=value'

  #TO-DO how to mock call to labels.sh in subprocess. Can't export function containing /
  # If script was sourceable it would be possible to test seperate functions easiyer
  #export LABELS='isset'
  #run src/scripts/ort-analyzer.sh

  #assert_output --partial "key=value"
}

teardown() {
  # unset mock as bats needs real rm to clean up tmpdirs
  unset rm
}
