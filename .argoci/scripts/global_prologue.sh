#! /bin/bash -x

eval `ssh-agent -s`
mkdir -p /root/.ssh
touch /root/.ssh/known_hosts
# Copy secrets from mounted directory to home
chmod 0600 ~/.keys/*
ssh-add ~/.keys/*
ssh-keyscan github.com >> /root/.ssh/known_hosts

export REPO_DIR="$(pwd)"
mkdir artifacts
echo $DOCKERHUB_PASSWORD | docker login --username "$DOCKERHUB_USERNAME" --password-stdin