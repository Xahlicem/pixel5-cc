#!/system/bin/sh

MODPATH=${0%/*}

$MODPATH/tools/cc.sh &
inotifyd $MODPATH/tools/daemon.sh $MODPATH/