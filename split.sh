#!/bin/bash

# Archive the plain files
tar -c plain > plain.tar

# Split the archive into m parts such that n of them together can recover the whole archive
gfsplit -n 2 -m 3 plain.tar

# Protect the parts against data rot
for filename in ./plain.tar.*
do
    par2create -r100 -n1 -q "${filename}"
done
