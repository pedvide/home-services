#!/bin/bash 

curl -sG -u influx_admin:influx_admin123 http://localhost:8086/query \
	--data-urlencode "q=SELECT * FROM telegraf.monthly.cpu LIMIT 1" | jq
