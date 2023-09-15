package main

import (
	"fmt"
	"log"
	"net"
	"os"
	"strings"
	"time"
)

const SERVICE_FQDN = "connectivity-server.autoscaling.svc.cluster.local"

func receiver_server() {
	for {
		listener, err := net.ListenTCP("tcp", &net.TCPAddr{Port: 9999})
		if err != nil {
			log.Println("Error listening, restarting...")
			continue
		}
		for {
			log.Println("Waiting for connection...")
			conn, err := listener.Accept()
			if err != nil {
				log.Println("Error accepting connection: ", err.Error())
			}
			log.Println("Connection accepted")
			buf := make([]byte, 1024)
			read, err := conn.Read(buf)
			if err != nil {
				log.Println("Error reading from connection: ", err.Error())
			}
			log.Println("Read ", read, " bytes; ", string(buf))
		}
	}
}

func sender_server() {
	for {
		service_host := fmt.Sprintf("%s:9999", SERVICE_FQDN)
		conn, err := net.DialTimeout("tcp", service_host, 5*time.Second)

		if err != nil {
			log.Println("Error connecting to server: ", err.Error())
			continue
		}

		log.Println("Connected to server")
		for {
			conn.Write([]byte("Hello, world!"))
			log.Println("Sent message")
			time.Sleep(50 * time.Millisecond)
		}
	}
}

func shouldEnable(envVar string) bool {
	value := os.Getenv(envVar)
	return strings.ToLower(value) == "true"
}

func main() {
	// Metrics server
	// Sender server
	enableSender := shouldEnable("ENABLE_SENDER")
	enableReceiver := shouldEnable("ENABLE_RECEIVER")
	enableMetrics := shouldEnable("ENABLE_METRICS")

	log.Println("Starting :)")
	if enableSender {
		go sender_server()
	}

	if enableReceiver {
		go receiver_server()
	}

	if enableMetrics {

	}

	// Block forever
	select {}
}
