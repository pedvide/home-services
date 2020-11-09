#!/bin/bash

sudo useradd -rs /bin/false telegraf
sudo usermod -aG docker telegraf

curl -POST -u influx_admin:influx_admin123 http://localhost:8086/query \
--data-urlencode "q=CREATE DATABASE telegraf WITH DURATION 30d SHARD DURATION 1d NAME \"monthly\"; CREATE USER \"telegraf\" WITH PASSWORD 'telegraf123'; GRANT ALL ON \"telegraf\" TO \"telegraf\""
