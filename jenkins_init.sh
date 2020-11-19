#!/usr/bin/env bash

export USER_GROUP_ID=$(id -g)
export USER_ID=$(id -u)

docker-compose -f docker-compose-init.yaml up -d
sleep 5
#docker logs jenkins_dokerized -f

echo "waiting for initial admin password..."

while [ ! -f ./jenkins_home/secrets/initialAdminPassword ]
do
  sleep 1
done
echo "Inintial admin password is $(cat ./jenkins_home/secrets/initialAdminPassword)"
sleep 5