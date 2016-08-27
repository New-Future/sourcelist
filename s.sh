#!/bin/sh

SOURCE=https://ipv6.mirrors.ustc.edu.cn

echo "change source list to $SOURCE"

(sed -i.bak "s~https\?://\([^/]\+\)\(.*\)~$SOURCE\2~" /etc/apt/sources.list)&&echo "Done!"

apt update