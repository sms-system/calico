#! /bin/bash

cleanup() {
    cp -a /src/calico/felix/report/. /src/calico/felix/artifacts
    ./.semaphore/publish-artifacts-argoci
}


checkExitCode() {
    last_command=$1
    exit_code=$2
    if [ $2 -ne 0 ]; then
        export CI_EXIT_CODE=1
        echo "[ ERR] '${last_command}' failed"
        return 1
    fi
    echo "[INFO] '${last_command}' succeeded"
}

cd felix

make build image fv-prereqs
checkExitCode "!!" $? || return 0

# 'cache store bin-${SEMAPHORE_GIT_SHA} bin'
# 'cache store fv.test-${SEMAPHORE_GIT_SHA} fv/fv.test'
# cache store go-pkg-cache .go-pkg-cache
# 'cache store go-mod-cache ${HOME}/go/pkg/mod/cache'
mkdir -p /src/dockerimages
docker save -o /src/dockerimages/calico-felix.tar calico/felix:latest-amd64
# 'cache store felix-image-${SEMAPHORE_GIT_SHA} /tmp/calico-felix.tar'
docker save -o /src/dockerimages/felixtest-typha.tar felix-test/typha:latest-amd64
#'cache store felixtest-typha-image-${SEMAPHORE_GIT_SHA} /tmp/felixtest-typha.tar'

../.semaphore/run-and-monitor ut.log make ut
checkExitCode $? || return 0
../.semaphore/run-and-monitor k8sfv-typha.log make k8sfv-test JUST_A_MINUTE=true USE_TYPHA=true
checkExitCode $? || return 0
../.semaphore/run-and-monitor k8sfv-no-typha.log make k8sfv-test JUST_A_MINUTE=true USE_TYPHA=false
checkExitCode $? || return 0