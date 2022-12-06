#! /bin/bash

cleanup() {
    ./.semaphore/collect-artifacts
    ./.semaphore/publish-artifacts-argoci
}

checkExitCode() {
    if [ $1 -ne 0 ]; then
        export CI_EXIT_CODE=1
        cleanup
        return 1
    fi
}

cd felix
sudo modprobe ipip

make check-wireguard
checkExitCode $? || return 0
../.argoci/scripts/run-and-monitor fv-{{inputs.parameters.executor}}.log make fv-no-prereqs FV_BATCHES_TO_RUN="${JOB_INDEX}" FV_NUM_BATCHES=${JOB_COUNT}
checkExitCode $? || return 0

cleanup
