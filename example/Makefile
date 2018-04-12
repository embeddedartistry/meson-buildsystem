# This makefile is used to provide convenient access to the generated  makefile
# This makefile would go at your project root

ifeq ($(OS),Windows_NT)
    detected_OS := Windows
else
    detected_OS := $(shell sh -c 'uname -s 2>/dev/null || echo NotDetected')
endif

ifeq ($(detected_OS), "Windows")
	premake_BIN := premake5.exe
else
	premake_BIN := premake5
endif

# Specify the premake file to build. By default, we'll try to use the example.
PREMAKE_FILE ?= build/example/premake5.lua

# Export all args to act as a passthrough
export

all: build

.PHONY: build_gen
build_gen:
	@echo "Detected OS: ${detected_OS}. Using Premake binary: build/bin/${detected_OS}/${premake_BIN}"
	@build/bin/${detected_OS}/${premake_BIN} --file=premake5.lua gmake

.PHONY: build
build: build_gen
	@make -C build/gen/

.PHONY: help
help: build_gen
	@make -C build/gen/ help

.PHONY: clean
clean:
	@make -C build/gen/ clean
	@rm -rf buildresults

.PHONY: purify
purify:
	@rm -rf build/gen

.PHONY: regen
regen:
	@build/bin/premake5 --file=build/premake5.lua gmake


