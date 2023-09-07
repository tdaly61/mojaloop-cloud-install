#!/usr/bin/env bash
# Example of how to run the docker container which facilitates
# authenticating to AWS and then running Terraform to build an AWS EKS cluster 
# and deploy Mojaloop vNext 
# Tom Daly : Sept 2023

## User settings change these to reflect your locations ########################################
AWS_CREDENTIALS_DIR="$HOME/.aws"   # directory with the aws "credentials file" normally should not need changing
AWS_PROFILE="vnext"    # the aws user you are going to authenticate with , should be in your credentials file i.e. $AWS_CREDENTIALS_DIR/credentials      
TERRAFORM_CLUSTER_DIR="active"  # this is the name of the directory containing the terraform to create the cluster 
################################################################################################

SCRIPT_DIR=$( cd $(dirname "$0") ; pwd )
BASE_DIR=$( cd $(dirname "$0")/../.. ; pwd ) 

# point to the docker image that results from running build.sh 
DOCKER_IMAGE_NAME=`grep DOCKER_IMAGE_NAME= $SCRIPT_DIR/build.sh | cut -d "\"" -f2 | awk '{print $1}'`
# get the username and id of the user running this script
USER_NAME=$(whoami)
USER_ID=$(id -u $USER_NAME)
# terraform directory for AWS 
HOST_TERRAFORM_DIR=$BASE_DIR/terraform/aws-eks
 MOJALOOP_BIN_DIR=$BASE_DIR/bin

if [ ! -d "$HOME/.kube" ]; then 
  mkdir "$HOME/.kube"
fi 

if [ ! -d "$HOME/tmp" ]; then 
  mkdir "$HOME/tmp"  # used by the Mojaloop install script 
fi 

echo "RUN_DIR : $RUN_DIR"
printf "Mounting TERRAFORM from [%s] to /terraform \n" "$HOST_TERRAFORM_DIR"
echo "Running $DOCKER_IMAGE_NAME container"
docker run \
  --interactive --tty --rm \
  --volume "$AWS_CREDENTIALS_DIR":/home/${USER_NAME}/.aws \
  --env AWS_PROFILE="$AWS_PROFILE" \
  --env TERRAFORM_CLUSTER_DIR="$TERRAFORM_CLUSTER_DIR" \
  --volume "$HOST_TERRAFORM_DIR":/terraform \
  --volume "$MOJALOOP_BIN_DIR":/mojaloop_cloud_bin \
  --volume "$HOME/tmp":/home/${USER_NAME}/tmp \
  --volume "$HOME/.kube":/home/${USER_NAME}/.kube \
  --hostname "container-vnext-eks" \
  --entrypoint=/bin/bash $DOCKER_IMAGE_NAME $@

