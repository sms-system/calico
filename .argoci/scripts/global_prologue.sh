#! /bin/bash
set -x
chmod a+w ${CI_HOME}

export REPO_DIR="$(pwd)"
mkdir artifacts
echo $DOCKERHUB_PASSWORD | docker login --username "$DOCKERHUB_USERNAME" --password-stdin
