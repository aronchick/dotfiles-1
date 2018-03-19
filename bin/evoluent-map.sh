#!/bin/bash
FILTER="Evoluent VerticalMouse 3"
DEVICE="$(xinput | grep -i "${FILTER}" | sed -e 's/^.*id=\([0-9]*\).*$/\1/g')"
#echo "Device found at input ${DEVICE}"
if [[ ! -z "$DEVICE" ]]; then
    for i in $DEVICE; do
      xinput set-button-map ${DEVICE} 1 2 3 4 5 6 7 0 8 10 11 12 13
      echo "Set device $i"
    done 
fi
