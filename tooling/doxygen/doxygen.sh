#!/bin/bash

export ARCHITECTURE=${1:-x86_64}
MESON_SOURCE_ROOT=${MESON_SOURCE_ROOT:-./}

cd "${MESON_SOURCE_ROOT}"

ARCHITECTURE=${ARCHITECTURE} doxygen docs/Doxyfile
