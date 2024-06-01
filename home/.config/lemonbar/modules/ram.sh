#!/bin/sh

MOD_NAME="ram"

INTERVAL_MODULES="$INTERVAL_MODULES ${MOD_NAME}:3"
MODULES_ORDER="$MODULES_ORDER 3.2:${MOD_NAME}"

TMP_DIR="/tmp/statusbar"
mkdir -p ${TMP_DIR} > /dev/null 2>&1

MORE_RAM_INFO_FILE=${TMP_DIR}/show_ram_usage

ram_buttons () {
    case "$1" in
        "1")
            touch $MORE_RAM_INFO_FILE
            run_ram > /tmp/lemon_fifo
            { sleep 8; rm -f $MORE_RAM_INFO_FILE; run_ram > /tmp/lemon_fifo; } &
            ;;
        "2")
            alacritty --class "Alacritty,float" --command top -o "%MEM"
            ;;
    esac
}

run_ram () {
    CUR_FILE="${XDG_CONFIG_HOME}/lemonbar/modules/ram.sh"

    MORE_INFO_PART=
    [ -f "$MORE_RAM_INFO_FILE" ] && MORE_INFO_PART=" $(free -h | awk '/^Mem/ { print $3"/"$2 }' | sed s/i//g)"

    printf "${MOD_NAME}%%{A1:. ${CUR_FILE}; ram_buttons 1:}%%{A2:. ${CUR_FILE}; ram_buttons 2:}%s%%{A}%%{A}\n" "$MORE_INFO_PART"
}
