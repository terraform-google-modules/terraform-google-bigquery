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

.PHONY: build test-go test-tf test clean cover docker

all: test build

clean:
	rm -f cover.out
	rm -rf build

build: clean build/darwin/bq-perms build/linux/bq-perms

build/darwin/bq-perms:
	mkdir -p build/darwin
	cd pkg && go build -o ../build/darwin/bq-perms

build/linux/bq-perms:
	mkdir -p build/linux
	cd pkg && env GOOS=linux GOARCH=amd64 go build -o ../build/linux/bq-perms

test-go:
	cd pkg && go test

test-tf:
	./test.sh

test: test-go test-tf

cover:
	cd pkg && \
		go fmt && \
		go test -covermode=count -coverprofile=../cover.out && \
		go tool cover -html=../cover.out

docs:
	terraform-docs md ./ | tail -r | tail -n +2 | tail -r

docker:
	docker run \
		-v `pwd`/build/linux/:/app \
		-it google/cloud-sdk:latest
