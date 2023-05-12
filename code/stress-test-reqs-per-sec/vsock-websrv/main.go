package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"net/http"

	"github.com/mdlayher/vsock"
)

func createListener(useVSOCK bool, port int) net.Listener {
	var l net.Listener
	var err error

	if useVSOCK {
		l, err = vsock.Listen(uint32(port), nil)
		if err != nil {
			log.Fatal(err)
		}
	} else {
		l, err = net.Listen("tcp", fmt.Sprintf(":%d", port))
		if err != nil {
			log.Fatal(err)
		}
	}
	log.Println("Created listener for Web server.")
	return l
}

func defaultHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello world!")
}

func main() {
	var useVSOCK bool
	var port int

	flag.IntVar(&port, "port", 8080, "Web server port to listen on.")
	flag.BoolVar(&useVSOCK, "vsock", false, "Listen on AF_VSOCK instead of AF_INET.")
	flag.Parse()
	log.Println("Parsed command line arguments.")

	l := createListener(useVSOCK, port)
	log.Printf("Listening on: %s", l.Addr())
	var srv http.Server
	mux := http.NewServeMux()
	mux.HandleFunc("/", defaultHandler)
	srv.Handler = mux

	log.Println("Starting Web server now.")
	log.Fatal(srv.Serve(l))
}
