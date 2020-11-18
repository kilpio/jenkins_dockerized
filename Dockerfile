FROM jenkins/jenkins:latest

USER root

ARG JENKINS_USER
ARG USER_GROUP_ID
ARG USER_ID

RUN groupmod -g ${USER_GROUP_ID} jenkins
RUN usermod -u ${USER_ID} -g ${USER_GROUP_ID} jenkins

RUN apt-get -y update && \
    apt-get -y upgrade && \
 apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common && \
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
 add-apt-repository \
 "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
 $(lsb_release -cs) \
 stable" && \
 apt-get update && \
 apt-get -y install docker-ce docker-ce-cli containerd.io mc net-tools

RUN curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
 chmod +x /usr/local/bin/docker-compose && \
 ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

RUN usermod -aG docker jenkins

USER jenkins

WORKDIR $JENKINS_HOME
