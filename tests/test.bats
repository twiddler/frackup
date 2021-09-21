setup() {
    load 'bats-support/load'
    load 'bats-assert/load'

    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"

    # make executables in src/ visible to PATH
    PATH="$DIR/../src:$PATH"

    # Create test files
    INDIR="$BATS_RUN_TMPDIR/in"
    mkdir "$INDIR"
    echo "hello world" > "$INDIR/helloworld"

    # Where to save outputs
    PARTSDIR="$BATS_RUN_TMPDIR/parts"

    # Where to recombine parts
    RECOMBINEDDIR="$BATS_RUN_TMPDIR/recombined"
}

@test "Splitting and recombining gives the original files" {
    split.sh "$INDIR" "$PARTSDIR" 2 3
    recombine.sh "$PARTSDIR" "$RECOMBINEDDIR"
    diff -r "$INDIR" "$RECOMBINEDDIR"
}

@test "Fail to recombine if not enough parts" {
    split.sh "$INDIR" "$PARTSDIR" 2 2
    ls -d "$PARTSDIR"/* | tail -n 3 | xargs -n 1 rm
    
    # recombine.sh should exit with an error code
    run recombine.sh "$PARTSDIR" "$RECOMBINEDDIR"
    assert_failure

    # We should not be able to retrieve the original files
    run diff -r "$INDIR" "$RECOMBINEDDIR"
    assert_failure
}

@test "Repair files are allowed to be missing" {
    split.sh "$INDIR" "$PARTSDIR" 2 2

    # Corrupt repair file
    ls -d "$PARTSDIR/"*".vol"*".par2" | tail -n 2 | xargs -n 1 -I{} rm {}
    
    # We should be able to retrieve the original files
    recombine.sh "$PARTSDIR" "$RECOMBINEDDIR"
    diff -r "$INDIR" "$RECOMBINEDDIR"
}

@test "Part file can be corrupted" {
    split.sh "$INDIR" "$PARTSDIR" 2 2

    # Corrupt first part
    ls -d "$PARTSDIR/"*".par2" | head -1 | xargs -n 1 -I{} dd if=/dev/zero of="{}" bs=1 count=1 seek=0 conv=notrunc
    
    # We should be able to retrieve the original files
    recombine.sh "$PARTSDIR" "$RECOMBINEDDIR"
    diff -r "$INDIR" "$RECOMBINEDDIR"
}

@test "Do not split if out directory exists" {
    run split.sh "$INDIR" "$INDIR" 2 3
    assert_failure
}

@test "Do not recombine if out directory exists" {
    split.sh "$INDIR" "$PARTSDIR" 2 3
    run recombine.sh "$PARTSDIR" "$PARTSDIR"
    assert_failure
}

teardown() {
    rm -rf "$INDIR"
    rm -rf "$PARTSDIR"
    rm -rf "$RECOMBINEDDIR"
}