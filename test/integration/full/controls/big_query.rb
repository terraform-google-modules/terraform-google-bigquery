# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Attributes can be used to create tests with as the mode becomes more complex
project_id       = attribute('dataset_project')
dataset_id       = attribute('dataset_id')
table_id         = attribute('table_id')

control "big_query_check" do
  describe command("bq ls --project_id=#{project_id} --format=json") do
    its('exit_status') { should be 0 }
    its('stderr') { should eq '' }
  end

  describe command("bq ls --project_id=#{project_id} --format=json" ) do
     its('exit_status') { should be 0 }
     its('stderr') { should eq '' }
   end
end
