#!/bin/bash
build:
	docker build -t tor-server-slim .
run:
	docker rm -f tor-server-slim 2> /dev/null; docker run -d --name tor-server-slim tor-server-slim
