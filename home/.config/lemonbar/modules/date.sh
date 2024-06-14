#!/bin/sh

MOD_NAME="get_date"

INTERVAL_MODULES="$INTERVAL_MODULES ${MOD_NAME}:5"
MODULES_ORDER="$MODULES_ORDER 1.1:${MOD_NAME}"

CUR_FILE="${XDG_CONFIG_HOME}/lemonbar/modules/date.sh"
SCRIPT=". ${CUR_FILE}; get_date_buttons"

TMP_DIR="/tmp/statusbar"
mkdir -p ${TMP_DIR} > /dev/null 2>&1

MORE_DATE_INFO_FILE=${TMP_DIR}/show_day

get_date_buttons () {
    case "$1" in
        "1")
            touch $MORE_DATE_INFO_FILE
            run_get_date > ${FIFO}
            { sleep 6; rm -f $MORE_DATE_INFO_FILE; run_get_date > ${FIFO}; } &
            ;;
        "2")
            notify-send -t 15000 "Calendar" "$(cal)"
            ;;
    esac
}

setup_get_date () {
    run_get_date
}

run_get_date () {
    [ -f "$MORE_DATE_INFO_FILE" ] && MORE_INFO_PART="$(date '+%d %b %y (%a) %T')" \
        || MORE_INFO_PART="$(date '+%T')"
    printf "${MOD_NAME}%%{A1:${SCRIPT} 1:}%%{A2:${SCRIPT} 2:}%s%%{A}%%{A}\n" "$MORE_INFO_PART"
}
