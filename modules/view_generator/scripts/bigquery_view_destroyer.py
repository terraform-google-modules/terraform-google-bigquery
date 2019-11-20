#!/usr/bin/env python

# Copyright 2019 Google LLC
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

import sys
import subprocess
import os
import time

def main():
    bq_path    = os.environ.get('BQ_PATH', sys.argv[1:])
    project_id = os.environ.get('PROJECT_ID', sys.argv[2:])
    dataset_id = os.environ.get('DATASET_ID', sys.argv[3:])
    view_name  = os.environ.get('VIEW_NAME', sys.argv[4:])
    view_fqn   = project_id + ":" + dataset_id + "." + view_name

    destroy_view_command = " ".join([
        bq_path, "--synchronous_mode", "rm", "-f", "-t", view_fqn
    ])

    tries   = 3
    attempt = 0

    while attempt < tries:
        attempt += 1
        sys.stdout.write("Destroying BQ View, Attempt #"+str(attempt)+": ")
        print(destroy_view_command)

        try:
            subprocess.check_output(destroy_view_command, shell=True)
            break
        except subprocess.CalledProcessError as err:
            if attempt >= tries:
                raise RuntimeError(err.output)
            else:
                time.sleep(10)

if __name__ == '__main__':
    main()
