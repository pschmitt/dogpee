ARG BASE_IMAGE=alpine
FROM ${BASE_IMAGE}:latest

LABEL maintainer="Philipp Schmitt <philipp@schmitt.co>"

RUN apk add --no-cache bash

ENV DEST_IP= \
    ACTION="reboot" \
    INTERVAL=3 \
    FAIL_COUNT=3 \
    INITIAL_DELAY=30 \
    QUIET=true

VOLUME ["/run/systemd"]
ADD peedog.sh /peedog.sh
CMD /peedog.sh
