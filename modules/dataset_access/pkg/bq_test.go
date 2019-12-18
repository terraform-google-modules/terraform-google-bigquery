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
	"os"
	"testing"
)

func rolesJSON() string {
	return "[{\"role\": \"READER\", \"userByEmail\": \"foo@bar.com\"}]"
}

func viewsJSON() string {
	return "[{\"dataset\": \"view-dataset\", \"project\": \"view-project\", \"table\": \"view-table\"}]"
}

func setEnv() {
	os.Setenv("TARGET_PROJECT_ID", "my-project")
	os.Setenv("TARGET_DATASET_ID", "my-dataset")
	os.Setenv("PRESERVE_GROUPS", "false")
	os.Setenv("ROLES", rolesJSON())
	os.Setenv("VIEWS", viewsJSON())
}

func clearEnv(name string) {
	os.Setenv(name, "")
}

func TestParseEnv(t *testing.T) {
	t.Run("when TARGET_PROJECT_ID is set", func(t *testing.T) {
		setEnv()
		got, _ := ParseEnv()

		if got.projectID != "my-project" {
			t.Errorf("got '%s' want 'my-project'", got.projectID)
		}
	})

	t.Run("when TARGET_PROJECT_ID is not set", func(t *testing.T) {
		clearEnv("TARGET_PROJECT_ID")
		_, err := ParseEnv()

		got := err

		want := BadInputError{field: "TARGET_PROJECT_ID", message: "is required"}

		if got != want {
			t.Errorf("got '%s' want '%s'", got, want)
		}
	})

	t.Run("when TARGET_DATASET_ID is set", func(t *testing.T) {
		setEnv()
		got, _ := ParseEnv()

		if got.datasetID != "my-dataset" {
			t.Errorf("got '%s' want 'my-dataset'", got.datasetID)
		}
	})

	t.Run("when TARGET_DATASET_ID is not set", func(t *testing.T) {
		clearEnv("TARGET_DATASET_ID")
		_, err := ParseEnv()

		got := err

		want := BadInputError{field: "TARGET_DATASET_ID", message: "is required"}

		if got != want {
			t.Errorf("got '%s' want '%s'", got, want)
		}
	})

	t.Run("PRESERVE_GROUPS is false", func(t *testing.T) {
		setEnv()
		env, _ := ParseEnv()
		got := env.preserveGroups
		want := false

		if got != want {
			t.Errorf("got '%+v' want '%+v'", got, want)
		}
	})

	t.Run("when PRESERVE_GROUPS is not set, defaults to true", func(t *testing.T) {
		clearEnv("PRESERVE_GROUPS")
		env, _ := ParseEnv()
		got := env.preserveGroups
		want := true

		if got != want {
			t.Errorf("got '%+v' want '%+v'", got, want)
		}
	})

	t.Run("when ROLES is set, parses the roles", func(t *testing.T) {
		setEnv()
		env, _ := ParseEnv()
		got := env.roles[0]
		want := Access{
			Role:        "READER",
			UserByEmail: "foo@bar.com",
		}

		if got != want {
			t.Errorf("got '%+v' want '%+v'", got, want)
		}
	})

	t.Run("when ROLES is not set, returns an empty slice", func(t *testing.T) {
		clearEnv("ROLES")
		env, err := ParseEnv()
		got := len(env.roles)
		want := 0

		if err != nil {
			t.Fatal("Did not expect an error")
		}

		if got != want {
			t.Errorf("got '%+v' want '%+v'", got, want)
		}
	})

	t.Run("when VIEWS is set, parses the views", func(t *testing.T) {
		setEnv()
		env, _ := ParseEnv()
		got := *env.views[0].View
		want := View{
			ProjectID: "view-project",
			DatasetID: "view-dataset",
			TableID:   "view-table",
		}

		if got != want {
			t.Errorf("got '%+v' want '%+v'", got, want)
		}
	})

	t.Run("when VIEWS is not set, returns an empty slice", func(t *testing.T) {
		clearEnv("VIEWS")
		env, err := ParseEnv()
		got := len(env.views)
		want := 0

		if err != nil {
			t.Fatal("Did not expect an error")
		}

		if got != want {
			t.Errorf("got '%+v' want '%+v'", got, want)
		}
	})
}
