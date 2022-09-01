package main

/*
#cgo LDFLAGS: -L target/release -lrust_ffi -lpthread -ldl -static
#cgo CFLAGS: -I include -O3
#include "ffi.h"
*/
import "C"

func callFFINoop() {
	C.noop()
}

func callNoop() {}

func main() {}
