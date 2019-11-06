/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package main

import (
	"testing"
)

func makeRoles() []Access {
	roles := make([]Access, 0, 1)
	role := Access{
		Role:        "READER",
		UserByEmail: "foo@example.com",
	}

	return append(roles, role)
}

func makeViews() []Access {
	views := make([]Access, 0, 1)
	view := Access{
		View: &View{
			ProjectID: "view-project",
			DatasetID: "view-dataset",
			TableID:   "view-table",
		},
	}

	return append(views, view)
}

func TestBuildAccess(t *testing.T) {
	t.Run("when preserving special groups", func(t *testing.T) {
		env := InputEnv{
			projectID:      "foo",
			datasetID:      "bar",
			preserveGroups: true,
		}

		got := BuildAccess(env)
		got0 := got[0].SpecialGroup
		got1 := got[1].SpecialGroup
		got2 := got[2].SpecialGroup

		want0 := "projectOwners"
		if got0 != want0 {
			t.Errorf("got '%s' want '%s'", got0, want0)
		}

		want1 := "projectWriters"
		if got1 != want1 {
			t.Errorf("got '%s' want '%s'", got1, want1)
		}

		want2 := "projectReaders"
		if got2 != want2 {
			t.Errorf("got '%s' want '%s'", got2, want2)
		}
	})

	t.Run("when excluding special groups", func(t *testing.T) {
		env := InputEnv{
			projectID:      "foo",
			datasetID:      "bar",
			preserveGroups: false,
		}

		got := len(BuildAccess(env))
		want := 0

		if got != want {
			t.Errorf("got '%d' want '%d'", got, want)
		}
	})

	t.Run("when providing roles", func(t *testing.T) {
		env := InputEnv{
			projectID:      "foo",
			datasetID:      "bar",
			preserveGroups: false,
			roles:          makeRoles(),
		}

		access := BuildAccess(env)
		got := access[0].Role
		want := "READER"

		if got != want {
			t.Errorf("got '%s' want '%s'", got, want)
		}
	})

	t.Run("when providing views", func(t *testing.T) {
		env := InputEnv{
			projectID:      "foo",
			datasetID:      "bar",
			preserveGroups: false,
			views:          makeViews(),
		}

		access := BuildAccess(env)
		got := *access[0].View
		want := View{
			ProjectID: "view-project",
			DatasetID: "view-dataset",
			TableID:   "view-table",
		}

		if got != want {
			t.Errorf("got '%s' want '%s'", got, want)
		}
	})

	t.Run("when preserving, specifying roles, and specifying views", func(t *testing.T) {
		env := InputEnv{
			projectID:      "foo",
			datasetID:      "bar",
			preserveGroups: true,
			views:          makeViews(),
			roles:          makeRoles(),
		}

		acl := BuildAccess(env)
		got := len(acl)
		want := 5

		if got != want {
			t.Errorf("got '%d' want '%d'", got, want)
		}
	})
}
