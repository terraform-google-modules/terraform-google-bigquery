// Copyright 2023 Google LLC
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

package multiple_buckets

import (
	"fmt"
	"log"
	"os"
	"reflect"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/bq"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
)

// TODO: Remove because Eventarc is no longer in use
// Retry if these errors are encountered.
var retryErrors = map[string]string{
	// IAM for Eventarc service agent is eventually consistent
	".*Permission denied while using the Eventarc Service Agent.*": "Eventarc Service Agent IAM is eventually consistent",
}

func TestDataWarehouse(t *testing.T) {
	dwh := tft.NewTFBlueprintTest(t, tft.WithRetryableTerraformErrors(retryErrors, 10, time.Minute))

	dwh.DefineVerify(func(assert *assert.Assertions) {
		dwh.DefaultVerify(assert)

		projectID := dwh.GetTFSetupStringOutput("project_id")
		bucket := dwh.GetStringOutput("raw_bucket")
		workflow := "initial-workflow"

		// Assert that the bucket is in asia-southeast1
		bucketOP := gcloud.Runf(t, "storage buckets describe gs://%s --project %s", bucket, projectID)
		assert.Equal("ASIA-SOUTHEAST1", bucketOP.Get("location").String(), "Bucket should be in asia-southeast1")

		// Assert that Workflow ran successfully
		verifyWorkflows := func() (bool, error) {
			workflowState := gcloud.Runf(t, "workflows executions list %s --project %s --location=asia-southeast1 --limit=1", workflow, projectID).Array()
			state := workflowState[0].Get("state").String()
			assert.NotEqual(t, state, "FAILED")
			if state == "SUCCEEDED" {
				return false, nil
			} else {
				return true, nil
			}
		}
		utils.Poll(t, verifyWorkflows, 8, 30*time.Second)

		homeDir, err := os.UserHomeDir()
        if err != nil {
            log.Fatal(err)
        }
        file, err := os.Create(homeDir + "/.bigqueryrc")
        if err != nil {
            log.Fatal(err)
        }
        file.Close()

		// Assert BigQuery tables & views are not empty
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

		test_query := func (){
			bq.Runf(t, "--project_id=%s --headless=true show thelook.distribution_centers", projectID)
		}

		query_template := "SELECT COUNT(*) AS count_rows FROM `%[1]s.%[2]s`;"

		test_query()
		for _, table := range tables {
			query := fmt.Sprintf(query_template, projectID, table)
			op := bq.Runf(t, "--project_id=%[1]s --headless=true query --nouse_legacy_sql %[2]s", projectID, query)

			count := op.Get("count_rows").Int()
			count_type := reflect.TypeOf(count).Kind()

			if count_type == reflect.Int {
				assert.Greater(t, count, 0, fmt.Sprintf("Table `%s` is empty.", table))
			} else {
				if count_type != reflect.Int {
					assert.Greater(t, int(count), 0, fmt.Sprintf("Table `%s` is empty.", table))
				} else {
					log.Printf("[ERROR] in type conversion: '%+v' is not an integer or string", op.Get("count_rows"))
					}
				}
			}

		// Assert BigQuery connection to Vertex GenAI was successfully created and works as expected
		llm_query_template := "SELECT COUNT(*) AS count_rows FROM ML.GENERATE_TEXT(MODEL `%[1]s.thelook.text_generate_model`, (with clusters AS(SELECT CONCAT('cluster', CAST(centroid_id as STRING)) as centroid, avg_spend as average_spend, count_orders as count_of_orders, days_since_order FROM (SELECT centroid_id, feature, ROUND(numerical_value, 2) as value FROM ML.CENTROIDS(MODEL `%[1]s.thelook.customer_segment_clustering`)) PIVOT (SUM(value) FOR feature IN ('avg_spend', 'count_orders', 'days_since_order')) ORDER BY centroid_id) SELECT 'Pretend you are a creative strategist, given the following clusters come up with creative brand persona and title labels for each of these clusters, and explain step by step; what would be the next marketing step for these clusters' || ' ' || clusters.centroid || ', Average Spend $' || clusters.average_spend || ', Count of orders per person ' || clusters.count_of_orders || ', Days since last order ' || clusters.days_since_order AS prompt FROM clusters), STRUCT(800 AS max_output_tokens, 0.8 AS temperature, 40 AS top_k, 0.8 AS top_p, TRUE AS flatten_json_output));"
		query := fmt.Sprintf(llm_query_template, projectID)
		llm_op := bq.Runf(t, "--project_id=%[1]s --headless=true query --nouse_legacy_sql %[2]s", projectID, query)

		llm_count := llm_op.Get("count_rows").Int()
		assert.Greater(t, llm_count, 0, "The ML.GENERATE_TEXT() query failed")
	})
	dwh.Test()
}
