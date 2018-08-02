#!/bin/sh

NAME="ubuntu"
PORT="-p 10022:22 -p 10080:80 -p 17778:7778"
VOL="/home/true/ddddddddddddd/docker/share:/usr/sharedData"

sudo docker run --name $NAME $PORT -i -t -d --volume $VOL --read-only --cap-add=SYS_PTRACE --security-opt seccomp=unconfined $NAME:1.0 /bin/sh
