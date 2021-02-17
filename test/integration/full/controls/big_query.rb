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
project_id       = attribute('bigquery_dataset')[:project]
dataset_name     = attribute('bigquery_dataset')[:friendly_name]
tables           = attribute('bigquery_tables')
external_tables  = attribute('bigquery_external_tables')

describe google_bigquery_dataset(project: "#{project_id}", name: "#{dataset_name}") do
  it { should exist }

  its('friendly_name') { should eq "#{dataset_name}" }
  its('description') { should eq 'some description' }
  its('location') { should eq 'US' }
  its('default_table_expiration_ms') { should cmp '3600000' }
  its('default_encryption_configuration.kms_key_name') { should cmp "projects/#{project_id}/locations/us/keyRings/ci-bigquery-keyring/cryptoKeys/foo" }
end

describe google_bigquery_table(project: "#{project_id}", dataset: "#{dataset_name}", name: "#{tables[:foo][:friendly_name]}") do
  it { should exist }
  its('friendly_name') { should eq "#{tables[:foo][:friendly_name]}" }
  its('time_partitioning.type') { should eq 'DAY' }
  its('clustering') { should_not be nil }
end

describe google_bigquery_table(project: "#{project_id}", dataset: "#{dataset_name}", name: "#{tables[:bar][:friendly_name]}") do
  it { should exist }
  its('friendly_name') { should eq "#{tables[:bar][:friendly_name]}" }
  its('time_partitioning.type') { should be nil }
  its('clustering') { should be nil }
end

describe google_bigquery_table(project: "#{project_id}", dataset: "#{dataset_name}", name: "#{external_tables[:csv_example][:friendly_name]}") do
  it { should exist }
  its('friendly_name') { should eq "#{external_tables[:csv_example][:friendly_name]}" }
  its('time_partitioning.type') { should be nil }
  its('clustering') { should be nil }
  its('type') { should eq "EXTERNAL" }
  its('external_data_configuration.autodetect') { should be true }
  its('external_data_configuration.compression') { should eq "NONE" }
  its('external_data_configuration.ignore_unknown_values') { should be true }
  its('external_data_configuration.max_bad_records') { should be nil }
  its('external_data_configuration.source_format') { should eq "CSV" }
  its('external_data_configuration.source_uris') { should eq ["gs://ci-bq-external-data/bigquery-external-table-test.csv"] }

  its('external_data_configuration.csv_options.quote') { should eq "\"" }
  its('external_data_configuration.csv_options.allow_jagged_rows') { should be nil }
  its('external_data_configuration.csv_options.allow_quoted_newlines') { should be true }
  its('external_data_configuration.csv_options.encoding') { should eq "UTF-8" }
  its('external_data_configuration.csv_options.field_delimiter') { should eq "," }
  its('external_data_configuration.csv_options.skip_leading_rows') { should eq "1" }
end

describe google_bigquery_table(project: "#{project_id}", dataset: "#{dataset_name}", name: "#{external_tables[:hive_example][:friendly_name]}") do
  it { should exist }
  its('friendly_name') { should eq "#{external_tables[:hive_example][:friendly_name]}" }
  its('time_partitioning.type') { should be nil }
  its('clustering') { should be nil }
  its('type') { should eq "EXTERNAL" }
  its('external_data_configuration.autodetect') { should be true }
  its('external_data_configuration.compression') { should eq "NONE" }
  its('external_data_configuration.ignore_unknown_values') { should be true }
  its('external_data_configuration.max_bad_records') { should be nil }
  its('external_data_configuration.source_format') { should eq "CSV" }
  its('external_data_configuration.source_uris') { should eq ["gs://ci-bq-external-data/hive_partition_example/year=2012/foo.csv","gs://ci-bq-external-data/hive_partition_example/year=2013/bar.csv"] }
end

describe google_bigquery_table(project: "#{project_id}", dataset: "#{dataset_name}", name: "#{external_tables[:google_sheets_example][:friendly_name]}") do
  it { should exist }
  its('type') { should eq "EXTERNAL" }
  its('friendly_name') { should eq "#{external_tables[:google_sheets_example][:friendly_name]}" }
  its('time_partitioning.type') { should be nil }
  its('clustering') { should be nil }
  its('external_data_configuration.autodetect') { should be true }
  its('external_data_configuration.compression') { should eq "NONE" }
  its('external_data_configuration.ignore_unknown_values') { should be true }
  its('external_data_configuration.max_bad_records') { should be nil }
  its('external_data_configuration.source_format') { should eq "GOOGLE_SHEETS" }
  its('external_data_configuration.source_uris') { should eq ["https://docs.google.com/spreadsheets/d/15v4N2UG6bv1RmX__wru4Ei_mYMdVcM1MwRRLxFKc55s"] }
  its('external_data_configuration.google_sheets_options.skip_leading_rows') { should eq "1" }
end
