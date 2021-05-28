#!/usr/bin/python3

import subprocess
import shlex
import pandas as pd
from datetime import datetime

proc = subprocess.run(
    shlex.split("docker exec wireguard wg show wg0 dump"),
    capture_output=True
)
data_array = [
    line.split("\t")
    for line in proc.stdout.decode("utf").strip().split("\n")[1:]
]
data = pd.DataFrame(
    data_array,
    columns=[
        "peer", "private_key", "endpoint", "allowed_ips",
        "latest_handshake", "rx", "tx", "keepalive"
    ]
)
data["timestamp"] = (
    datetime.now()
    .astimezone()
    .replace(microsecond=0)
    .isoformat()
)

peers = {
    "7EROgcNoVpOuvbAjLFlBuA2QvlRvXahxz4+7HAjZGlY=": "surface-tablet",
    "7BQKeXhuMYWbR+sbPBLcDQo+S2JHPavjbA+iaTx8dSU=": "smartphone"
}
data["peer_name"] = data["peer"].map(peers)

log_data = data[
    ["timestamp", "peer", "peer_name", "endpoint", "latest_handshake", "tx", "rx"]
]
(
    log_data
    .to_csv(
        "/var/log/wireguard/wg.log", mode="a", header=False,
        index=False, sep="\t"
    )
)
