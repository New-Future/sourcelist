#!/usr/bin/env bash
PIP_CONF_PATH="/etc/pip.conf"
PIP_SOURCE=https://pypi.tuna.tsinghua.edu.cn/simple

if [ -f "$PIP_CONF_PATH" ]; then
    mv "$PIP_CONF_PATH" "$PIP_CONF_PATH.bak";
fi;

echo "[global]">"$PIP_CONF_PATH"
echo "index-url = $PIP_SOURCE">>"$PIP_CONF_PATH"
