#!/bin/sh

EVENT=${1:-short-press}

logger -t $(basename $0) "[$$]: Received power key event: $@..."

TIMEOUT=3 # s
PIDFILE="/tmp/$(basename $0).pid"

short_press()
{
	logger -t $(basename $0) "[$$]: Power key short press..."

	if type pm-suspend &>/dev/null; then
		LOCK=/var/run/pm-utils/locks/pm-suspend.lock
		SUSPEND_CMD="pm-suspend"
	else
		LOCK=/tmp/.power_key
		PRE_SUSPEND="touch $LOCK"
		SUSPEND_CMD="echo -n mem > /sys/power/state"
		POST_SUSPEND="{ sleep 2 && rm $LOCK; }&"
	fi

	if [ ! -f $LOCK ]; then
		logger -t $(basename $0) "[$$]: Prepare to suspend..."

		sh -c "$PRE_SUSPEND"
		sh -c "$SUSPEND_CMD"
		sh -c "$POST_SUSPEND"
	fi
}

long_press()
{
	logger -t $(basename $0) "[$$]: Power key long press (${TIMEOUT}s)..."

	logger -t $(basename $0) "[$$]: Prepare to power off..."

	poweroff
}

case "$EVENT" in
	press)
		start-stop-daemon -K -q -p $PIDFILE
		start-stop-daemon -S -q -b -m -p $PIDFILE -x /bin/sh -- \
			-c "sleep $TIMEOUT; $0 long-press"
		;;
	release)
		# Avoid race with press event
		sleep .2

		start-stop-daemon -K -q -p $PIDFILE && short_press
		;;
	short-press)
		short_press
		;;
	long-press)
		long_press
		;;
esac
