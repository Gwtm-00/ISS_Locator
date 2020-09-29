#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
# dockerpath=<your docker ID/path>
dockerpath = gwtm11/isslocator

# Step 2:  
# Authenticate & tag
export DOCKER_ID_USER="gwtm11"
docker login
docker tag isslocator $DOCKER_ID_USER/isslocator
docker push $DOCKER_ID_USER/isslocator
echo "Docker ID and Image: $dockerpath"

# Step 3:
# Push image to a docker repository
docker push gwtm11/isslocator
