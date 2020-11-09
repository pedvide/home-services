#!/bin/bash

curl -d '{
"name": "InfluxDB_telegraf",
"type": "influxdb",
"access": "proxy",
"url": "http://influxdb:8086",
"basicAuth": true,
"basicAuthUser": "influx_admin",
"secureJsonData": {
"basicAuthPassword": "influx_admin123"
},
"database": "telegraf",
"user": "telegraf",
"password": "telegraf123",
}' http://admin:grafana123@localhost:3000/api/datasources
