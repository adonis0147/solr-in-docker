#!/bin/bash

HOME="/home/hadoop"
solr_package="$(find /root/install/archives/ -type f -name 'solr-*.tgz')"
tar -zxvf "${solr_package}" -C "${HOME}"
solr_path="$(find "${HOME}" -mindepth 1 -maxdepth 1 -type d | grep solr-)"
ln -snf "${solr_path}" "${HOME}/solr-current"

solr_conf_path="${HOME}/solr-current/conf"
mkdir -p "${solr_conf_path}"

chown -R hadoop:hadoop "${HOME}"/solr-*

sudo -u hadoop mkdir -p /data/conf
sudo -u hadoop mv "${solr_conf_path}" /data/conf/solr-conf
sudo -u hadoop cp /data/conf/hadoop-conf/hdfs-site.xml /data/conf/solr-conf/
sudo -u hadoop mv "${HOME}/solr-current/bin/solr.in.sh" /data/conf/solr-conf

JAVA_HOME='/usr/lib/jvm/java-1.8.0-openjdk-amd64'
ZK_HOST="solr-cluster-n1.com:2181,solr-cluster-n2.com:2181,solr-cluster-n3.com:2181/solr"
SOLR_PID_DIR='/home/hadoop/cluster-data/solr/pids'
SOLR_HOME='/home/hadoop/cluster-data/solr/data'
SOLR_LOGS_DIR='/home/hadoop/cluster-data/solr/logs'

commands='
s/#ZK_HOST=.*/ZK_HOST='"${ZK_HOST//\//\\\/}"'/
s/#SOLR_PID_DIR=.*/SOLR_PID_DIR='"${SOLR_PID_DIR//\//\\\/}"'/
s/#SOLR_HOME=.*/SOLR_HOME='"${SOLR_HOME//\//\\\/}"'/
s/#SOLR_LOGS_DIR=.*/SOLR_LOGS_DIR='"${SOLR_LOGS_DIR//\//\\\/}"'/
'
sudo -u hadoop sed -i "${commands}" /data/conf/solr-conf/solr.in.sh

settings='
SOLR_OPTS="${SOLR_OPTS} -Dsolr.directoryFactory=HdfsDirectoryFactory"
SOLR_OPTS="${SOLR_OPTS} -Dsolr.lock.type=hdfs"
SOLR_OPTS="${SOLR_OPTS} -Dsolr.hdfs.home=hdfs://solr-cluster/solr"
SOLR_OPTS="${SOLR_OPTS} -Dsolr.hdfs.confdir=/home/hadoop/solr-current/conf"
'
echo "${settings}" >> /data/conf/solr-conf/solr.in.sh

sudo -u hadoop ln -snf /data/conf/solr-conf "${solr_conf_path}"
sudo -u hadoop ln -snf "${solr_conf_path}/solr.in.sh" "${HOME}/solr-current/bin/"
sudo -u hadoop mkdir -p "${SOLR_HOME}"
sudo -u hadoop cp "${HOME}/solr-current/server/solr/solr.xml" "${SOLR_HOME}/"
sudo -u hadoop mkdir -p "${SOLR_PID_DIR}"

# setup environment
solr_bin_path="/home/hadoop/solr-current/bin"
sudo -u hadoop echo 'export PATH="'"${solr_bin_path}"':${PATH}"' >> /home/hadoop/.bash_profile
