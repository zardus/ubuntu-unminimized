#!/bin/bash -e

wget -q -O - "https://hub.docker.com/v2/namespaces/library/repositories/ubuntu/tags?page_size=100" | grep -o '"name": *"[^"]*' | grep -o '[^"]*$' | grep -v -- - | while read TAG
do
	(
		docker pull -q ubuntu:$TAG
		docker build -q -t zardus/ubuntu-unminimized:$TAG --build-arg MIN_IMG=ubuntu:$TAG .
		docker push -q zardus/ubuntu-unminimized:$TAG
	) || echo "FAILURE: $TAG"
done
