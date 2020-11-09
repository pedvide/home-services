#!/bin/bash

sudo useradd -rs /bin/false influxdb
sudo mkdir -p /var/lib/influxdb

docker run --rm -e INFLUXDB_HTTP_AUTH_ENABLED=true \
	-e INFLUXDB_ADMIN_USER=influx_admin -e INFLUXDB_ADMIN_PASSWORD=influx_admin123 \
	-v /var/lib/influxdb:/var/lib/influxdb \
    --user "$(id -u influxdb)":"$(id -g influxdb)" \
	influxdb /init-influxdb.sh

sudo chown influxdb:influxdb /var/lib/influxdb/**/*
