#!/bin/bash

echo "ms,pct,threads,setting,reqssec" > data.csv
#for i in 1 10 25 50 100 250 500
for i in 8 16 32 64 128 256 512
do
	echo "[sh] Running experiments with $i concurrent threads."

	make num_concur_reqs="$i" test-loopback
	sleep 3

	make num_concur_reqs="$i" test-docker
	sleep 3

	make num_concur_reqs="$i" test-enclave
	sleep 3

	make num_concur_reqs="$i" test-nitriding
	sleep 3

	make num_concur_reqs="$i" test-nitriding-nrp
	sleep 3
done
