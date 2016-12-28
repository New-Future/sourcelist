#!/bin/sh
# change source list

SRC_PATH='/etc/apt/sources.list';

echo "change ${SRC_PATH} to https://mirrors.tuna.tsinghua.edu.cn/ ...";
(sed -i.bak "s~https\?://\([^/]\+\)\(.*\)~https://mirrors.tuna.tsinghua.edu.cn/\2~" ${SRC_PATH})&&echo "Done!"
