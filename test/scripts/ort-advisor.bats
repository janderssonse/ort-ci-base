# SPDX-FileCopyrightText: 2022 Josef Andersson
#
# SPDX-License-Identifier: MIT

#Bats tests.
# https://github.com/bats-core/bats-core
# One can argue this tests some implementation details (did value X get set and exported),
# but as shell scripts are brittle this is relevant.

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

}

function on_script_execute_advise_is_called_flags_was_set { #@test

  export ORT_CLI="echo"
  export ORT_LOG_LEVEL='log_level'
  export ORT_ADVISOR_PROVIDERS='providers'
  export ORT_RESULTS_DIR='input_dir'

  export ORT_RESULTS_SCANNER_FILE='scanner_file'
  export ORT_RESULTS_ANALYZER_FILE='analyzer_file'

  # shellcheck source=/dev/null
  run src/scripts/ort-advisor.sh

  assert_success
  assert_output '--log_level --stacktrace advise -a providers -i scanner_file -o input_dir -f JSON'

  export ORT_DISABLE_SCANNER='true'
  # shellcheck source=/dev/null
  run src/scripts/ort-advisor.sh

  assert_success
  assert_output '--log_level --stacktrace advise -a providers -i analyzer_file -o input_dir -f JSON'

  #TO-DO test exit code set (needs script to be sourceable or executable, can be fixed by allowing $@ argument for script instead of run_advis)

}
