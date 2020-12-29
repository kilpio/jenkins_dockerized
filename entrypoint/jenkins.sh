#!/usr/bin/env bash

TMPDIR=${JENKINS_HOME}
rm -rf $TMPDIR/invars $TMPDIR/outvars $TMPDIR/blockedvarnames $TMPDIR/invarnames $TMPDIR/outvarnames source.vars

export KEYSTORE_FILE_PATH="${JENKINS_HOME}/keystore/jenkins_keystore.jks"
export MYPASS=${KEYSTORE_PASS}
export HOME=${JENKINS_HOME}

export -n > $TMPDIR/invars

groupmod -g ${DOCKER_GID} docker
usermod -a -G ${DOCKER_GID} -u ${JENKINS_UID} jenkins
chown jenkins $TMPDIR/invars

sudo -i -u jenkins bash << EOF
export -n > $TMPDIR/outvars
EOF


BLOCKED_VARS=(HOME PATH USER PWD SHELL LOGNAME USERNAME)
printf "%s\n" "${BLOCKED_VARS[@]}" > $TMPDIR/blockedvarnames


cat $TMPDIR/invars | sed -E 's/^declare\ -x\ //' | sed -E 's/=/*/' | cut -d '*' -f 1 > $TMPDIR/invarnames
cat $TMPDIR/outvars | sed -E 's/^declare\ -x\ //' | sed -E 's/=/*/' | cut -d '*' -f 1 > $TMPDIR/outvarnames

chown jenkins $TMPDIR/invarnames
chown jenkins $TMPDIR/outvarnames

cat $TMPDIR/outvarnames $TMPDIR/blockedvarnames > $TMPDIR/outvarnames
grep -F -x -v -f $TMPDIR/outvarnames $TMPDIR/invarnames > $TMPDIR/varnames
grep -F -f $TMPDIR/varnames $TMPDIR/invars > source.vars

chown jenkins $TMPDIR/blockedvarnames
chown jenkins $TMPDIR/varnames
chown jenkins source.vars


sudo -i -u jenkins bash << EOFF

source source.vars

PATH='/usr/local/openjdk-8/bin':${PATH}

if [ ! -s "${KEYSTORE_FILE_PATH}" ]

then
    
    pushd "${JENKINS_HOME}"
    
    rm -rf ${JENKINS_HOME}/keystore/
    rm -rf ${JENKINS_HOME}/openssl/
    
    mkdir openssl && cd openssl
    
    
    openssl genrsa -out ca.key 2048
    openssl req -config /var/jenkins_home/openssl.cnf -passout env:MYPASS -new -newkey rsa:2048 > new.ssl.csr
    openssl rsa -passin env:MYPASS -in new.ssl.csr -out new.cert.key
    openssl x509 -in new.ssl.csr -out new.cert.cert -req -signkey new.cert.key -days 3650
    openssl pkcs12 -export -out jenkins_keystore.p12 -inkey new.cert.key -in new.cert.cert -name jenkinsci.com -passout env:MYPASS
    
    echo "MYPASS: ${MYPASS}"
    keytool -importkeystore -srckeystore jenkins_keystore.p12 -srcstoretype PKCS12 -srcstorepass $MYPASS -srcalias jenkinsci.com \
    -deststoretype JKS -destkeystore jenkins_keystore.jks  -deststorepass $MYPASS
    
    echo "keystore password: $MYPASS"
    mkdir ${JENKINS_HOME}/keystore
    cp  ${JENKINS_HOME}/openssl/jenkins_keystore.jks ${JENKINS_HOME}/keystore/
    
    chmod 700 ${JENKINS_HOME}/keystore/
    chmod 600 ${JENKINS_HOME}/keystore/jenkins_keystore.jks
    
fi

TMPDIR=${JENKINS_HOME}
rm -rf $TMPDIR/invars $TMPDIR/outvars $TMPDIR/blockedvarnames $TMPDIR/invarnames $TMPDIR/outvarnames source.vars

/usr/local/bin/start_jenkins.sh

EOFF