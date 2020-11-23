#!/usr/bin/env bash

docker container run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd)/jenkins_home:/var/jenkins_home -w /var/jenkins_home -u $(id -u ${USER}):$(id -g ${USER}) jenkins/jenkins:latest 
#        bash -c "touch /var/jenkins_home/aaaaaaaaaaaaaaaaa && echo \$?"


