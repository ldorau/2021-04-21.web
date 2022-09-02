#!/bin/bash

# script for starting the hackathon WWW server

DEVDAX=/dev/dax0.0
FSDAX_MOUNT_POINT=/mnt/pmem
HACKATHON_DIR=/home/hackathon
REPO_NAME="2021-04-21"

if [ ! -c $DEVDAX ]; then
	# destroy fsdax if exists and create a devdax
	umount $FSDAX_MOUNT_POINT
	ndctl destroy-namespace all --force
	ndctl create-namespace -f -e namespace0.0 --mode=devdax
fi

if [ -c $DEVDAX ]; then
	chown -R $(whoami):$(whoami) $DEVDAX
	chmod a+rw $DEVDAX
	ls -al $DEVDAX
fi

killall webhackathon
docker stop $(docker ps -aq -f name=pmemuser)
docker rm $(docker ps -aq -f name=pmemuser)

set -e

# update $HACKATHON_DIR/
N_USERS=$(ls -1 $HACKATHON_DIR/workshops/test/ | wc -l)
[ ${N_USERS} -gt 1 ] && rm -rf $HACKATHON_DIR/workshops/test/*

# update $HACKATHON_DIR/$REPO_NAME
rm -rf $HACKATHON_DIR/$REPO_NAME
/bin/cp -r ../$REPO_NAME/ $HACKATHON_DIR/
rm -rf $HACKATHON_DIR/$REPO_NAME/examples/R/build

# update $HACKATHON_DIR/templates/examples/
rm -rf $HACKATHON_DIR/templates/examples/
/bin/cp -r ./templates/examples/ $HACKATHON_DIR/templates/

# update $HACKATHON_DIR/img/examples/
rm -rf $HACKATHON_DIR/img/examples/
/bin/cp -r ./img/examples/ $HACKATHON_DIR/img/

# rebuild the docker image
docker build -t pmemhackathon/pmemfc30:09 -f ./docker/Dockerfile ./docker/

# re-create the users
echo -e "y\ny\ny\n" | ./scripts/delete_pmemusers > /dev/null 2>&1
./scripts/create_pmemusers 1 1 $REPO_NAME
./scripts/enable_pmemusers 1 1 todayspasswd

# start the WWW server
cd $HACKATHON_DIR/
./webhackathon $REPO_NAME &
sleep 1
jobs
echo Done.
