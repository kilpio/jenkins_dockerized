useradd -m -s /bin/bash test -u 6666
usermod -aG docker test
docker build -t kilpio/jenkins_dockerized .
echo "UID_GID=$(id -u):$(id -g)" >> ./.env

docker run -u $(id -u):$(id -g) -v "$(pwd)/jenkins_home":'/var/jenkins_home' -it --entrypoint="/var/jenkins_home/make_pks.sh" kilpio/jenkins_dockerized
source .env && docker run -u ${UID_GID} -v "$(pwd)/jenkins_home":'/var/jenkins_home' -it --entrypoint="/var/jenkins_home/make_pks.sh" kilpio/jenkins_dockerized "${KEYSTORE_PASS}"

userdel jenkins
useradd -m -s /bin/bash -d /var/jenkins_home jenkins -u 7777
usermod -aG docker jenkins



source .env && docker run -u 0 -v "$(pwd)/jenkins_home":'/var/jenkins_home' -it --entrypoint="recreate-jenkins-user.sh" kilpio/jenkins_dockerized 7777


```bash
------------------------------------------------------------------------------------------------------------------------
```

Prerequisistes for jenkins in docker installation 

1. User must be in sudoers group:
ask admin to add: (usermod -aG sudo <username>)

2. As username add yourself to docker goup:

```bash
whoami
sudo usermod -aG docker ${USER}
exit
```

and login again.

3. Clone the jenkins_dockerized repo:

```bash
git clone https://github.com/kilpio/jenkins_dockerized
cd jenkins_dockerized
```

4. Add your user's uid:gid to the .env config file:

```bash
echo "UID_GID=$(id -u):$(id -g)" >> ./.env
```

Run 
```bash
id
cat ./.env
```
to be sure you uid:git were added properly.

5. Mind the KEYSTORE_PASS variable in the .env file. It is the password for the Jenkins keystore that will be crerated later when switching Jenkins fro http to https.
You may leave it as it is or change in the .env file to anything else.

6. pull the kilpio/jenkins_dockerized:latest image or build it locally:

```bash
docker build [--no-cache] -t jenkins_dockerized .
```

7. Now (before startint the Jenkins container) create the Jenkins keystore in jenkins_home/keystore dir. We need this for set up https access to the Jenkins web interface.
It's most probable that we do not have JRE keytool utility on our local host, so we will use one from the jenkins image:

```bash

source .env && docker run -u $(id -u) -v "$(pwd)/jenkins_home":'/var/jenkins_home' \
-it --entrypoint="/var/jenkins_home/make_pks.sh" jenkins_dockerized "${KEYSTORE_PASS}"

ls -la ./jenkins_home/keystore/jenkins_keystore.jks
```

check if it has only rw permission for your current user.

8. Now you are almost ready to start Jenkins.
The 'docker' group should have the same id on your host and in the jenkins containter. Get it with

```bash
getent group docker | cut -d ':' -f 3
```
on your host (most likely it will be  999).

to check the group id in the container, run

```bash
source .env && docker run -it --entrypoint="/usr/bin/getent" jenkins_dockerized group docker | cut -d ':' -f 3
```

9. Launch

```bash
JENKINS_UID=7777 JENKINS_GID=999 docker-compose up -d --force-recreate
```

```bash
docker-compose up -d
```

First run may take several minutes to install some general plugins.


9. Cat the initial admin password:

```bash
docker logs jenkins_dockerized 2>&1 | grep -A 6 'following password'
```
10. Now proceed to <https://your_IP:8080> for Jenkins configuration. Accept the self-signed  in yor browser.
