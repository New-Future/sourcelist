#!/usr/bin/env bash

S1=https://ipv6.mirrors.ustc.edu.cn
S2=https://mirrors6.tuna.tsinghua.edu.cn

echo 'Test the speed...'
V1=0
V2=0
for i in `seq 1 10`;do
    V=$(curl -#o /dev/null -w'%{speed_download}' $S1)
    V1=`echo $V1 + $V |bc`;
    V=$(curl -#o /dev/null -w'%{speed_download}' $S2)
    V2=`echo $V2 + $V |bc`;
done 

echo "finished test!"
if (( $(echo "$V1 > $V2" |bc -l) )); then
    echo "$V1 [$S1] >  $V2 [$S2]"
    SOURCE=$V1;
else
    echo "$V1 [$S1] <  $V2 [$S2]"
    SOURCE=$V2;
fi;

echo "change source list to $SOURCE"

(sed -i.bak "s~https\?://\([^/]\+\)\(.*\)~$SOURCE\2~" /etc/apt/sources.list)&&echo "Done!"

apt update
