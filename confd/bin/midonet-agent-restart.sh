#!/bin/bash
PIDFILE=/var/tmp/midonet-agent-pid.lock
WDPIDFILE=/var/tmp/midonet-agent-wd-pid.lock
if [ -f $PIDFILE ]; then
  echo "[midonet-agent-monitor] Lockfile found at $PIDFILE, killing process"
  PID=$(cat $PIDFILE)
  WDPID=$(cat $PIDFILE)
  kill $PID
  kill $WDPID
  rm -f $PIDFILE
  rm -f $WDPIDFILE
  echo "[midonet-agent-monitor] Killed process $PID, starting new process"
  sv restart midolman
  sleep 2
  PID=$(pidof java)
  WDPID=$(pidof wdog)
  echo $PID > $PIDFILE
  echo $WDPID > $WDPIDFILE
  echo "[midonet-agent-monitor] New process with PID $PID"
else
  echo "[midonet-agent-monitor] No lockfile found, starting new process"
  sv restart midolman
  sleep 2
  PID=$(pidof java)
  WDPID=$(pidof wdog)
  echo $PID > $PIDFILE
  echo $WDPID > $WDPIDFILE
  echo "[midonet-agent-monitor] New process with PID $PID"
fi
