# Abstract

This describes how to securely backup data on m devices such that any n of them can be used together to recover the data.

# CLI programs used

- openssl, pgp, tar are probably already included in your distro
- gfsplit, gfcombine are available from `sudo apt install libgfshare-bin`
- par2create, par2verify, par2combine are available from `sudo apt install par2`

# Splitting

1. Create a password and store it in a file: `openssl rand -base64 32 > password`
2. archive and encrypt the plain files: `tar -c plain | gpg --batch --passphrase-file password --symmetric > plain.tar.gpg`
3. protect the encrypted archive against data rot: `par2create -r100 -n1 plain.tar.gpg`
4. Split the password file into m parts such that n of them together can recover the whole key: `gfsplit -n 2 -m 5 password`
5. for m devices, copy .tar.gpg, .par2, and of the password.[number] part files to the i-th device

# Recombining

1. parchive verify the encrypted archive: `par2verify plain.tar.gpg`. If you have to, `par2repair plain.tar.gpg`.
2. recombine the private key parts: `gfcombine password.*`
3. decrypt and extract the encrypted tarball: `cat plain.tar.gpg | gpg --batch --passphrase-file password --decrypt | tar -x`