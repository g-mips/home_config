#!/bin/sh

for i in {0..255}
do
    printf "\x1b[38;5;${i}mcolor%-3i 38;5;%-7i \x1b[0m" $i $i
    if ! (( ($i + 1 ) % 8 ))
    then
        echo
    fi
done
