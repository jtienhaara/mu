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
all: debian-container

.PHONY: build-debian-container
build-debian-container:
	@DEBIAN_ARCHITECTURE=`./get_debian_architecture.sh` \
	    && VALGRIND_PLATFORM=`./get_valgrind_platform.sh` \
	    && echo "DEBIAN_ARCHITECTURE='$$DEBIAN_ARCHITECTURE'" \
	    && echo "VALGRIND_PLATFORM='$$VALGRIND_PLATFORM'" \
	    && docker build . \
	        --file debian.Dockerfile \
	        --platform "$$DEBIAN_ARCHITECTURE" \
	        --build-arg "VALGRIND_PLATFORM=$$VALGRIND_PLATFORM" \
	        --tag mu-debian:latest

.PHONY: debian-container
debian-container: build-debian-container
	docker run \
	    --rm \
	    --volume `pwd`/..:/mu:rw \
	    mu-debian:latest \
	    bash -c 'make clean && make all'

.PHONY: debian-container-re-version
debian-container-re-version: build-debian-container
	docker run \
	    --rm \
	    --env mu_VERSION=$$mu_VERSION \
	    --volume `pwd`/..:/mu:rw \
	    mu-debian:latest \
	    bash -c 'make re-version'

.PHONY: debian-container-debug
debian-container-debug: build-debian-container
	docker run \
	    --rm \
	    -i --tty \
	    --volume `pwd`/..:/mu:rw \
	    mu-debian:latest \
	    bash -c 'make clean && make build && make all && echo "***** No core dump, no debug *****" || make debug'

.PHONY: debian-container-run
debian-container-run: build-debian-container
	@if test -z "$(MU_SOURCE_FILES)" ; \
	then \
	    echo "Usage: make debian-container-run MU_SOURCE_FILES=\"x.mu y.mu ...\"" >&2 ; \
	    exit 1; \
	fi
	docker run \
	    --rm \
	    --volume `pwd`/..:/mu:ro \
	    mu-debian:latest \
	    /mu/build/mu --tracing $(MU_SOURCE_FILES)
