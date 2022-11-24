#! /bin/bash -x

echo "[INFO] generate a default id_rsa"
ssh-keygen -t rsa -b 4096 -N '' -f ~/.ssh/id_rsa

eval `ssh-agent -s`
mkdir -p ~/.ssh ~/.keys
touch ~/.ssh/known_hosts
# Copy secrets from mounted directory to home
printenv marvin ~/.keys/marvin
chmod 0600 ~/.keys/*
ssh-add ~/.keys/*
ssh-keyscan github.com >> /root/.ssh/known_hosts

export REPO_DIR="$(pwd)"
mkdir artifacts
echo $DOCKERHUB_PASSWORD | docker login --username "$DOCKERHUB_USERNAME" --password-stdin