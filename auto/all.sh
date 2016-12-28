#!/usr/bin/env bash
# test speed
LIST=(
    'https://tuna.tsinghua.edu.cn/docker/apt/repo' #tsinghua
	'https://mirrors.ustc.edu.cn/apt.dockerproject.org/repo' #ustc
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
#!/usr/bin/env bash
# test speed
LIST=(
    'https://mirrors.tuna.tsinghua.edu.cn/' #tsinghua
	'https://mirrors.ustc.edu.cn/' #ustc
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
#!/usr/bin/env bash
# test speed
LIST=(
    'https://pypi.tuna.tsinghua.edu.cn/simple' #tsinghua
	'https://mirrors.ustc.edu.cn/pypi/web/simple' #ustc
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
#pip source

PIP_CONF_PATH="/etc/pip.conf"

if [ -f "$PIP_CONF_PATH" ]; then
    mv "$PIP_CONF_PATH" "$PIP_CONF_PATH.bak";
fi;

echo "using ${FAST_SRC} as pip source"
echo "[global]">"$PIP_CONF_PATH"
echo "index-url = ${FAST_SRC}">>"$PIP_CONF_PATH"
