/*
Copyright 2019 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package main

import (
	"encoding/json"
	"os"
)

// View nested group;
type View struct {
	ProjectID string `json:"projectId"`
	DatasetID string `json:"datasetId"`
	TableID   string `json:"tableId"`
}

// ParseViews parses a serialized JSON array of terraform module 'views' to BigQuery API JSON structure
func ParseViews() ([]Access, error) {
	var views []map[string]interface{}
	var viewsArg = os.Getenv("VIEWS")
	if viewsArg == "" {
		viewsArg = "[]"
	}

	err := json.Unmarshal([]byte(viewsArg), &views)

	acl := make([]Access, 0)
	for i := 0; i < len(views); i++ {
		view := View{
			ProjectID: views[i]["project"].(string),
			DatasetID: views[i]["dataset"].(string),
			TableID:   views[i]["table"].(string),
		}
		access := Access{View: &view}
		acl = append(acl, access)
	}

	return acl, err
}
