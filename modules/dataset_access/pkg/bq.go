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
	"fmt"
	"os"
	"os/exec"
	"strconv"

	log "github.com/sirupsen/logrus"
)

func init() {
	log.SetOutput(os.Stdout)
	log.SetLevel(log.InfoLevel)
}

// InputEnv is the input ENV to this script
type InputEnv struct {
	projectID      string
	datasetID      string
	preserveGroups bool
	roles          []Access
	views          []Access
}

func main() {
	log.Info("Staring bq-perms")
	env, err := ParseEnv()

	if err != nil {
		log.Error("Error parsing ENV")
		log.Fatal(err)
	}

	access := BuildAccess(env)
	UpdateBigQuery(env, access)
}

// ParseEnv parses required ENV variables
func ParseEnv() (InputEnv, error) {
	var env InputEnv
	var err error

	projectID := os.Getenv("TARGET_PROJECT_ID")
	if projectID == "" {
		return env, BadInputError{field: "TARGET_PROJECT_ID", message: "is required"}
	}

	datasetID := os.Getenv("TARGET_DATASET_ID")
	if datasetID == "" {
		return env, BadInputError{field: "TARGET_DATASET_ID", message: "is required"}
	}

	preserveGroups, err := strconv.ParseBool(os.Getenv("PRESERVE_GROUPS"))
	if err != nil {
		preserveGroups = true
	}

	views, err := ParseViews()
	if err != nil {
		return env, BadInputError{field: "VIEWS", message: err.Error()}
	}

	roles, err := ParseRoles()
	if err != nil {
		return env, BadInputError{field: "ROLES", message: err.Error()}
	}

	env = InputEnv{
		projectID:      projectID,
		datasetID:      datasetID,
		preserveGroups: preserveGroups,
		roles:          roles,
		views:          views,
	}

	return env, nil
}

func logFatal(label string, err error, out []byte) {
	if err != nil {
		log.Fatalf("`bq` %s error: %s", label, string(out))
		log.Fatal(err)
	}
}

func getDataset(projectID string, datasetID string) map[string]interface{} {
	stdout, err := exec.
		Command(bqPath(), "--format=prettyjson", fmt.Sprintf("--project_id=%s", projectID), "show", datasetID).
		Output()

	logFatal("show", err, stdout)

	var bigQueryPayload map[string]interface{}
	err = json.Unmarshal(stdout, &bigQueryPayload)

	logFatal("parsing", err, stdout)
	return bigQueryPayload
}

func UpdateBigQuery(env InputEnv, acl []Access) {
	bigQueryPayload := getDataset(env.projectID, env.datasetID)
	bigQueryPayload["access"] = acl

	jsonTempFile := MakeTempFile(bigQueryPayload)
	defer os.Remove(jsonTempFile)

	updateBigQueryAccess(jsonTempFile, env.projectID, env.datasetID)
}

func updateBigQueryAccess(source string, projectID string, datasetID string) {
	stdout, err := exec.
		Command(bqPath(), "update", fmt.Sprintf("--source=%s", source), fmt.Sprintf("--project_id=%s", projectID), datasetID).
		Output()

	logFatal("updating", err, stdout)
}

func bqPath() string {
	return os.Getenv("BQ_PATH")
}
