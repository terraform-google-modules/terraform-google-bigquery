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

// Access - BigQuery access JSON structure
type Access struct {
	Domain       string `json:"domain,omitempty"`
	GroupByEmail string `json:"groupByEmail,omitempty"`
	Role         string `json:"role,omitempty"`
	SpecialGroup string `json:"specialGroup,omitempty"`
	UserByEmail  string `json:"userByEmail,omitempty"`
	View         *View  `json:"view,omitempty"`
}

// BuildAccess creates an access control list from an InputEnv
func BuildAccess(env InputEnv) []Access {
	access := make([]Access, 0)
	access = appendSpecialGroups(access, env)
	access = appendRoles(access, env)
	access = appendViews(access, env)

	return access
}

func appendViews(access []Access, env InputEnv) []Access {
	for i := 0; i < len(env.views); i++ {
		view := env.views[i]
		access = append(access, view)
	}

	return access
}

func appendRoles(access []Access, env InputEnv) []Access {
	for i := 0; i < len(env.roles); i++ {
		role := env.roles[i]
		access = append(access, role)
	}

	return access
}

func appendSpecialGroups(access []Access, env InputEnv) []Access {
	if env.preserveGroups {
		groups := []Access{
			Access{Role: "OWNER", SpecialGroup: "projectOwners"},
			Access{Role: "WRITER", SpecialGroup: "projectWriters"},
			Access{Role: "READER", SpecialGroup: "projectReaders"},
		}

		for i := 0; i < len(groups); i++ {
			access = append(access, groups[i])
		}
	}

	return access
}
