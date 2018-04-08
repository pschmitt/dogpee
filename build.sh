#!/usr/bin/env bash

set -e

usage() {
    echo "$(basename "$0") ARCH [-p|--push]"
}

if [[ -z "$1" ]]
then
    usage
    exit 2
fi

case "$1" in
    arm|armhf)
        BASE_IMAGE=resin/raspberry-pi-alpine
        DOCKER_IMAGE=pschmitt/dogpee-armhf
        case $(uname -m) in
            x86_64|i386)
                echo "Setting up ARM compatibility"
                docker run --rm --privileged multiarch/qemu-user-static:register --reset > /dev/null
                ;;
        esac
        ;;
    *)
        BASE_IMAGE=alpine
        DOCKER_IMAGE=pschmitt/dogpee
        ;;
esac

docker build --build-arg BASE_IMAGE="$BASE_IMAGE" -t "$DOCKER_IMAGE" .

case "$2" in
    -p|--push|push)
        docker push "$DOCKER_IMAGE"
        ;;
esac
