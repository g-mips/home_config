#!/bin/bash
START_PATH=.
FILE_PATT=*
CONFIRM=
REGEX=
REPLACEMENT=

usage () {
	echo "Usage: $0 [-p <root path> ] [-f <file pattern>] [-c (ask for confirmation)] <regex> <replacement string>"
	exit 1
}

while getopts "p:f:c" flag; do
	case "${flag}" in
		p)
			START_PATH=${OPTARG}
			;;
		f)
			FILE_PATT=${OPTARG}
			;;
		c)
			CONFIRM=c
			;;
	esac
done

REGEX=${@:$OPTIND:1}
REPLACEMENT=${@:$OPTIND+1:1}

if [ -z "${REGEX}" ]; then
	usage
fi

if [ -z "${REPLACEMENT}" ]; then
	usage
fi

find $START_PATH -name "$FILE_PATT" -type f -exec vim -c "%s/$REGEX/$REPLACEMENT/g$CONFIRM" -c "wq" {} \;
