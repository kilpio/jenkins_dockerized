#!/usr/bin/env bash

export USER_GROUP_ID=$(id -g)
export USER_ID=$(id -u)

docker-compose -f docker-compose-init.yaml up -d
