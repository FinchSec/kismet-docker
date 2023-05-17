# Kismet container

Docker for https://kismetwireless.net/ - Rebuilt daily.

## Pulling

### DockerHub

[![Docker build and upload](https://github.com/FinchSec/kismet-docker/actions/workflows/docker.yml/badge.svg?event=push)](https://github.com/FinchSec/kismet-docker/actions/workflows/docker.yml)

URL: https://hub.docker.com/r/finchsec/kismet

`sudo docker pull finchsec/kismet`

## Running

`sudo docker run --rm -it --privileged --net=host --pid=host finchsec/kismet`
