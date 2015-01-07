#! /bin/sh
### BEGIN INIT INFO
# Provides:          shelvesd
# Required-Start:
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: The shelves daemon service.
# Description:       This file should be used to control lifetime of the
#                    shelvesd daemon running from /etc/init.d.
### END INIT INFO

# Author: Josh Carrier <joshjcarrier@gmail.com>
#

# Defaults
DAEMON_HOME=/opt/shelvesd/lib
DAEMON_MAIN=shelvesd.rb
DAEMON_ARGS=""

# Daemon
NAME=shelvesd
RUBY=$(which ruby)

APP_PIDFILE=$DAEMON_HOME/server.pid
DAEMON_PIDFILE=/var/run/$NAME.pid
DAEMON_LOCKFILE=/var/lock/subsys/$NAME

start() {
    echo -n $"Starting ${NAME}: "

    cd $DAEMON_HOME
    RACK_ENV=production $RUBY $DAEMON_MAIN $DAEMON_ARGS

    sleep 2

    status -p $APP_PIDFILE &> /dev/null && echo_success || echo_failure
    RETVAL=$?

    if [ $RETVAL -eq 0 ]; then
        touch $DAEMON_LOCKFILE
        cat $APP_PIDFILE > $DAEMON_PIDFILE
    fi

    echo
}

stop() {
    echo -n $"Shutting down ${NAME}: "

    killproc -p $DAEMON_PIDFILE
    RETVAL=$?

    [ $RETVAL -eq 0 ] && /bin/rm -f $DAEMON_LOCKFILE $DAEMON_PIDFILE

    echo
}

case "$1" in
    start)
        start
    ;;
    stop)
        stop
    ;;
    restart)
        stop
        start
    ;;
    status)
        status -p $DAEMON_PIDFILE $NAME
    ;;

    *)
        echo "Usage: $SCRIPTNAME {start|stop|restart|status}" >&2
        exit 3
    ;;
esac
