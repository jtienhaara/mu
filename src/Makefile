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

MU_VERSION ?= 1.0.0
MU_MAJOR ?= $(word 1, $(subst ., ,$(MU_VERSION)))

ORIGINAL_DIR = $(PWD)

BUILD_DIR ?= ../build

#
# Make sure the path we use to load shared libraries is absolute, not relative:
#
MU_LIBRARY_DIR = $(subst $(PWD)//,/,$(PWD)/$(BUILD_DIR))
MU_LIBRARY_PATH = $(if $(LD_LIBRARY_PATH),$(MU_LIBRARY_DIR):$(LD_LIBRARY_PATH),$(MU_LIBRARY_DIR))

#
# Parameters for gcc compiling .c into .o files, .o files into exes, etc:
#
CC = gcc
CFLAGS = -Werror -fPIC -O2
# CFLAGS = -Werror -fPIC -O2 --debug

#
# Dynamically linked library:
#
LD_LIBRARY = gcc
LD_LIBRARY_FLAGS = -shared
LD_PROGRAM = gcc
LD_PROGRAM_FLAGS = -Wl,--no-as-needed \
	-lpcre2-8 \
	-ltree-sitter \
	-lutf8proc \
	-lutf8lex

#
# Statically linked library, executable:
#
LDSTATIC_EXTRACT = ar
LDSTATIC_EXTRACT_FLAGS = -x -o
LDSTATIC_LIBRARY = ar
LDSTATIC_LIBRARY_FLAGS = -c -r -s

#
# The .l lex file gets processed into a C source file.
#
LEX_FILES ?= \
	mu_lex.l

GENERATED_SOURCE_FILES ?= \
	$(patsubst %.l,$(BUILD_DIR)/mu_lex/%.c,$(LEX_FILES))

#
# Do NOT include mu.c (with main()) in SOURCE_FILES:
#
SOURCE_FILES ?= 

GENERATED_OBJECT_FILES = \
	$(patsubst $(BUILD_DIR)/mu_lex/%.c,$(BUILD_DIR)/libmu/%.o,$(GENERATED_SOURCE_FILES))

OBJECT_FILES = \
	$(patsubst %.c,$(BUILD_DIR)/libmu/%.o,$(SOURCE_FILES))

LIBRARY_DYNAMIC = \
	$(BUILD_DIR)/libmu.so.$(MU_VERSION)

LIBRARY_STATIC = \
	$(BUILD_DIR)/libmu.a.$(MU_VERSION)

PROGRAM = \
	$(BUILD_DIR)/mu.$(MU_VERSION)

LC_CTYPE = en_US.UTF-8

.PHONY: all
all: build

# Rule for $(GENERATED_SOURCE_FILES):
$(BUILD_DIR)/mu_lex/%.c: %.l
	mkdir -p $(BUILD_DIR)/mu_lex
	cp $< $(BUILD_DIR)/mu_lex/mu_lex.l
	utf8lex $(BUILD_DIR)/mu_lex/mu_lex.l
	echo '!!! HERE:'; cat $(BUILD_DIR)/mu_lex/mu_lex.c

# Rule for $(GENERATED_OBJECT_FILES):
$(BUILD_DIR)/libmu/%.o: $(BUILD_DIR)/mu_lex/%.c
	mkdir -p $(BUILD_DIR)/libmu
	$(CC) $(CFLAGS) -c $< -o $@

# Rule for $(OBJECT_FILES):
$(BUILD_DIR)/libmu/%.o: %.c
	mkdir -p $(BUILD_DIR)/libmu
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: check_source_files_list
check_source_files_list:
	@for SOURCE_FILE in *.c; \
	do \
	    if test "$$SOURCE_FILE" = '*.c' \
	        -o "$$SOURCE_FILE" = "mu.c"; \
	    then \
	        continue; \
	    fi; \
	    OBJECT_FILE=`echo "$$SOURCE_FILE" | sed 's|\\.[a-zA-Z0-9]$$|\\.o|'`; \
	    if test ! -f "$(BUILD_DIR)/libmu/$$OBJECT_FILE"; \
	    then \
	        echo "ERROR source file $$SOURCE_FILE did not generate an object file $(BUILD_DIR)/libmu/$$OBJECT_FILE.  Is it included in the Makefile?" >&2; \
	        exit 1; \
	    fi; \
	done

# Rule for .so library files:
$(LIBRARY_DYNAMIC): $(GENERATED_OBJECT_FILES) $(OBJECT_FILES) check_source_files_list
	@echo "Building $(LIBRARY_DYNAMIC)..."
	$(LD_LIBRARY) $(LD_LIBRARY_FLAGS)  \
	    -Wl,-soname,libmu.so.$(MU_MAJOR) \
	    $(GENERATED_OBJECT_FILES) \
	    $(OBJECT_FILES) \
	    -o $(LIBRARY_DYNAMIC)
	chmod a+x $(LIBRARY_DYNAMIC)
	cd $(BUILD_DIR) \
	    && if test "$(MU_MAJOR)" != "$(MU_VERSION)" ; \
                then \
	            ln -s -f libmu.so.$(MU_VERSION) \
	                libmu.so.$(MU_MAJOR) ; \
	        fi \
	    && ln -s -f libmu.so.$(MU_VERSION) \
	        libmu.so
	@echo "SUCCESS Building $(LIBRARY_DYNAMIC)."

# Rule for .a library files:
$(LIBRARY_STATIC): $(GENERATED_OBJECT_FILES) $(OBJECT_FILES) check_source_files_list
	@echo "Building $(LIBRARY_STATIC)..."
	for LIBUTF8PROC in `find /usr/lib -type f -name 'libutf8proc.a'` ; \
	    do \
	        echo "Copying libutf8proc to extract from: $$LIBUTF8PROC" \
	        && rm -rf $(BUILD_DIR)/libutf8proc \
	        && mkdir -p $(BUILD_DIR)/libutf8proc \
	        && cp "$$LIBUTF8PROC" $(BUILD_DIR)/libutf8proc/ ; \
	    done
	cd $(BUILD_DIR)/libutf8proc \
	    && $(LDSTATIC_EXTRACT) $(LDSTATIC_EXTRACT_FLAGS) libutf8proc.a \
	    && rm libutf8proc.a
	cd "$(ORIGINAL_DIR)"
	for LIBPCRE2 in `find /usr/lib -type f -name 'libpcre2-8.a'` ; \
	    do \
	        echo "Copying libpcre2-8 to extract from: $$LIBPCRE2" \
	        && rm -rf $(BUILD_DIR)/libpcre2-8 \
	        && mkdir -p $(BUILD_DIR)/libpcre2-8 \
	        && cp "$$LIBPCRE2" $(BUILD_DIR)/libpcre2-8/ ; \
	    done
	cd $(BUILD_DIR)/libpcre2-8 \
	    && $(LDSTATIC_EXTRACT) $(LDSTATIC_EXTRACT_FLAGS) libpcre2-8.a \
	    && rm libpcre2-8.a
	cd "$(ORIGINAL_DIR)"
	$(LDSTATIC_LIBRARY) $(LDSTATIC_LIBRARY_FLAGS)  \
	    $(LIBRARY_STATIC) \
	    $(GENERATED_OBJECT_FILES) \
	    $(OBJECT_FILES) \
	    $(BUILD_DIR)/libutf8proc/* \
	    $(BUILD_DIR)/libpcre2-8/*
	chmod a+x $(LIBRARY_STATIC)
	cd $(BUILD_DIR) \
	    && if test "$(MU_MAJOR)" != "$(MU_VERSION)" ; \
                then \
	            ln -s -f libmu.a.$(MU_VERSION) \
	                libmu.a.$(MU_MAJOR) ; \
	        fi \
	    && ln -s -f libmu.a.$(MU_VERSION) \
	        libmu.a
	@echo "SUCCESS Building $(LIBRARY_STATIC)."

# Rules for $(PROGRAM):
$(BUILD_DIR)/libmu/mu.o: mu.c
	mkdir -p $(BUILD_DIR)/libmu
	$(CC) $(CFLAGS) -c $< -o $@

#
# We statically link the library object files, along with mu.o,
# into the executable (but use dynamically linked libpcre2-8.so
# and libutf8proc.so), so that most operating system distributions
# will run mu out of the box, no dynamic library install required.
#
$(PROGRAM): $(GENERATED_OBJECT_FILES) $(OBJECT_FILES) $(BUILD_DIR)/libmu/mu.o
	@echo "Building $(PROGRAM)..."
	$(LD_PROGRAM) $(LD_PROGRAM_FLAGS) $^ -o $@
	cd $(BUILD_DIR) \
	    && if test "$(MU_MAJOR)" != "$(MU_VERSION)" ; \
                then \
	            ln -s -f mu.$(MU_VERSION) \
	                mu.$(MU_MAJOR) ; \
	        fi \
	    && ln -s -f mu.$(MU_VERSION) \
	        mu
	@echo "SUCCESS Building $(PROGRAM)."

.PHONY: build
build: $(LIBRARY_DYNAMIC) $(LIBRARY_STATIC) $(PROGRAM)

#
# E.g.: make re-version MU_VERSION=1.2.3
#
# To make the release process (Docker within GitHub Actions)
# less excruciatingly painful (but still excruciatingly painful),
# we re-use the .a file generated during the last commit to the main
# branch, but then explode it, and re-build the .o files into
# a newly versioned .so dynamic library.
#
# GitHub Actions has to copy the previously-built static library
# (build/libmu.a.(githuba_hash).(debian_architecture)),
# and rename it to the new version (build/libmu.a.1.2.3
# with no architecture in the name), to produce the .so being built
# (build/libmu.so.1.2.3).
#
.PHONY: re-version-explode-archive
re-version-explode-archive:
	@if test -z "$(MU_VERSION)" ; \
	then \
	    echo "ERROR Cannot re-version to MU_VERSION='$(MU_VERSION)'" >&2 ; \
	    exit 1; \
	fi
	@echo "Exploding archive to re-version $(MU_VERSION)..."
	@if test ! -f "$(LIBRARY_STATIC)"; \
	then \
	    echo "ERROR $(LIBRARY_STATIC) does not exist" >&2; \
	    echo "ERROR Copy previously built .a to $(LIBRARY_STATIC) and try again" >&2; \
	    exit 1; \
	fi
	rm -rf $(BUILD_DIR)/libmu
	mkdir -p $(BUILD_DIR)/libmu
	cd $(BUILD_DIR)/libmu \
	    && $(LDSTATIC_EXTRACT) $(LDSTATIC_EXTRACT_FLAGS) \
	        ../libmu.a.$(MU_VERSION)
	cd "$(ORIGINAL_DIR)"
	touch $(BUILD_DIR)/libmu/*.o
	@echo "SUCCESS Exploding archive to re-version $(MU_VERSION)."

.PHONY: re-version
re-version: re-version-explode-archive $(LIBRARY_DYNAMIC) $(PROGRAM)

.PHONY: clean
clean:
	rm -f core
	rm -f $(GENERATED_SOURCE_FILES)
	rm -f $(GENERATED_OBJECT_FILES)
	rm -f $(OBJECT_FILES)
	rm -rf \
	    $(BUILD_DIR)/libpcre2-8/ \
	    $(BUILD_DIR)/libmu/ \
	    $(BUILD_DIR)/libutf8proc/ \

	rm -f \
	    $(LIBRARY_DYNAMIC) \
	    $(BUILD_DIR)/libmu.so.$(MU_MAJOR) \
	    $(BUILD_DIR)/libmu.so \
	    $(LIBRARY_STATIC) \
	    $(BUILD_DIR)/libmu.a.$(MU_MAJOR) \
	    $(BUILD_DIR)/libmu.a \
	    $(BUILD_DIR)/mu.$(MU_VERSION) \
	    $(BUILD_DIR)/mu.$(MU_MAJOR) \
	    $(BUILD_DIR)/mu
