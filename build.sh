#!/bin/bash

# build image and container
# select run type: pabot or robot (pabot runs parallel and robot one test at a time)
# select name of the container and name of the image or use default values
# note that if same name of image or container already exists, this script fails
# select mount name for yle-ovp-test folder

set -eu

FOLDER_NAME=${1:-ubuntu1804}
CONTAINER_NAME=${2:-rf-chrome}
IMAGE_NAME=${3:-docker-robotframework/python3.8}
MOUNT_NAME=${4:-ovp_tests}


#aws credentials are needed to run tests (passwords and keys are stored on aws)
AWS_ACCESS_KEY_ID=$(aws --profile default configure get aws_access_key_id)
AWS_SECRET_ACCESS_KEY=$(aws --profile default configure get aws_secret_access_key)

docker build -t $IMAGE_NAME $FOLDER_NAME
echo "***** created image '$IMAGE_NAME'"

docker run -itd --name=$CONTAINER_NAME \
           -v $HOME/repot/yle-ovp-test:/$MOUNT_NAME \
           -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
           -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
           -e AWS_DEFAULT_REGION="eu-west-1" \
           -e AWS_DEFAULT_OUTPUT="json" \
           $IMAGE_NAME

echo "****** created container '$CONTAINER_NAME' from image '$IMAGE_NAME' (yle-ovp-test mounted to '$MOUNT_NAME')"
