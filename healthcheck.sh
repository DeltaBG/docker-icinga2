#!/bin/bash
# Healthcheck for deltabg/icinga2

_PID_FILE=/run/icinga2/icinga2.pid

icinga2 daemon -C > /dev/null 2>&1
_STATUS_CONFIG=$?

pgrep -F $_PID_FILE > /dev/null 2>&1
_STATUS_PGREP=$?

if [ $_STATUS_CONFIG -eq 0 ] && [ $_STATUS_PGREP -eq 0 ]; then
    # If Icinga 2 config test is OK and icinga2 process is runing
    exit 0
fi

exit 1
