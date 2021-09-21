#!/usr/bin/env bash

IN=$1 # must be a directory
OUT=$2 # must be a directory (need not exist)

# Require exactly 2 arguments
if [ $# -ne 2 ]; then
    >&2 echo "Usage: $0 in out"
    exit 3
fi

# First argument `in` must be a directory
if [ ! -d "$IN" ]; then
    >&2 echo "$IN is not a directory"
    exit 1
fi

# Second argument `out` must not exist
if ! mkdir "$OUT"; then
    >&2 echo "$OUT must not exist"
    exit 1
fi
rmdir "$OUT"

parts=$(find $IN -type f -and -name "*.tar.*" -and -not -name "*.par2")

# Verify each part
echo $parts | xargs --max-args=1 par2repair -q

# Recombine and extract the whole archive
mkdir $OUT
echo $parts | xargs gfcombine -o - | tar --extract --bzip2 --directory=$OUT
