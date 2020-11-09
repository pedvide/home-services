#!/bin/bash

sudo useradd -rs /bin/false grafana
sudo mkdir -p /var/lib/grafana
sudo chown grafana:grafana /var/lib/grafana
