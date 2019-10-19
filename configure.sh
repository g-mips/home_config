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
while getopts "hagG" option
do
    case "${option}" in
        h)
            error
            ;;
        a)
            GIT=true
            GDB=true
            ;;
        g)
            GIT=true
            ;;
        G)
            GDB=true
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
