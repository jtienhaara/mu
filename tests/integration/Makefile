MU_DIR ?= ../..
TEST_BUILD_DIR ?= ../build

.PHONY: all
all: build run

.PHONY: build
build:

.PHONY: run
run: test001

test001:
	mkdir -p $(TEST_BUILD_DIR)
	rm -f $(TEST_BUILD_DIR)/actual001.txt
	/mu/build/mu ./test001.mu > $(TEST_BUILD_DIR)/actual001.txt
	@diff ./expected001.txt $(TEST_BUILD_DIR)/actual001.txt \
	    > $(TEST_BUILD_DIR)/diff001.txt \
	    2>&1 \
	    || echo '------------------------------------------------------------------------'
	@if test -s $(TEST_BUILD_DIR)/diff001.txt; \
            then \
	        echo "ERROR Failed test001.mu: expected001.txt != actual001.txt" >&2 ; \
	        cat $(TEST_BUILD_DIR)/diff001.txt >&2 ; \
	        echo '------------------------------------------------------------------------'; \
	        exit 1 ; \
	    fi
