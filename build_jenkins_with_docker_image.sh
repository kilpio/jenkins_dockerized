#!/usr/bin/env bash
#export USER_GROUP_ID=$(id -g)
#export USER_ID=$(id -u)

#docker-compose build --no-cache jenkins


docker image build \
    --build-arg USER_ID=$(id -u) \
    --build-arg USER_GROUP_ID=$(id -g) \
    -t jenkins_dockerized \
    .