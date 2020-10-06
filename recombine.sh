#!/bin/bash

parts=$(find -type f -and -name "*.tar.*" -and -not -name "*.par2")

# Verify each part
echo $parts | xargs --max-args=1 par2repair -q

# Recombine and extract the whole archive
echo $parts | xargs gfcombine -o - | tar -x
