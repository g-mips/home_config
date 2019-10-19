#!/bin/sh

usage () {
    echo "Usage $0 [ -hagG ]"
    echo ""
    echo "    -h -- print this help"
    echo "    -a -- configure all"
    echo "    -g -- configure git"
    echo "    -G -- configure gdb"
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
            error
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
