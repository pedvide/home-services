#!/bin/bash

set -e

FILE=.env

[[ -f $FILE ]] && rm $FILE

echo "INFLUX_UID=$(id -u influxdb)" >> $FILE
echo "INFLUX_GID=$(id -g influxdb)" >> $FILE

echo "" >> $FILE

echo "TELEGRAF_UID=$(id -u telegraf)" >> $FILE
echo "TELEGRAF_GID=$(getent group docker | cut -d: -f3)" >> $FILE
echo "TELEGRAF_HOSTNAME=$(hostname)" >> $FILE

echo "" >> $FILE

echo "DUCKDNS_TOKEN=$(cat duckdns/token | tr -d '\n')" >> $FILE

