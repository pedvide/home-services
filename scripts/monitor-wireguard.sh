#!/bin/bash

shout() { echo "${RED}$0: $*${NOCOLOR}" >&2;  }
die() { shout "${*:2} ($1)"; exit "$1";  }
try() { "$@" || die $? "cannot $*";  }

# get the peer public key, endpoint ip, last handshake epoch, transfer-rx and tx
try docker exec wireguard wg show wg0 dump | tail -n +2 | cut -f 1,3,5-7 | ts '%Y-%m-%dT%H:%M:%S%z' >> /var/log/wireguard/wg.log
