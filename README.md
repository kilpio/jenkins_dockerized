# Deploying Jenkins with docker inside with **jenkins_dockerized**

The jenkins_dockerized (JD) is a set of scripts and docker-compose files needed to install containerized Jenkins with docker support. It's based on jenkins/jenkins:latest image.

## Requirements

JD requires Linux machine with docker and docker-compose installed. Any user in the 'docker' group can run the JD container.

## Kick Start
### The .env file

Variables in this file define the path to the Jenkins data folder on your host (HOST_JENKINS_DATA), the path to the docker socket (HOST_DOCKER) and the  password for the Jenkins keystore ('mypass' by default, you can change it before start).

### Running Jenkins

 Clone the repository and run the <start-jenkins-container.sh> to start the JD container. Jenkins runs as user jenkins0 with the same GID as the host docker.

Connect to the web interface <https://YOUR_SERVER_ADDR:8080> to proceed in a usual way with a new Jenkins installation.
Initial admin password is stored in ./jenkins_home/secrets/initialAdminPassword
### Ports

Jenkins uses 8080 port for the https web interface and 50000 port to communicate with agents by default.
At first run JD creates the Jenkins keystore in ./jenkins_home/keystore directory.

## Building the image

In case if you need to build the image locally clone the <https://github.com/kilpio/jenkins_dockerized> repo and cd into the directory. Then run the <build_jenkins_with_docker_image.sh> helper script to build the <jenkins_dockerized> image.

