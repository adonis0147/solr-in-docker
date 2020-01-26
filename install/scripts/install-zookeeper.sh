#!/usr/bin/env bash

HOME="/home/hadoop"
zookeeper_package="$(find /root/install/archives/ -type f -name 'apache-zookeeper-*.tar.gz')"
tar -zxvf "${zookeeper_package}" -C "${HOME}"
zookeeper_path="$(find "${HOME}" -mindepth 1 -maxdepth 1 -type d | grep apache-zookeeper-)"
ln -snf "${zookeeper_path}" "${HOME}/zookeeper-current"

zookeeper_conf_path="${HOME}/zookeeper-current/conf"
cp /root/install/conf/zookeeper/* "${zookeeper_conf_path}"

chown -R hadoop:hadoop "${zookeeper_path}"
chown -R hadoop:hadoop "${HOME}/zookeeper-current"

sudo -u hadoop mkdir -p /data/conf
sudo -u hadoop mv "${zookeeper_conf_path}" /data/conf/zookeeper-conf
sudo -u hadoop ln -snf /data/conf/zookeeper-conf "${zookeeper_conf_path}"
sudo -u hadoop mv "${HOME}/zookeeper-current/bin/zkEnv.sh" /data/conf/zookeeper-conf

command='/${ZOO_LOG_DIR}/i ZOO_LOG_DIR='"${HOME}"'/cluster-data/zk/logs'
sudo -u hadoop sed -i "${command}" /data/conf/zookeeper-conf/zkEnv.sh
sudo -u hadoop ln -snf ../conf/zkEnv.sh "${HOME}/zookeeper-current/bin/"

zookeeper_bin_path="/home/hadoop/zookeeper-current/bin"
sudo -u hadoop echo 'export PATH="'"${zookeeper_bin_path}"':${PATH}"' >> /home/hadoop/.bash_profile
