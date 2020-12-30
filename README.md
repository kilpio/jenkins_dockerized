#

Repository contains start-up environment for Jenkins to use docker in Jenkins jobs. It is a set of scripts and docker-compose files needed to start containerized Jenkins with docker support. It's based on jenkins/jenkins image, with Docker engine installed and auto-configured HTTPS access.

## Requirements

A Linux machine with docker and docker-compose installed. User running the container must be a member of the 'docker' group.

## Running Jenkins

Clone the repository and run the ```start-jenkins-container.sh``` to start the Jenkins container. Jenkins runs as user 'jenkins' with the UID of the user who launched the container and the same GID as the host docker GID.

## Configure

Connect to the web interface <https://YOUR_HOST_ADDR:8080> to proceed in a usual way with a new Jenkins installation. The initial admin password will be generated and stored in the ./jenkins_home/secrets/initialAdminPassword file.
Some essential plugins (known to work with the latest image) are already stored in the jenkins_home/plugins directory. So you may skip the initial plugin installation and then add some necessary plugins later.

## Ports

Jenkins uses the 8080 port for the HTTPS web interface. The 50000 port is used to communicate with agents.
At the first run the Jenkins keystore is automatically created in ./jenkins_home/keystore directory. You may provide your own keystore password in the KEYSTORE_PASS variable (otherwise 'mypass' will be used by default).

## Building the image

In case if you need to build the image locally clone the <https://github.com/kilpio/jenkins_dockerized> repo and cd into the repo directory. Then run the ```build_jenkins_with_docker_image.sh``` helper script to build the ```jenkins_dockerized``` image.

