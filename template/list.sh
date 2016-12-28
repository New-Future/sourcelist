#!/bin/sh
# change source list

SRC_PATH='/etc/apt/sources.list';

echo "change ${SRC_PATH} to ${FAST_SRC} ...";
(sed -i.bak "s~https\?://\([^/]\+\)\(.*\)~${FAST_SRC}\2~" ${SRC_PATH})&&echo "Done!"
