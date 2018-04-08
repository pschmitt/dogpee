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

VOLUME ["/host/run/systemd", "/host/run/dbus"]

ADD dogpee.sh /dogpee.sh
ADD resin-reboot.sh /sbin/resin-reboot

CMD /dogpee.sh
