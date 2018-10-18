#!/bin/bash
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

TEMPDIR=$(pwd)/test/integration/tmp
TESTDIR=${BASH_SOURCE%/*}

# Activate test working directory
function make_testdir() {
  mkdir -p "$TEMPDIR"
  cp -r "$TESTDIR"/* "$TEMPDIR"
}

# Activate test config
function activate_config() {
  # shellcheck disable=SC1091
  source config.sh
  echo "$PROJECT_NAME"
}

# Cleans the workdir
function clean_workdir() {
  rm -rf "$TEMPDIR"

  export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=""
  unset CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE
}

# Creates the main.tf file for Terraform
function create_main_tf_file() {
  echo "Creating main.tf file"
  touch main.tf
  cat <<EOF > main.tf

EOF
}

# Creates the outputs.tf file
function create_outputs_file() {
  echo "Creating outputs.tf file"
  touch outputs.tf
  cat <<'EOF' > outputs.tf

EOF
}

# Execute bats tests
function run_bats() {
  # Call to bats
  echo "Test to execute: $(bats integration.bats -c)"
  bats integration.bats
}

# Preparing environment
make_testdir
cd "$TEMPDIR" || exit
activate_config
create_main_tf_file
create_outputs_file

# Call to bats
run_bats

# # # Clean the environment
cd - || exit
# clean_workdir
echo "Integration test finished"
