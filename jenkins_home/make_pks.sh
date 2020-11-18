#!/usr/bin/env bash

rm -rf ${JENKINS_HOME}/keystore/
rm -rf ${JENKINS_HOME}/openssl/

mkdir openssl && cd openssl
export MYPASS=$(openssl rand -base64 8 | sed 's/[^a-zA-Z]//g')

openssl genrsa -out ca.key 2048
openssl req -config /var/jenkins_home/openssl.cnf -passout env:MYPASS -new -newkey rsa:2048 > new.ssl.csr
openssl rsa -passin env:MYPASS -in new.ssl.csr -out new.cert.key
openssl x509 -in new.ssl.csr -out new.cert.cert -req -signkey new.cert.key -days 3650
openssl pkcs12 -export -out jenkins_keystore.p12 -inkey new.cert.key -in new.cert.cert -name jenkinsci.com -passout env:MYPASS

keytool -importkeystore -srckeystore jenkins_keystore.p12 -srcstoretype PKCS12 -srcstorepass $MYPASS -srcalias jenkinsci.com \
-deststoretype JKS -destkeystore jenkins_keystore.jks  -deststorepass $MYPASS

echo "keystore password: $MYPASS"
mkdir ${JENKINS_HOME}/keystore
cp  ${JENKINS_HOME}/openssl/jenkins_keystore.jks ${JENKINS_HOME}/keystore/

chown -R jenkins:jenkins ${JENKINS_HOME}/keystore/
chown -R jenkins:jenkins ${JENKINS_HOME}/openssl/


chmod 700 ${JENKINS_HOME}/keystore/
chmod 600 ${JENKINS_HOME}/keystore/jenkins_keystore.jks

echo ${MYPASS} > ${JENKINS_HOME}/keystorepass

