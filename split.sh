#!/bin/bash

PARTS=3
THRESHOLD=2
INPUT=$1

# Archive the plain files
tar -c $INPUT > $INPUT.tar

# Split the archive into m parts such that n of them together can recover the whole archive
gfsplit -n $THRESHOLD -m $PARTS $INPUT.tar

# Protect the parts against data rot
for filename in ./$INPUT.tar.*
do
    par2create -r100 -n1 -q "${filename}"
done

echo ""
echo "Split $INPUT into $PARTS parts. You will need $THRESHOLD parts for recovering your files."
echo -e "\e[33mTAKE CARE: Remember to remove your plain copy of the files if you do not want to keep them unprotected.\e[0m"
