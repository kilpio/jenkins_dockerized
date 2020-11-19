#!/usr/bin/env bash

docker image build \
    --build-arg USER_ID=$(id -u) \
    --build-arg USER_GROUP_ID=$(id -g) \
    -t jenkins_dockerized \
    .