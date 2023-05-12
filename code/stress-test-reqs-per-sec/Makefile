application = websrv
enclave_image = $(application).eif
stdout = data.csv
stderr = stderr.log

# Our Web server's port.
application_port = 8080
# Nitriding's port.
nitriding_port = 8443

# The local Docker port that's forwarded to the Web server.
docker_port = 8081
# The local gvproxy port that's forwarded to nitriding.
gvproxy_port = 8082
# The local gvproxy port that's forwarded to the Web server.
gvproxy_port_nrp = 8083
# Nitriding's profiling port for debugging
gvproxy_port_profiling = 6060

num_concur_reqs = 10
num_reqs = 100000

tag_docker = $(application)-docker:latest
tag_enclave = $(application)-enclave:latest
tag_nitriding = $(application)-nitriding:latest
tag_nitriding_nrp = $(application)-nitriding-nrp:latest

all: $(application) test-loopback test-docker test-enclave test-nitriding test-nitriding-nrp

$(application):
	make -C vsock-websrv/

.PHONY: kill-enclave
kill-enclave:
	nitro-cli terminate-enclave --all

.PHONY: run-enclave
run-enclave:
	nitro-cli run-enclave \
		--cpu-count 2 \
		--memory 4000 \
		--enclave-cid 4 \
		--eif-path $(enclave_image) # --debug-mode --attach-console

.PHONY: gvproxy
gvproxy:
	sudo killall -q gvproxy | true # Ignore non-zero exit status.
	sleep 1
	sudo gvproxy \
		-listen vsock://:1024 \
		-listen unix:///tmp/network.sock \
		-mtu 65000 &
	sleep 1 # Give the proxy a second to start before configuring port forwarding rules.
	sudo curl \
		--unix-socket /tmp/network.sock \
		-X POST \
		-d '{"local":"127.0.0.1:$(gvproxy_port)","remote":"192.168.127.2:$(nitriding_port)"}' \
		http:/unix/services/forwarder/expose
	sudo curl \
		--unix-socket /tmp/network.sock \
		-X POST \
		-d '{"local":"127.0.0.1:$(gvproxy_port_nrp)","remote":"192.168.127.2:$(application_port)"}' \
		http:/unix/services/forwarder/expose
	sudo curl \
		--unix-socket /tmp/network.sock \
		-X POST \
		-d '{"local":"127.0.0.1:$(gvproxy_port_profiling)","remote":"192.168.127.2:$(gvproxy_port_profiling)"}' \
		http:/unix/services/forwarder/expose

#
# Run Web server over loopback interface.  This is our baseline.
#

.PHONY: test-loopback
test-loopback:
	./run-websrv-loopback.sh $(num_concur_reqs) $(num_reqs) $(stdout) $(stderr)

#
# Run Web server in Docker, without enclaves.
#

.PHONY: build-docker $(binary)
build-docker: Dockerfile.docker
	docker build -t $(tag_docker) -f Dockerfile.docker .

.PHONY: run-docker
run-docker: build-docker
	$(eval DOCKER_ID=$(shell docker ps -q --filter ancestor=$(tag_docker)))
	@if [ -n "$(DOCKER_ID)" ]; then docker rm -f $(DOCKER_ID); fi
	docker run --rm --detach -p $(docker_port):$(application_port) $(tag_docker)

.PHONY: test-docker
test-docker: run-docker
	baton -i -s "Docker" -c $(num_concur_reqs) -r $(num_reqs) -u http://127.0.0.1:$(docker_port) >>$(stdout) 2>>$(stderr)
	docker stop $$(docker ps -a -q --filter ancestor=$(tag_docker) --format="{{.ID}}")

#
# Inside enclave (but without nitriding).
#

.PHONY: build-enclave
build-enclave: Dockerfile.enclave $(binary)
	docker build -t $(tag_enclave) -f Dockerfile.enclave .
	nitro-cli build-enclave \
		--docker-uri $(tag_enclave) \
		--output-file $(enclave_image)

.PHONY: test-enclave
test-enclave: build-enclave kill-enclave run-enclave
	baton -i -s "Enclave" -c $(num_concur_reqs) -r $(num_reqs) -u http://4:$(application_port) >>$(stdout) 2>>$(stderr)

#
# Standard nitriding.
#

.PHONY: build-nitriding
build-nitriding: Dockerfile.nitriding $(binary)
	docker build -t $(tag_nitriding) -f Dockerfile.nitriding .
	nitro-cli build-enclave \
		--docker-uri $(tag_nitriding) \
		--output-file $(enclave_image)

.PHONY: test-nitriding
test-nitriding: build-nitriding kill-enclave gvproxy run-enclave
	# baton -i -s "Nitriding" -c $(num_concur_reqs) -r $(num_reqs) -u http://127.0.0.1:$(gvproxy_port) >>$(stdout) 2>>$(stderr)
	baton -i -s "Nitriding" -c $(num_concur_reqs) -r $(num_reqs) -u http://127.0.0.1:$(gvproxy_port)
	# bombardier --fasthttp -c $(num_concur_reqs) -n $(num_reqs) http://127.0.0.1:$(gvproxy_port)
	# /home/ec2-user/sw/wrk/wrk -t $(num_concur_reqs) -c100 -d30s http://127.0.0.1:$(gvproxy_port)

#
# Nitriding without reverse proxy.
#

.PHONY: build-nitriding-nrp
build-nitriding-nrp: Dockerfile.nitriding-nrp $(binary)
	docker build -t $(tag_nitriding_nrp) -f Dockerfile.nitriding-nrp .
	nitro-cli build-enclave \
		--docker-uri $(tag_nitriding_nrp) \
		--output-file $(enclave_image)

.PHONY: test-nitriding-nrp
test-nitriding-nrp: build-nitriding-nrp kill-enclave gvproxy run-enclave
	baton -i -s "Nitriding-nrp" -c $(num_concur_reqs) -r $(num_reqs) -u http://127.0.0.1:$(gvproxy_port_nrp) >>$(stdout) 2>>$(stderr)
