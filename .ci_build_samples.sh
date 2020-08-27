#!/bin/sh
set -e

if [ $(uname) = 'Darwin' ]; then
    NUMCORES=$(sysctl -n hw.logicalcpu)
else
    NUMCORES=$(nproc)
fi

cmake -B build -DNXDK_BUILD_SAMPLES=ON .
cmake --build . -- -j${NUMCORES}
