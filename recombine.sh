#!/bin/bash

IN=$1 # must be a directory
OUT=$2 # must be a directory (need not exist)

parts=$(find $IN -type f -and -name "*.tar.*" -and -not -name "*.par2")

# Verify each part
echo $parts | xargs --max-args=1 par2repair -q

# Recombine and extract the whole archive
mkdir $OUT
echo $parts | xargs gfcombine -o - | tar --extract --bzip2 --directory=$OUT
