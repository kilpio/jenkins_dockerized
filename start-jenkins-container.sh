#!/usr/bin/env bash

export JENKINS_UID=$(id -u)
export JENKINS_GID=$(getent group docker | cut -d ':' -f 3)

docker-compose up -d
sleep 1

#some utils (like ssh e.g.) want the user have username noy only uid, let it be jenkins0
docker exec -u 0 jenkins_dockerized sh -c "useradd -s /bin/bash jenkins0 -u ${JENKINS_UID} -g ${JENKINS_GID} -d /var/jenkins_home"
