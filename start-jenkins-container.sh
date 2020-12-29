#!/usr/bin/env bash

export JENKINS_UID=$(id -u)
export DOCKER_GID=$(grep "^docker:" /etc/group | awk -F: '{print $3}')
#echo "$JENKINS_UID $DOCKER_GID"


docker-compose up --force-recreate -d
docker logs  jenkins_dockerized -f
#sleep 10

#some utils (like ssh e.g.) want the user have username noy only uid, let it be jenkins0
#docker exec -u 0 jenkins_dockerized sh -c "groupmod -g ${DOCKER_GID} docker"
#docker exec -u 0 jenkins_dockerized sh -c "usermod -a -G ${DOCKER_GID} -u ${JENKINS_UID} jenkins"

#docker exec -u 0 jenkins_dockerized sh -c "useradd -s /bin/bash jenkins0 -u ${JENKINS_UID} -g ${DOCKER_GID} -d /var/jenkins_home"
