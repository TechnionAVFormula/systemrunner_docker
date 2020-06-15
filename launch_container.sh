#!/bin/sh

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

mkdir -p jetpack_home/nvidia
mkdir -p jetpack_home/Downloads
JETPACK_HOME=$(realpath ./jetpack_home)

CUDA_VERSION=10.2
DRIVEWORKS_VERSION=2.2

docker run --privileged --rm -it \
           --gpus all \
           --volume=$XSOCK:$XSOCK:rw \
           --volume=$XAUTH:$XAUTH:rw \
           --volume=/dev:/dev:rw \
           --volume=$JETPACK_HOME/nvidia:/home/jetpack/nvidia:rw \
           --volume=$JETPACK_HOME/Downloads:/home/jetpack/Downloads:rw \
           --volume=/usr/local/cuda-$CUDA_VERSION:/usr/local/cuda-$CUDA_VERSION \
           --volume=/usr/local/driveworks-$DRIVEWORKS_VERSION:/usr/local/driveworks-$DRIVEWORKS_VERSION \
           --shm-size=1gb \
           --env="XAUTHORITY=${XAUTH}" \
           --env="DISPLAY=${DISPLAY}" \
           --env=TERM=xterm-256color \
           --env=QT_X11_NO_MITSHM=1 \
           --net=host \
           -u "jetpack"  \
           jetpack:latest \
           bash
