#!/bin/bash

#### START dnsmasq
service dnsmasq start > /dev/null 2>&1

#### START hostapd
service hostapd start > /dev/null 2>&1

