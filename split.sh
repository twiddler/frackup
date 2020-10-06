#!/bin/bash

IN=$1 # must be a directory
OUT=$2 # must be a directory (need not exist)
THRESHOLD=$3 # must be >= 2 and <= $PARTS
PARTS=$4

# Archive the input
mkdir $OUT
tar --create --bzip2 $IN > $OUT/$IN.tar

# Split the archive into m parts such that n of them together can recover the whole archive
gfsplit -n $THRESHOLD -m $PARTS $OUT/$IN.tar
rm $OUT/$IN.tar

# Protect the parts against data rot
for filename in $OUT/$IN.tar.*
do
    par2create -r100 -n1 -q "${filename}"
done

echo ""
echo "Split $IN into $PARTS parts. You will need $THRESHOLD parts for recovering your files."
echo -e "\e[33mTAKE CARE: Remember to remove your plain copy of the files if you do not want to keep them unprotected.\e[0m"
