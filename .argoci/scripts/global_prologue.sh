#! /bin/bash
set -x
chmod a+w ${CI_HOME}

export REPO_DIR="$(pwd)"
mkdir artifacts
echo $DOCKERHUB_PASSWORD | docker login --username "$DOCKERHUB_USERNAME" --password-stdin

# Enable ipv6 in pod
sysctl net.ipv6.conf.all.disable_ipv6=0