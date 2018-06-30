#!/bin/bash
set -m

if [ -z "`ls /var/lib/clamav`" ] 
then
	mv /lib-start/clamav/* /var/lib/clamav && chown -R clamav:clamav /var/lib/clamav
fi

freshclam -d &
clamd &

pids=`jobs -p`

exitcode=0

function terminate() {
    trap "" CHLD

    for pid in $pids; do
        if ! kill -0 $pid 2>/dev/null; then
            wait $pid
            exitcode=$?
        fi
    done

    kill $pids 2>/dev/null
}

trap terminate CHLD
wait

# option with entrypoint
if [ -f "/option.sh" ]; then /option.sh; fi

exit $exitcode
