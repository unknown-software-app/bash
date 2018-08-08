#!/bin/bash
# Docker rollback script

# container parameters
IMAGE_NAME=$1
PORT=$2
ENV_VAR=$3
VOL_NAME=$4
NETWROK=$5

# check if docker image with rollback tag is exist, if not so exit
sudo docker images | grep $IMAGE_NAME  | grep rollback
if [ $? -eq 1 ] ; then
	echo "Image with rollback tag is not found"
	exit 1
fi

# stop and remove exist container, if exist
sudo docker ps -a | grep $IMAGE_NAME
if [ $? -eq 0 ] ; then
	sudo docker stop $IMAGE_NAME
	sudo docker rm $IMAGE_NAME
fi



# remove current docker image
sudo docker rmi $IMAGE_NAME:current

# tag rollback image as current
sudo docker tag $IMAGE_NAME:rollback $IMAGE_NAME:current

# run docker container with new image.
# run docker container with new image.
sudo docker run -d \
-p $PORT:$PORT \
-e ENV=$ENV_VAR \
-v $VOL_NAME \
--network $NETWROK \
--name $IMAGE_NAME $IMAGE_NAME:current 
