#!/bin/bash
# Docker deployment script

# container parameters
IMAGE_NAME=$1
DOCKER_TAG=$2
PORT=$3
ENV_VAR=$4
VOL_NAME=$5
NETWROK=$6

# check if docker cli is exist. if not, install it
type docker 2>&1
if [ $? -eq 1 ] ; then
	sudo yum -y update
	sudo yum -y install docker docker-registry
	sudo service docker start #start the Docker service
fi


#download DOCKER_TAG image
sudo docker pull $IMAGE_NAME:$DOCKER_TAG

# stop and remove exist container, if exist
sudo docker ps -a | grep $IMAGE_NAME
if [ $? -eq 0 ] ; then
	sudo docker stop $IMAGE_NAME
	sudo docker rm $IMAGE_NAME
fi

# check if docker image with rollback tag is exist, if yes, remove it
sudo docker images | grep $IMAGE_NAME  | grep rollback
if [ $? -eq 0 ] ; then
	sudo docker rmi $IMAGE_NAME:rollback
fi

# check if docker image with current tag is exist, if yes, tag it as rollback
sudo docker images | grep $IMAGE_NAME  | grep current
if [ $? -eq 0 ] ; then
	sudo docker tag $IMAGE_NAME:current $IMAGE_NAME:rollback
fi

# tag $DOCKER_TAG image as current
sudo docker tag $IMAGE_NAME:$DOCKER_TAG $IMAGE_NAME:current

# run docker container with new image.
sudo docker run -d \
-p $PORT:$PORT \
-e ENV=$ENV_VAR \
-v $VOL_NAME \
--network $NETWROK \
--name $IMAGE_NAME $IMAGE_NAME:current 
