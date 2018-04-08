#!/usr/bin/env bash

DEST_IP="${1:-$DEST_IP}"
ACTION="${2:-$ACTION}"
INTERVAL="${3:-$INTERVAL}"
FAIL_COUNT=${4:-$FAIL_COUNT}
INITIAL_DELAY=${5:-$INITIAL_DELAY}
QUIET=${6:-$QUIET}

usage() {
    echo "$(basename "$0") [DEST_IP] [ACTION] [INTERVAL] [FAIL_COUNT] [INITIAL_DELAY]"
}

gateway_ip() {
    ip r | awk '/default/ { print $3; exit }'
}

check() {
    ping -c 1 -W 5 "$1" > /dev/null 2>&1
}

log() {
    echo "$(date -Iseconds): $*"
}

if [[ -z "$DEST_IP" ]]
then
    DEST_IP=$(gateway_ip)
fi

log "Monitoring reachability of $DEST_IP"

if [[ -n "$INITIAL_DELAY" ]]
then
    log "Sleeping for ${INITIAL_DELAY}s"
    sleep "$INITIAL_DELAY"
fi

FAILS=0

while :
do
    if check "$DEST_IP"
    then
        if [[ "$FAILS" -gt 0 ]]
        then
            log "Connection restored. Reset fail counter."
            FAILS=0
        else
            if [[ "$QUIET" != "true" ]]
            then
                log "Connection succeeded."
            fi
        fi
    else
        FAILS=$(( FAILS + 1 ))
        log "Connection failed. Fail count: ${FAILS}/${FAIL_COUNT}"
        if [[ "$FAILS" -ge "$FAIL_COUNT" ]]
        then
            log "Engaging action ${ACTION}."
            eval "$ACTION"
            exit 1
        fi
    fi
    sleep "$INTERVAL"
done
