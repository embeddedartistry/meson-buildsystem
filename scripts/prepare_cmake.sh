#!/bin/bash

# $1 = output directory
# remaining arguments are forwarded to Cmake

OUTPUT_DIR=$1; shift

if [ ! -d "$OUTPUT_DIR" ]; then
	mkdir -p $OUTPUT_DIR
fi

if [ ! -f "$OUTPUT_DIR/CMakeCache.txt" ]; then
	cmake $@
fi
