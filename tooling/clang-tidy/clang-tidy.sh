#!/bin/bash

CHECKS=${1:-}
HEADER_FILTER=${2:-.*}
MESON_BUILD_ROOT=${MESON_BUILD_ROOT:-./buildresults}

cd "${MESON_BUILD_ROOT}"
sed -i.bak 's/-pipe//g' compile_commands.json

echo clang-tidy -quiet -checks=${CHECKS} -header-filter=${HEADER_FILTER} -p ${MESON_BUILD_ROOT} ${@:3}
