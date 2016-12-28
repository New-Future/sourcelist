#!/usr/bin/env bash
# test speed
LIST=(
    'https://mirrors6.tuna.tsinghua.edu.cn/docker/apt/repo' #tsinghua
	'https://ipv6.mirrors.ustc.edu.cn/apt.dockerproject.org/repo' #ustc
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
# docker project

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
DISTRIBUTOR=$(lsb_release -i| awk '{print tolower($3)}')
CODENAME=$(lsb_release -c|awk '{print tolower($2)}')

echo "deb ${FAST_SRC} ${DISTRIBUTOR}-${CODENAME} main" > /etc/apt/sources.list.d/docker.list

# docker hub 

echo '{ "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"] }' > /etc/docker/daemon.json
