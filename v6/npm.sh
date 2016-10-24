#!/usr/bin/env bash

# change node and npm source for ipv6
# only for deb (ubuntu)

NODE_SOURCE="https://mirrors6.tuna.tsinghua.edu.cn/nodesource/deb"
NPM_SOURCE="https://npm.tuna.tsinghua.edu.cn/"
SOURCE_LIST="/etc/apt/sources.list.d/nodesource.list"

#node
if [ ! -f "$SOURCE_LIST" ];then
    echo "set up node";
    curl -sL https://deb.nodesource.com/setup | sudo bash;
fi;

(sudo sed -i.bak "s~https\?://\([^/]\+\)\(.*\)/node~${NODE_SOURCE}\2~" "$SOURCE_LIST") && echo "set node sources $NODE_SOURCE"


#npm
npm set registry "$NPM_SOURCE" && echo "set npm source $NPM_SOURCE"


