#!/usr/bin/env bash

JENKINS_UID=$(id -u) JENKINS_GID=$(getent group docker | cut -d ':' -f 3) docker-compose up -d

