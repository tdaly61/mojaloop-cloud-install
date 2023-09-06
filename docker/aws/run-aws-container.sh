#!/usr/bin/env bash
# Example of hot to run the docker container which facilitates
# authenticating to AWS and then running Terraform to build an AWS EKS cluster 
# and deploy Mojaloop vNext 
# T Daly : June 2023

## User settings change these to reflect your locations  
AWS_CREDENTIALS_DIR="$HOME/.aws"   # directory with the aws "credentials file"
AWS_PROFILE="vnext"    # the aws user you are going to authenticate with , should be in your credentials file i.e. $AWS_CREDENTIALS_DIR/credentials      

SCRIPT_DIR=$( cd $(dirname "$0") ; pwd )
BASE_DIR=$( cd $(dirname "$0")/../.. ; pwd ) 
echo $SCRIPT_DIR
echo $BASE_DIR

# point to the docker image that results from running build.sh 
DOCKER_IMAGE_NAME=`grep DOCKER_IMAGE_NAME= $SCRIPT_DIR/build.sh | cut -d "\"" -f2 | awk '{print $1}'`
echo $DOCKER_IMAGE_NAME

# get the username of the user running this script
USER_NAME=$(whoami)
# get the user ID of the user running this script
USER_ID=$(id -u $USER_NAME)
# terraform directory for AWS 
TERRAFORM_DIR=$BASE_DIR/terraform/aws-eks
MOJALOOP_BIN_DIR=$BASE_DIR/bin

echo "RUN_DIR : $RUN_DIR"
printf "Mounting TERRAFORM from [%s] to /terraform \n" "$TERRAFORM_DIR"
echo "Running $DOCKER_IMAGE_NAME container"
docker run \
  --interactive --tty --rm \
  --volume "$AWS_CREDENTIALS_DIR":/home/${USER_NAME}/.aws \
  --env AWS_PROFILE="$AWS_PROFILE" \
  --volume "$TERRAFORM_DIR":/terraform \
  --volume "$MOJALOOP_BIN_DIR":/mojaloop_cloud_bin \
  --hostname "container-vnext-eks" \
  --entrypoint=/bin/bash $DOCKER_IMAGE_NAME $@