#!/bin/sh

usage () {
echo "Usage $0 [ -hagG ]

   -h -- print this help
   -a -- configure all
   -g -- configure git
   -G -- configure gdb
   -b -- configure bash"
}

error () {
    usage
    exit 1
}

GIT=false
GDB=false
BASH_CONF=false
while getopts "hagGb" option
do
    case "${option}" in
        h)
            usage
            ;;
        a)
            GIT=true
            GDB=true
            BASH_CONF=true
            ;;
        g)
            GIT=true
            ;;
        G)
            GDB=true
            ;;
        b)
            BASH_CONF=true
            ;;
    esac
done

if $GIT
then
    cd git && ./configure.sh
fi

if $GDB
then
    cd gdb && ./configure.sh
fi

if $BASH_CONF
then
    cd bash && ./configure.sh
fi
