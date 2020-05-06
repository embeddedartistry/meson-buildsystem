#!/bin/bash

# You can append arguments by adding them to the script invocation

MESON_SOURCE_ROOT=${MESON_SOURCE_ROOT:-./}

cd "${MESON_SOURCE_ROOT}"

lizard -x "./buildresults/*" -x "./dependencies/*" -x "./subprojects/*" \
	--length 75 --CCN 10 --arguments 10 \
	"$@"
