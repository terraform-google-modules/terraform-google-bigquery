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
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestMultipleTables(t *testing.T) {
	dwh := tft.NewTFBlueprintTest(t)

	dwh.DefineVerify(func(assert *assert.Assertions) {
		// Note: DefaultVerify() is unusable here because some attributes,
		// such as last_modified_time, are changed outside of Terraform's knowledge.

		projectID := dwh.GetTFSetupStringOutput("project_id")
		tables := dwh.GetJsonOutput("bigquery_tables")
		externalTables := dwh.GetJsonOutput("bigquery_external_tables")

		{ // Dataset test
			dataset := dwh.GetJsonOutput("bigquery_dataset")
			assert.Equal("foo", dataset.Get("friendly_name").String(), "dataset's friendly_name should be foo")
			assert.Equal("some description", dataset.Get("description").String(), "dataset foo's description should be 'some description'")
			assert.Equal("US", dataset.Get("location").String(), "dataset foo's location should be US")
			assert.Equal(int64(3600000), dataset.Get("default_table_expiration_ms").Int(), "dataset foo's default_table_expiration_ms should be 3600000")
			assert.Equal(fmt.Sprintf("projects/%s/locations/us/keyRings/ci-bigquery-keyring/cryptoKeys/foo", projectID), dataset.Get("default_encryption_configuration.0.kms_key_name").String(), "dataset foo's default_encryption_configuration.0.kms_key_name")
		}

		{ // "foo" table test
			fooTable := tables.Get("foo")
			assert.Equal("foo", fooTable.Get("friendly_name").String(), "table's friendly_name should be foo")
			assert.Equal("DAY", fooTable.Get("time_partitioning.0.type").String(), "foo table's time_partitioning.type should be DAY")

			assert.Greater(len(fooTable.Get("clustering").Array()), 0, "foo table's clustering should be nonempty")
		}

		{ // "bar" table test
			barTable := tables.Get("bar")
			assert.True(barTable.Exists(), "bar table should exist in terraform outputs")
			assert.Equal("bar", barTable.Get("friendly_name").String(), "table's friendly_name should be bar")
			assert.False(barTable.Get("time_partitioning.0.type").Exists(), "bar table's time_partitioning.type should be null")
			assert.Len(barTable.Get("clustering").Array(), 0, "bar table's clustering should be empty")
		}

		{ // CSV test
			csvTable := externalTables.Get("csv_example")
			assert.True(csvTable.Exists(), "csv_example table should exist in terraform outputs")
			assert.Equal("csv_example", csvTable.Get("friendly_name").String(), "table's friendly_name should be csv_example")
			assert.False(csvTable.Get("time_partitioning.0.type").Exists(), "csv_example table's time_partitioning.type should be null")
			assert.Len(csvTable.Get("clustering").Array(), 0, "csv_example table's clustering should be empty")
			assert.Equal("EXTERNAL", csvTable.Get("type").String(), "csv_example table's type should be EXTERNAL")

			csvDataConfig := csvTable.Get("external_data_configuration.0")
			assert.True(csvDataConfig.Exists(), "csv_example table should contain external_data_configuration")
			assert.True(csvDataConfig.Get("autodetect").Bool(), "csv_example.external_data_configuration.autodetect should be true")
			assert.Equal("NONE", csvDataConfig.Get("compression").String(), "csv_example.external_data_configuration.compression should be NONE")
			assert.True(csvDataConfig.Get("ignore_unknown_values").Bool(), "csv_example.external_data_configuration.ignore_unknown_values should be true")
			assert.Equal(int64(0), csvDataConfig.Get("max_bad_records").Int(), "csv_example.external_data_configuration.max_bad_records should be 0")
			assert.Equal("CSV", csvDataConfig.Get("source_format").String(), "csv_example.external_data_configuration.source_format should be CSV")
			assert.Len(csvDataConfig.Get("source_uris").Array(), 1, "csv_example.external_data_configuration.source_uris should have 1 element")
			assert.Equal("gs://ci-bq-external-data/bigquery-external-table-test.csv", csvDataConfig.Get("source_uris.0").String(), "csv_example.external_data_configuration.source_uris[0] should have the expected URI")

			csvOptions := csvDataConfig.Get("csv_options.0")
			assert.True(csvOptions.Exists(), "csv_example table should contain external_data_configuration.csv_options")
			assert.Equal(`"`, csvOptions.Get("quote").String(), `csv_example.external_data_configuration.csv_options should be " (a quote character)`)
			assert.False(csvOptions.Get("allow_jagged_rows").Bool(), "csv_example.external_data_configuration.csv_options.allow_jagged_rows should be false")
			assert.Equal(true, csvOptions.Get("allow_quoted_newlines").Bool(), "csv_example.external_data_configuration.csv_options.allow_quoted_newlines should be true")
			assert.Equal("UTF-8", csvOptions.Get("encoding").String(), "csv_example.external_data_configuration.csv_options.encoding should be UTF-8")
			assert.Equal(",", csvOptions.Get("field_delimiter").String(), "csv_example.external_data_configuration.csv_options.field_delimiter should be ,")
			assert.Equal(int64(1), csvOptions.Get("skip_leading_rows").Int(), "csv_example.external_data_configuration.csv_options.skip_leading_rows should be 1")
		}

		{ // Hive test
			hiveTable := externalTables.Get("hive_example")
			assert.True(hiveTable.Exists(), "hive_example table should exist in terraform outputs")
			assert.Equal("hive_example", hiveTable.Get("friendly_name").String(), "table's friendly_name should be hive_example")
			assert.False(hiveTable.Get("time_partitioning.0.type").Exists(), "hive_example table's time_partitioning.type should be null")
			assert.Len(hiveTable.Get("clustering").Array(), 0, "hive_example table's clustering should be empty")
			assert.Equal("EXTERNAL", hiveTable.Get("type").String(), "hive_example table's type should be EXTERNAL")

			hiveDataConfig := hiveTable.Get("external_data_configuration.0")
			assert.True(hiveDataConfig.Exists(), "hive_example table should contain external_data_configuration")
			assert.True(hiveDataConfig.Get("autodetect").Bool(), "hive_example.external_data_configuration.autodetect should be true")
			assert.Equal("NONE", hiveDataConfig.Get("compression").String(), "hive_example.external_data_configuration.compression should be NONE")
			assert.True(hiveDataConfig.Get("ignore_unknown_values").Bool(), "hive_example.external_data_configuration.ignore_unknown_values should be true")
			assert.Equal(int64(0), hiveDataConfig.Get("max_bad_records").Int(), "hive_example.external_data_configuration.max_bad_records should be 0")
			assert.Equal("CSV", hiveDataConfig.Get("source_format").String(), "hive_example.external_data_configuration.source_format should be CSV")

			assert.Len(hiveDataConfig.Get("source_uris").Array(), 2, "hive_example.external_data_configuration.source_uris should have 2 elements")
			assert.Equal("gs://ci-bq-external-data/hive_partition_example/year=2012/foo.csv", hiveDataConfig.Get("source_uris.0").String(), "hive_example.external_data_configuration.source_uris[0] should have the expected URI")
			assert.Equal("gs://ci-bq-external-data/hive_partition_example/year=2013/bar.csv", hiveDataConfig.Get("source_uris.1").String(), "hive_example.external_data_configuration.source_uris[1] should have the expected URI")
		}

		{ // Google Sheets test
			sheetsTable := externalTables.Get("google_sheets_example")
			assert.True(sheetsTable.Exists(), "google_sheets_example table should exist in terraform outputs")
			assert.Equal("google_sheets_example", sheetsTable.Get("friendly_name").String(), "table's friendly_name should be google_sheets_example")
			assert.False(sheetsTable.Get("time_partitioning.0.type").Exists(), "google_sheets_example table's time_partitioning.type should be null")
			assert.Len(sheetsTable.Get("clustering").Array(), 0, "google_sheets_example table's clustering should be empty")
			assert.Equal("EXTERNAL", sheetsTable.Get("type").String(), "google_sheets_example table's type should be EXTERNAL")

			sheetsDataConfig := sheetsTable.Get("external_data_configuration.0")
			assert.True(sheetsDataConfig.Exists(), "google_sheets_example table should contain external_data_configuration")
			assert.True(sheetsDataConfig.Get("autodetect").Bool(), "google_sheets_example.external_data_configuration.autodetect should be true")
			assert.Equal("NONE", sheetsDataConfig.Get("compression").String(), "google_sheets_example.external_data_configuration.compression should be NONE")
			assert.True(sheetsDataConfig.Get("ignore_unknown_values").Bool(), "google_sheets_example.external_data_configuration.ignore_unknown_values should be true")
			assert.Equal(int64(0), sheetsDataConfig.Get("max_bad_records").Int(), "google_sheets_example.external_data_configuration.max_bad_records should be 0")
			assert.Equal("GOOGLE_SHEETS", sheetsDataConfig.Get("source_format").String(), "google_sheets_example.external_data_configuration.source_format should be CSV")

			assert.Len(sheetsDataConfig.Get("source_uris").Array(), 1, "google_sheets_example.external_data_configuration.source_uris should have 1 element")
			assert.Equal("https://docs.google.com/spreadsheets/d/15v4N2UG6bv1RmX__wru4Ei_mYMdVcM1MwRRLxFKc55s", sheetsDataConfig.Get("source_uris.0").String(), "google_sheets_example.external_data_configuration.source_uris[0] should have the expected URI")

			assert.Equal(int64(1), sheetsDataConfig.Get("google_sheets_options.0.skip_leading_rows").Int(), "google_sheets_example.external_data_configuration.google_sheets_options.0.skip_leading_rows should be 1")
		}
	})
	dwh.Test()
}
