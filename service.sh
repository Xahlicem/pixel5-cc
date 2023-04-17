#!/system/bin/sh

MODPATH=${0%/*}

/system/bin/cc &
inotifyd $MODPATH/tools/daemon.sh $MODPATH/