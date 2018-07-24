#!/usr/bin/env sh
set -x

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar TODO(gmips): make it a variable
index=0
monitors=$(xrandr -q | grep "connected")
while read -r line; do
    monitor_name=MONITOR$index
    monitor_value=`echo $line | cut -d ' ' -f1`
    declare -x $monitor_name="$monitor_value"
    bar="minimal-top$index"
    polybar $bar &
    bar="minimal-bottom$index"
    polybar $bar &
    let "index++"
done <<< "$monitors"
index=0

