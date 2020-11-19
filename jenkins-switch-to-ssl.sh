#!/usr/bin/env bash

source .env

export USER_GROUP_ID=$(id -g)
export USER_ID=$(id -u)


echo "Creating new keystore..."
docker-compose run jenkins ./make_pks.sh
echo "Saving password in the .env file..."

KEYSTORE_PASSWORD=$(cat ${HOST_JENKINS_DATA}/keystorepass)
sed -i "s/^KEYSTORE_PASS.*/KEYSTORE_PASS=${KEYSTORE_PASSWORD}/g" .env
rm ${HOST_JENKINS_DATA}/keystorepass