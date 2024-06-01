#!/bin/sh

MOD_NAME="data"

INTERVAL_MODULES="$INTERVAL_MODULES ${MOD_NAME}:14"
MODULES_ORDER="$MODULES_ORDER 3.3:${MOD_NAME}"

TMP_DIR="/tmp/statusbar"
mkdir -p ${TMP_DIR} > /dev/null 2>&1

MORE_DATA_INFO_FILE=${TMP_DIR}/show_data_information

data_buttons () {
    NUM_DEVS=$(mount | grep /run/media/$USER | wc -l)

    case "$1" in
        "1")
            touch $MORE_DATA_INFO_FILE
            run_data > /tmp/lemon_fifo
            { sleep 8; rm -f $MORE_DATA_INFO_FILE; run_data > /tmp/lemon_fifo; } &
            ;;
        "2")
            if [ $NUM_DEVS -gt 0 ]
            then
                DEV_TO_UNMOUNT=$(mount | grep /run/media/$USER | cut -d' ' -f1 | \
                    xargs printf "None\n%s" | \
                    dmenu -l 10 -i -p "Choose a device to unmount")
                [ "$DEV_TO_UNMOUNT" != "None" ] && \
                    udisksctl unmount -b $DEV_TO_UNMOUNT
            else
                notify-send "Devices" "No devices to unmount"
            fi
            ;;
        "3") notify-send "Device Sizes" "\n$(df -h --output=source,size,used,avail,pcent,target $(lsblk  -lpn | awk '{ if ($2 != "") { print $1; } }'))" ;;
    esac
}

run_data () {
    CUR_FILE="${XDG_CONFIG_HOME}/lemonbar/modules/data.sh"
    SCRIPT=". ${CUR_FILE}; data_buttons"

    NUM_DEVS=$(mount | grep /run/media/$USER | wc -l)
    ROOT_INFO=$(mount | grep "/ ")

    MORE_INFO_PART=
    [ -f "$MORE_DATA_INFO_FILE" ] && MORE_INFO_PART="$(printf " / %s%% %s " "$(df -h / | tail -n1 | tr -s '[:space:]' | cut -d' ' -f5)" "$([ $NUM_DEVS -gt 0 ] && printf " \uf287 ($NUM_DEVS)")")"

    printf "${MOD_NAME}%%{A1:${SCRIPT} 1:}%%{A2:${SCRIPT} 2:}%%{A3:${SCRIPT} 3:}\uf0a0%s%%{A}%%{A}%%{A}\n" "$MORE_INFO_PART"
}
