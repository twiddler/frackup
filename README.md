# Abstract

This describes how to securely backup data on m devices such that any n of them can be used together to recover the data.

# CLI programs used

- tar is probably already included in your distro
- gfsplit, gfcombine are available from `sudo apt install libgfshare-bin`
- par2create, par2verify, par2combine are available from `sudo apt install par2`

# Splitting

1. Archive the plain files
2. Split the archive into m parts such that n of them together can recover the whole archive
3. Protect the archive parts against data rot
4. For i = 0 to m devices, _move_ archive part k_i and its data rot protection files *.tar.[k_i]* to the i-th device

# Recombining

1. Collect n archive parts
2. Verify the parts
3. Recombine the archive from the parts
4. Extract the archive
