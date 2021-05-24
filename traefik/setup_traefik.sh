#!/bin/bash

curl -POST -u influx_admin:influx_admin123 http://localhost:8086/query \
--data-urlencode "q=CREATE DATABASE traefik WITH DURATION 7d SHARD DURATION 1d NAME \"weekly\"; CREATE USER \"traefik\" WITH PASSWORD 'traefik123'; GRANT ALL ON \"traefik\" TO \"traefik\""
