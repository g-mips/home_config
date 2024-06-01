#!/bin/sh

[ $# -ge 1 ] && MAX=$1 || MAX=255

for i in $(eval echo {0..${MAX}})
do
    printf "\x1b[38;5;${i}mcolor%-3i 38;5;%-7i \x1b[0m" $i $i
    if ! (( ($i + 1 ) % 8 ))
    then
        echo
    fi
done
