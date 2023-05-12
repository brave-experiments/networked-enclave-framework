binary = websrv
godeps = *.go go.mod go.sum Makefile

$(binary): $(godeps)
	CGO_ENABLED=0 go build -o $(binary)

.PHONY: clean
clean:
	rm -f $(binary)
