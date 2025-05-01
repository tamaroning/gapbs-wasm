# See LICENSE.txt for license details.

ifndef WASI_SDK_PATH
$(error WASI_SDK_PATH is not set)
endif

CXX_WASM = ${WASI_SDK_PATH}/bin/clang++
CXX_FLAGS += -std=c++11 -O3 -Wall
CXX_WASM_FLAGS += -std=c++11 -O3 -Wall -fno-exceptions

KERNELS = bc bfs cc cc_sv pr pr_spmv sssp tc
SUITE = $(addsuffix .wasm, $(KERNELS))


.PHONY: all
all: $(SUITE) converter

%.wasm : src/%.cc src/*.h
	mkdir -p dist & \
	$(CXX_WASM) $(CXX_WASM_FLAGS) $< -o dist/$@

converter: src/converter.cc src/*.h
	$(CXX) $(CXX_FLAGS) $< -o dist/$@

# Testing
include test/test.mk

# Benchmark Automation
include benchmark/bench.mk


.PHONY: clean
clean:
	rm -f $(SUITE) test/out/*
