package main

import (
	"testing"
)

func BenchmarkPythonFFI(b *testing.B) {
	pyInit()
	defer pyExit()
	for n := 0; n < b.N; n++ {
		callFFINoop()
	}
}

func BenchmarkBaseline(b *testing.B) {
	for n := 0; n < b.N; n++ {
		callNoop()
	}
}
