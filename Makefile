#!/bin/bash
build:
	docker build -t tor-server .
run:
	docker rm -f tor-server 2> /dev/null; docker run -d --name tor-server tor-server
