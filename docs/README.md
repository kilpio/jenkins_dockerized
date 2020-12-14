# Deploying Jenkins with docker inside with **jenkins_dockerized**

The jenkins_dockerized (JD) is a set of scripts and docker-compose files needed to install containerized Jenkins with docker support. It's based on jenkins/jenkins:latest image.

## Requirements

JD requires Linux machine with docker and docker-compose installed. Any user in 'docker' group can run JD container.

## Running by custom user

Regular jenkins/jenkins docker image requires user with uid:gid 1000:1000 to share jenkins_home directory. If you run the Jenkins container from any user with other user:group ids it will fail due to permissions.

That's why we should start the docker container with the host user id explicitly. With this approach the initial 'jenkins' user defined in the jenkins/jenkins image is left outside the jenkins operation.

And even more, the user running Jenkins in the container should be a member of the 'docker' group to run docker operations. The only working solution found is to launch the container also with docker group id (it is usually 999, but check this beforehand).

Some utilities like ssh e.g. do not operate correctly if user has only id but not username. So the <start-jenkins-container.sh> gives name jenkins0 to the Jenkins user in container.

### The .env file

Here you can change the path to the Jenkins data folder location on your host (HOST_JENKINS_DATA), redefine the path to the docker socket (HOST_DOCKER) and set your original password for the Jenkins keystore ('mypass' by default). By default you should not change anything.

### Building the image

Clone the <https://github.com/kilpio/jenkins_dockerized> repo and cd into the directory. Run

```bash
git clone https://github.com/kilpio/jenkins_dockerized
cd jenkins_dockerized
docker image build -t jenkins_dockerized .
```

to build the <jenkins_dockerized> image. Or just run the <build_jenkins_with_docker_image.sh> helper script.

### Creating the keystore for https connection

At first run JD creates the Jenkins keystore in ./jenkins_home/keystore directory.
Jenkins uses 8080 port for the web interface and 50000 port to communicate with agents by default.

## Start the container

Now Jenkins container is ready to be started and configured.

Use <start-jenkins-container.sh> helper script, which runs the following commands:

```shell
export JENKINS_UID=$(id -u)
export JENKINS_GID=$(getent group docker | cut -d ':' -f 3)

docker-compose up -d
docker exec -u 0 jenkins_dockerized sh -c "useradd -s /bin/bash jenkins0 -u ${JENKINS_UID} -g ${JENKINS_GID} -d /var/jenkins_home"
```

Connect to the web interface <https://YOUR_SERVER_ADDR:8080> to proceed in a usual way with a new Jenkins installation.
Initial admin password is stored in ./jenkins_home/secrets/initialAdminPassword
