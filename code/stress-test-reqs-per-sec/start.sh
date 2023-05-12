#!/bin/sh

set -x

rev="reverse-proxy"
no_rev="no-reverse-proxy"

if [ $# -ne 1 ]
then
	echo >&2 "Usage: $0 \"$rev\" | \"$no_rev\""
	exit 1
fi

# Start nitriding.
if [ "$1" = "$rev" ]
then
	echo "Using nitriding's reverse proxy."
	/nitriding \
		-fqdn "nitro.nymity.ch" \
		-extport 8443 \
		-appwebsrv "http://127.0.0.1:8080" \
		-insecure-no-tls &
elif [ "$1" = "$no_rev" ]
then
	echo "Disabling nitriding's reverse proxy."
	/nitriding \
		-fqdn "nitro.nymity.ch" \
		-extport 8443 \
		-insecure-no-tls &
else
	echo >&2 "Flag $rev or $no_rev must be given."
	exit 2
fi

# Start application.
/websrv -port 8080
