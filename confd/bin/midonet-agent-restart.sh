#!/bin/bash
$PIDFILE=/var/tmp/midonet-agent-pid.lock
if [ -f $PIDFILE]; then
	echo "[midonet-agent-monitor] Lockfile found at $PIDFILE, killing process"
	$PID=${cat $PIDFILE}
  kill $PID
  rm -f $PIDFILE
  echo "[midonet-agent-monitor] Killed process $PID, starting new process"
  /usr/share/midolman/midolman-start
  $PID=$0
  echo $0 > $PIDFILE
  echo "[midonet-agent-monitor] New process with PID $PID"
else
  echo "[midonet-agent-monitor] No lockfile found, starting new process"
  /usr/share/midolman/midolman-start
  $PID=$0
  echo $0 > $PIDFILE
  echo "[midonet-agent-monitor] New process with PID $PID"
fi
