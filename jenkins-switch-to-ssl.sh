#!/usr/bin/env bash

source .env && docker run -u $(id -u) -v "$(pwd)/jenkins_home":'/var/jenkins_home' \
-it --entrypoint="/var/jenkins_home/make_pks.sh" jenkins_dockerized "${KEYSTORE_PASS}"

ls -la ./jenkins_home/keystore/jenkins_keystore.jks
