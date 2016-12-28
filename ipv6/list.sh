#!/usr/bin/env bash
# test speed
LIST=(
    'https://mirrors6.tuna.tsinghua.edu.cn' #tsinghua
	'https://ipv6.mirrors.ustc.edu.cn' #ustc
);

TIMEOUT=60
MAX_TIEMS=10

SPEED=(); #storage speed

len=${#LIST[@]}
echo "evaluate the speed of $len source site ...";
len=`echo ${len} - 1 | bc`
for i in `seq 0 $MAX_TIEMS`;do
    for j in `seq 0 $len`;do
        _SPEED=$(curl --connect-timeout $TIMEOUT -#o /dev/null -w'%{speed_download}' ${LIST[$j]});
        SPEED[$j]=`echo ${SPEED[$j]:-0} + $_SPEED | bc`;
    done
done

fast_speed=0
FAST_SRC=0

echo "> Average speed:";
for INDEX in `seq 0 $len`;do
    SPEED[$INDEX]=`echo ${SPEED[$INDEX]} / $MAX_TIEMS | bc`;
    echo "${LIST[$INDEX]} : ${SPEED[$INDEX]} byte/s";
    if [[ "${SPEED[$INDEX]}" -gt "$fast_speed" ]]; then
        fast_speed=${SPEED[$INDEX]}
        FAST_SRC=${LIST[$INDEX]}
    fi
done

echo "> Fastest source site:";
echo "[${fast_speed} byte/s] ${FAST_SRC}";
#!/bin/sh
# change source list

SRC_PATH='/etc/apt/sources.list';

echo "change ${SRC_PATH} to ${FAST_SRC} ...";
(sed -i.bak "s~https\?://\([^/]\+\)\(.*\)~${FAST_SRC}\2~" ${SRC_PATH})&&echo "Done!"
