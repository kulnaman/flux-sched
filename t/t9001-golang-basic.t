#!/bin/sh

test_description='Test Golang Bindings On Tiny Machine Configuration'

. $(dirname $0)/sharness.sh

if test -z "$WITH_GO"; then
    skip_all='skipping Golang tests since WITH_GO not set'
    test_done
fi

if ! which go >/dev/null; then
    skip_all='skipping Golang tests since no go executable found'
    test_done
fi

export LD_LIBRARY_PATH=../../resource/reapi/bindings

exp_dir="${SHARNESS_TEST_SRCDIR}/data/resource/expected/golang"
jgf="${SHARNESS_TEST_SRCDIR}/data/resource/jgfs/tiny.json"
jobspec1="${SHARNESS_TEST_SRCDIR}/data/resource/jobspecs/basics/test001.yaml"
jobspec2="${SHARNESS_TEST_SRCDIR}/data/resource/jobspecs/basics/test003.yaml"
main="../../resource/reapi/bindings/go/src/test/main"
root="../../resource/reapi/bindings/go/src"

test001_desc="match allocate 1 slot: 1 socket: 1 core (pol=default)"
test_expect_success "${test001_desc}" '
    ${main} --jgf=${jgf} --jobspec=${jobspec1} > 001.R.out &&
    sed -i -E "s/, 0\.[0-9]+//g" 001.R.out &&
    test_cmp 001.R.out ${exp_dir}/001.R.out
'

test002_desc="match allocate 2 slots: 2 sockets: 5 cores 1 gpu 6 memory"
test_expect_success "${test002_desc}" '
    ${main} --jgf=${jgf} --jobspec=${jobspec2} > 002.R.out &&
    sed -i -E "s/, 0\.[0-9]+//g" 002.R.out &&
    test_cmp 002.R.out ${exp_dir}/002.R.out
'

# Assume running in subshell, don't need to chdir back
test003_desc="test pkg/types/types_test.go"
test_expect_success "${test003_desc}" '
    cd ${root}/pkg/types
    go test -v
'


test_done
