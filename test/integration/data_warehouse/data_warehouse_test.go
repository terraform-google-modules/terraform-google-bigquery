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
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestDataWarehouse(t *testing.T) {
	dwh := tft.NewTFBlueprintTest(t)

	dwh.DefineVerify(func(assert *assert.Assertions) {
		dwh.DefaultVerify(assert)

		projectID := dwh.GetTFSetupStringOutput("project_id")
		bucket := dwh.GetStringOutput("raw_bucket")

		bucketOP := gcloud.Runf(t, "storage buckets describe gs://%s --project %s", bucket, projectID)
		assert.Equal("US-CENTRAL1", bucketOP.Get("location").String(), "should be in us-central1")
		assert.Equal("STANDARD", bucketOP.Get("storageClass").String(), "should have standard storageClass")
		//TODO: Add additional asserts for other resources
	})
	dwh.Test()
}
