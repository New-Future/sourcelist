#!/usr/bin/env bash
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
DISTRIBUTOR=$(lsb_release -i| awk '{print tolower($3)}')
CODENAME=$(lsb_release -c|awk '{print tolower($2)}')
echo "deb https://mirrors.tuna.tsinghua.edu.cn/docker/apt/repo ${DISTRIBUTOR}-${CODENAME} main" > /etc/apt/sources.list.d/docker.list
