.PHONY: all test lint clean

godeps = *.go go.mod go.sum
ffideps = include/ffi.h target/release/librust_ffi.a

all: lint test

test: $(godeps) $(ffideps)
	go test -bench .

lint:
	golangci-lint run ./...

$(ffideps): Cargo.toml build.rs src/lib.rs cbindgen.toml
	cargo build --release

clean:
	rm -f $(binary)
	cargo clean
