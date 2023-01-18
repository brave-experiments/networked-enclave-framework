#!/bin/bash

set -x

echo "[+] Starting nitriding."
/nitriding -fqdn "nitro.nymity.ch" &

echo "[+] Starting tor."
tor -f /torrc
