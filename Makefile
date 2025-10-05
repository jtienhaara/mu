#
# mu
# Copyright © 2025 Johann Tienhaara
# All rights reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

MU_SOURCE_FILES ?= 

.PHONY: all
all: build test examples

.PHONY: build-debian-container
build-debian-container:
	cd ci \
	    && make build-debian-container

.PHONY: debian-container
debian-container:
	cd ci \
	    && make debian-container

.PHONY: debian-container-re-version
debian-container-re-version:
	cd ci \
	    && make debian-container-re-version

.PHONY: debian-container-debug
debian-container-debug:
	cd ci \
	    && make debian-container-debug

.PHONY: debian-container-run
debian-container-run:
	cd ci \
	    && make debian-container-run MU_SOURCE_FILES="$(MU_SOURCE_FILES)"

.PHONY: build
build:
	cd src \
	    && make build

.PHONY: test
test: unit_tests integration_tests

.PHONY: unit_tests
unit_tests:
# !!! 	cd tests/unit \
# !!! 	    && make build \
# !!! 	    && make run

.PHONY: integration_tests
integration_tests:
	cd tests/integration \
	    && make build \
	    && make run

.PHONY: examples
examples:
# !!! 	cd examples \
# !!! 	    && make build \
# !!! 	    && make run

.PHONY: re-version
re-version:
	cd src \
	    && make re-version

.PHONY: debug
debug:
# !!! 	cd tests/integration \
# !!! 	    && make build \
# !!! 	    && make debug

.PHONY: clean
clean:
	cd src \
	    && make clean
# !!! 	cd tests/unit \
# !!! 	    && make clean
# !!! 	cd tests/integration \
# !!! 	    && make clean
# !!! 	cd examples \
# !!! 	    && make clean
