# This helps you with ...

... securely backing up data on _m_ devices such that any _n_ of them can be used together to recover the data. No need to remember passwords. No need to trust each individual device or environment.

## Usage

`./src/split.sh in out n m` archives input directory `in`, splits it into `m` parts of which `n` are sufficient for recombination, and saves them including recovery files at `out`.

`./src/recombine.sh in out` repairs (if necessary) and combines parts from `in` and outputs the result at `out`.

(Note that you can hand more than 1 part to a single device if you trust it more than others. For example, you could store 2 parts on device A and 1 part on each of devices B and C, and require 3 parts for recovering your files.)

## CLI programs used

- `tar` is probably already included in your distro
- `gfsplit`, `gfcombine` are available from `sudo apt install libgfshare-bin`
- `par2create`, `par2verify`, `par2combine` are available from `sudo apt install par2`

## Algorithm for splitting

1. Archive the plain files
2. Split the archive into _m_ parts such that _n_ of them together can recover the whole archive
3. Protect the archive parts against data rot
4. For _i_ = 0 to _m_ devices, **manually move** archive part _k_i_ and its data rot protection files \*.tar.[_k\_i_]\* to the _i_-th device

Steps 1 to 3 are executed by `./src/split.sh`. Step 4 has to be carried out by you.

## Algorithm for recombining

1. Collect _n_ archive parts
2. Verify the parts
3. Recombine the archive from the parts
4. Extract the archive

Step 1 has to be carried out by you. Steps 2 to 4 are executed by `./src/recombine.sh`.

# Tests

Run `./scripts/test.sh` to run the [`bats`](https://github.com/bats-core/bats-core) tests in a Ubuntu environment with the necessary libraries. Requires [`docker-compose`](https://docs.docker.com/compose/), which in turn requires super-user privileges (i.e. you will be prompted by `sudo`).
