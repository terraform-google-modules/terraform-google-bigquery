// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package multiple_tables

import (
	"fmt"
	"log"
	"os"
	"reflect"
	"strings"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/bq"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
)

func TestMultipleTables(t *testing.T) {
	dwh := tft.NewTFBlueprintTest(t)

	dwh.DefineVerify(func(assert *assert.Assertions) {
		dwh.DefaultVerify(assert)

		projectID := dwh.GetTFSetupStringOutput("project_id")
		location := "US"
		dataset_name := dwh.GetJSONOutput("bigquery_dataset").Get("friendly_name")
		tables := dwh.GetJSONOutput("bigquery_tables")
		external_tables := dwh.GetJSONOutput("bigquery_external_tables")

		//////////////////////////////////////////

		homeDir, err := os.UserHomeDir()
		if err != nil {
			log.Fatal(err)
		}
		file, err := os.Create(homeDir + "/.bigqueryrc")
		if err != nil {
			log.Fatal(err)
		}
		file.Close()

		{ // Dataset test
			/*
			   describe google_bigquery_dataset(project: "#{project_id}", name: "#{dataset_name}") do

			   	it { should exist }

			   	its('friendly_name') { should eq "#{dataset_name}" }
			   	its('description') { should eq 'some description' }
			   	its('location') { should eq 'US' }
			   	its('default_table_expiration_ms') { should cmp '3600000' }
			   	its('default_encryption_configuration.kms_key_name') { should cmp "projects/#{project_id}/locations/us/keyRings/ci-bigquery-keyring/cryptoKeys/foo" }

			   end
			*/
		}

		{ // "foo" table test
			//// Maybe bq show is best...

			query := fmt.Sprintf("DESCRIBE TABLE `%s.%s`;", projectID, tablePlaceholder)
			op := bq.Runf(t, "--project_id=%[1]s --headless=true --format=prettyjson query --nouse_legacy_sql %[2]s", projectID, query)

			friendlyName := op.Get("0.friendly_name").String()
			friendlyNameKind := reflect.TypeOf(count).Kind()

			/*
			   describe google_bigquery_table(project: "#{project_id}", dataset: "#{dataset_name}", name: "#{tables[:foo][:friendly_name]}") do

			   	it { should exist }
			   	its('friendly_name') { should eq "#{tables[:foo][:friendly_name]}" }
			   	its('time_partitioning.type') { should eq 'DAY' }
			   	its('clustering') { should_not be nil }

			   end
			*/
		}

		{ // "bar" table test
			/*
			   describe google_bigquery_table(project: "#{project_id}", dataset: "#{dataset_name}", name: "#{tables[:bar][:friendly_name]}") do

			   	it { should exist }
			   	its('friendly_name') { should eq "#{tables[:bar][:friendly_name]}" }
			   	its('time_partitioning.type') { should be nil }
			   	its('clustering') { should be nil }

			   end
			*/
		}

		{ // CSV test
			/*
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
			*/
		}

		{ // Hive test
			/*
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
			*/
		}

		{ // Google Sheets test
			/*
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
			*/
		}

		// Assert BigQuery tables & views are not empty
		test_tables := func() {

			tables := []string{
				"thelook.distribution_centers",
				"thelook.events",
				"thelook.inventory_items",
				"thelook.order_items",
				"thelook.orders",
				"thelook.products",
				"thelook.users",
				"thelook.lookerstudio_report_distribution_centers",
				"thelook.lookerstudio_report_profit",
			}

			query_template := "SELECT COUNT(*) AS count_rows FROM `%[1]s.%[2]s`;"
			for _, table := range tables {
				query := fmt.Sprintf(query_template, projectID, table)
				op := bq.Runf(t, "--project_id=%[1]s --headless=true query --nouse_legacy_sql %[2]s", projectID, query)

				count := op.Get("0.count_rows").Int()
				count_kind := reflect.TypeOf(count).Kind()
				test_result := assert.Greater(count, int64(0))
				if test_result == true {
				} else {
					fmt.Printf("Some kind of error occurred while running the count query for the %[1]s table. We think it has %[2]d rows. Test failed. Here's some additional details: \n Query results. If this number is greater than 0, then there is probably an issue in the comparison: %[3]s \n Variable type for the count. This should be INT64: %[4]s \n ", table, count, op, count_kind)
				}
			}
		}
		test_tables()

	})
	dwh.Test()
}
