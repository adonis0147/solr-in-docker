#!/bin/bash

HOME="$(dirname "${BASH_SOURCE[0]}")"
INSTALL_PATH="${HOME}/install"
ARCHIVES_PATH="${INSTALL_PATH}/archives"
SSHKEY_PATH="${INSTALL_PATH}/ssh"

hadoop_package='hadoop-2.10.0.tar.gz'
hadoop_package_url='http://mirrors.aliyun.com/apache/hadoop/common/hadoop-2.10.0/hadoop-2.10.0.tar.gz'

zookeeper_package='apache-zookeeper-3.5.6-bin.tar.gz'
zookeeper_package_url='https://mirrors.aliyun.com/apache/zookeeper/stable/apache-zookeeper-3.5.6-bin.tar.gz'

solr_package='solr-8.4.1.tgz'
solr_package_url='https://mirrors.aliyun.com/apache/lucene/solr/8.4.1/solr-8.4.1.tgz'

if [[ ! -f "${ARCHIVES_PATH}/${hadoop_package}" ]]; then
  echo 'download hadoop'
  curl -fLo "${ARCHIVES_PATH}/${hadoop_package}" --create-dirs "${hadoop_package_url}"
fi

if [[ ! -f "${ARCHIVES_PATH}/${zookeeper_package}" ]]; then
  echo 'download zookeeper'
  curl -fLo "${ARCHIVES_PATH}/${zookeeper_package}" --create-dirs "${zookeeper_package_url}"
fi

if [[ ! -f "${ARCHIVES_PATH}/${solr_package}" ]]; then
  echo 'download solr'
  curl -fLo "${ARCHIVES_PATH}/${solr_package}" --create-dirs "${solr_package_url}"
fi

mkdir -p "${SSHKEY_PATH}"
yes | ssh-keygen -t rsa -N '' -f "${SSHKEY_PATH}/id_rsa"

docker build -t solr-in-docker .
