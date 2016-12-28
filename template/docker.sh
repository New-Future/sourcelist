#!/bin/sh
# docker project

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
DISTRIBUTOR=$(lsb_release -i| awk '{print tolower($3)}')
CODENAME=$(lsb_release -c|awk '{print tolower($2)}')

echo "deb ${FAST_SRC} ${DISTRIBUTOR}-${CODENAME} main" > /etc/apt/sources.list.d/docker.list

# docker hub 

echo '{ "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"] }' > /etc/docker/daemon.json
