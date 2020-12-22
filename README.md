Repository contains start-up script for Jenkins enabling using docker in jobs. It is a set of scripts and docker-compose files needed to start containerized Jenkins with docker support. It's based on jenkins/jenkins image, with Docker engine installed and HTTPS support auto-configured.

## Requirements

Linux machine with docker and docker-compose installed. User should be member of the docker group.

## Prepare

### Running Jenkins

Clone the repository and run the ```start-jenkins-container.sh``` to start the Jenkins container. Jenkins runs as user jenkins0 with the same GID as the host docker.

Connect to the web interface <https://YOUR_SERVER_ADDR:8080> to proceed in a usual way with a new Jenkins installation.
Initial admin password is stored in ./jenkins_home/secrets/initialAdminPassword
### Ports

Jenkins uses 8080 port for the https web interface and 50000 port to communicate with agents by default.
At first run JD creates the Jenkins keystore in ./jenkins_home/keystore directory.

## Building the image

In case if you need to build the image locally clone the <https://github.com/kilpio/jenkins_dockerized> repo and cd into the directory. Then run the ```build_jenkins_with_docker_image.sh``` helper script to build the ```jenkins_dockerized``` image.

