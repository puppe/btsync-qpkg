#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="BitTorrentSync"

INSTALL_PATH=$(/sbin/getcfg $QPKG_NAME Install_Path -f $CONF)
CONFIG=$INSTALL_PATH/btsync.conf

case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    fi

    PID=`pidof btsync`
    if [ $PID ]; then
        echo "BTSync already running"
    else
        echo "Starting btsync service"
        $INSTALL_PATH/btsync --config $CONFIG
    fi
    ;;

  stop)
    PID=`pidof btsync`
    if [ $PID ]; then
        echo "Stopping btsync service"
        kill -INT $PID
    else
        echo "BTSync isn't running"
    fi
    ;;

  restart)
    $0 stop
    $0 start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
