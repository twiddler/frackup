#!/bin/bash

# Create a password file
openssl rand -base64 32 > password

# Archive and encrypt the plain files
tar -c plain | gpg --batch --passphrase-file password --symmetric > plain.tar.gpg

# Protect the encrypted archive against data rot
par2create -r100 -n1 plain.tar.gpg

# Split the password file into m parts such that n of them together can recover the whole key
gfsplit -n 2 -m 5 password
