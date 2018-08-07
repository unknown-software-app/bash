#!/bin/bash
# Docker rollback script


# stop and remove exist container, if exist
sudo docker ps -a | grep hello-world
if [ $? -eq 0 ] ; then
	sudo docker stop hello-world
	sudo docker rm hello-world
fi



# remove current docker image
sudo docker rmi hello-world:current

# tag rollback image as current
sudo docker tag hello-world:rollback hello-world:current

# run docker container with new image.
sudo docker run -d --name hello-world hello-world:current 
