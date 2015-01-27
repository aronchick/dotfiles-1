#!/bin/bash
DEVICE="$(xinput | grep -i evoluent | sed -e 's/^.*id=\([0-9]*\).*$/\1/g')"
#echo "Device found at input ${DEVICE}"
if [[ ! -z "$DEVICE" ]]; then
    xinput set-button-map ${DEVICE} 1 2 3 4 5 6 7 8 9 10 11 12 13
fi
