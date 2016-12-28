#!/bin/sh
#pip source

PIP_CONF_PATH="/etc/pip.conf"

if [ -f "$PIP_CONF_PATH" ]; then
    mv "$PIP_CONF_PATH" "$PIP_CONF_PATH.bak";
fi;

echo "using https://ipv6.mirrors.ustc.edu.cn/pypi/web/simple as pip source"
echo "[global]">"$PIP_CONF_PATH"
echo "index-url = https://ipv6.mirrors.ustc.edu.cn/pypi/web/simple">>"$PIP_CONF_PATH"
