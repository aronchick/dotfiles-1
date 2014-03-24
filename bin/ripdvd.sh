#!/bin/bash

OUTPUT_DIR="/mnt/sandbox/rip/dvd"
SOURCE_DRIVE="/dev/sr0"
HANDBRAKE_PRESET="AppleTV 2"
EXTENSION="m4v"

function rip_dvd() {

        # Grab the DVD title
        DVD_TITLE=$(blkid -o value -s LABEL $SOURCE_DRIVE)
        # Replace spaces with underscores
        DVD_TITLE=${DVD_TITLE// /_}

        # Backup the DVD to out hard drive
        dvdbackup -i $SOURCE_DRIVE -o $OUTPUT_DIR -M -n $DVD_TITLE

        # grep for the HandBrakeCLI process and get the PID
        HANDBRAKE_PID=`ps aux|grep H\[a\]ndBrakeCLI`
        set -- $HANDBRAKE_PID
        HANDBRAKE_PID=$2

        # Wait until our previous Handbrake job is done
        if [ -n "$HANDBRAKE_PID" ]
        then
                while [ -e /proc/$HANDBRAKE_PID ]; do sleep 1; done
        fi

        # HandBrake isn't ripping anything so we can pop out the disc
        eject $SOURCE_DRIVE

        # And now we can start encoding
        # Profile listing here https://trac.handbrake.fr/wiki/BuiltInPresets#highprofile
        HandBrakeCLI -i $OUTPUT_DIR/$DVD_TITLE -o $OUTPUT_DIR/$DVD_TITLE.$EXTENSION -e x264 -q 20.0 -a 1,1 -E faac,copy:ac3 -B 160,160 -6 dpl2,none -R Auto,Auto -D 0.0,0.0 --audio-copy-mask aac,ac3,dtshd,dts,mp3 --audio-fallback ffac3 -f mp4 -4 --decomb --loose-anamorphic --modulus 2 -m --x264-preset slow -2 --h264-profile high --h264-level 4.1

        # Clean up
        rm -R $OUTPUT_DIR/$DVD_TITLE
}

rip_dvd
