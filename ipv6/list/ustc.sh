#!/bin/sh
# change source list

SRC_PATH='/etc/apt/sources.list';

echo "change ${SRC_PATH} to https://ipv6.mirrors.ustc.edu.cn ...";
(sed -i.bak "s~https\?://\([^/]\+\)\(.*\)~https://ipv6.mirrors.ustc.edu.cn\2~" ${SRC_PATH})&&echo "Done!"
