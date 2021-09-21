#!/usr/bin/env bash

IN=$1 # must be a directory
OUT=$2 # must be a directory (need not exist)
THRESHOLD=$3 # must be >= 2 and <= $PARTS
PARTS=$4

# Require exactly 4 arguments
if [ $# -ne 4 ]; then
    >&2 echo "Usage: $0 in out n m"
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

# Third argument `n` must be a number > 0
re='^[1-9][0-9]*$'
if ! [[ $THRESHOLD =~ $re ]] ; then
   >&2 echo "Error: $THRESHOLD must be a number > 0"
   exit 1
fi

# Fourth argument `m` must be a number >= `n` > 0
if ! [[ $PARTS =~ $re ]] ; then
   >&2 echo "Error: $PARTS must be a number > 0"
   exit 1
fi
if [ $PARTS -lt $THRESHOLD ]; then
   >&2 echo "Error: $PARTS must be a number >= $THRESHOLD"
   exit 1
fi

# Archive the input
mkdir $OUT
TAR_NAME=$(basename $IN)
tar --create --bzip2 -C $IN . > $OUT/$TAR_NAME.tar

# Split the archive into m parts such that n of them together can recover the whole archive
gfsplit -n $THRESHOLD -m $PARTS $OUT/$TAR_NAME.tar
rm $OUT/$TAR_NAME.tar

# Protect the parts against data rot
for filename in $OUT/$TAR_NAME.tar.*
do
    echo "${filename}"
    par2create -r100 -n1 -q "${filename}"
done

echo ""
echo "Split $IN into $PARTS parts. You will need $THRESHOLD parts for recovering your files."
echo -e "\e[33mTAKE CARE: Remember to remove your plain copy of the files if you do not want to keep them unprotected.\e[0m"
