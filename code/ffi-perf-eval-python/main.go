package main

/*
#cgo pkg-config: python3-embed
#include <Python.h>
*/
import "C"

const (
	pythonCode = `
def noop():
  pass
noop()
`
)

var (
	pyCode *C.PyObject
	pyDict *C.PyObject
)

func pyInit() {
	C.Py_Initialize()

	pyDict = C.PyDict_New()
	pyCode = C.Py_CompileString(
		C.CString(pythonCode),
		C.CString(""),
		C.Py_file_input,
	)
}

func pyExit() {
	C.Py_Finalize()
}

func callFFINoop() {
	C.PyEval_EvalCode(pyCode, pyDict, pyDict)
}

func callNoop() {}

func main() {}
