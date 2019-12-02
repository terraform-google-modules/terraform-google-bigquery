# Copyright 2019 Google LLC
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
project_id       = attribute('bigquery_dataset')['project']
dataset_name     = attribute('bigquery_dataset')['friendly_name']
tables           = attribute('bigquery_tables')

describe google_bigquery_dataset(project: "#{project_id}", name: "#{dataset_name}") do
  it { should exist }

  its('friendly_name') { should eq "#{dataset_name}" }
  its('description') { should eq 'some description' }
  its('location') { should eq 'US' }
  its('default_table_expiration_ms') { should cmp '3600000' }
end

describe google_bigquery_table(project: "#{project_id}", dataset: "#{dataset_name}", name: "#{tables["foo"]["friendly_name"]}") do
  it { should exist }
  its('friendly_name') { should eq "#{tables["foo"]["friendly_name"]}" }
  its('time_partitioning.type') { should eq 'DAY' }
  its('clustering') { should_not be nil }
end

describe google_bigquery_table(project: "#{project_id}", dataset: "#{dataset_name}", name: "#{tables["bar"]["friendly_name"]}") do
  it { should exist }
  its('friendly_name') { should eq "#{tables["bar"]["friendly_name"]}" }
  its('time_partitioning.type') { should be nil }
  its('clustering') { should be nil }
end
