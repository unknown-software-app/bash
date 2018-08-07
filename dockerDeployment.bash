#!/bin/bash
# Docker deployment script


# check if docker cli is exist. if not, install it
type docker 2>&1
if [ $? -eq 1 ] ; then
	sudo yum -y update
	sudo yum -y install docker docker-registry
	sudo service docker start #start the Docker service
fi




#download latest image
sudo docker pull hello-world:latest

# stop and remove exist container, if exist
sudo docker ps -a | grep hello-world
if [ $? -eq 0 ] ; then
	sudo docker stop hello-world
	sudo docker rm hello-world
fi

# check if docker image with rollback tag is exist, if yes, remove it
sudo docker images | grep hello-world  | grep rollback
if [ $? -eq 0 ] ; then
	sudo docker rmi hello-world:rollback
fi

# check if docker image with current tag is exist, if yes, tag it as rollback
sudo docker images | grep hello-world  | grep current
if [ $? -eq 0 ] ; then
	sudo docker tag hello-world:current hello-world:rollback
fi

# tag latest image as current
sudo docker tag hello-world:latest hello-world:current

# run docker container with new image.
sudo docker run -d --name hello-world hello-world:current 
