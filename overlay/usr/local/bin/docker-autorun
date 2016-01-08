#!/bin/bash

IMAGE="$1"
ARGS="$2"
OPTS="$3"

NAME=autorun-$(echo "$IMAGE" | tr "/" "-" | tr ":" "-")
docker start $NAME || \
    docker run -d $OPTS -P --name $NAME $IMAGE $ARGS
