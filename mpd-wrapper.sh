#!/bin/bash

# Variables defining executables (override as needed)
#
MPD=mpd
MPDSCRIBBLE=mpdscribble

# note: you might want to remove the -D (verbose) here:
MPD_RANDOM_PL_ALBUM="mpd-random-pl-album.py -d -D"


# Check for daemons and start if necessary
#

if [ $(pgrep -x $MPD | wc -l) -lt 1 ]; then
  echo "starting mpd with: $MPD"
  $MPD
  count=1
  while [ $(pgrep -x $MPD | wc -l) -lt 1 ]; do
     count=$(($count+1))
     if [ $count -gt 5 ]; then
       echo "mpd did not start!"
       exit 1
     fi
     echo "waiting for mpd to start"
     sleep 1
  done
fi

if [ $(pgrep -x $MPDSCRIBBLE | wc -l) -lt 1 ]; then
  echo "starting mpdscribble with: $MPDSCRIBBLE"
  $MPDSCRIBBLE
fi

if [ $(ps -ef | grep "$MPD_RANDOM_PL_ALBUM" | grep python | grep -v grep | wc -l) -lt 1 ]; then
  echo "starting mpd-random-pl-album.py with: $MPD_RANDOM_PL_ALBUM"
  ($MPD_RANDOM_PL_ALBUM >> /tmp/mpd-random-pl-album.log 2>&1) &
fi
