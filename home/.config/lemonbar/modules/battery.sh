#!/bin/sh

MOD_NAME="battery"

INTERVAL_MODULES="$INTERVAL_MODULES ${MOD_NAME}:5"
MODULES_ORDER="$MODULES_ORDER 1.2:${MOD_NAME}"

TMP_DIR="/tmp/statusbar"
mkdir -p ${TMP_DIR} > /dev/null 2>&1

MORE_BAT_INFO_FILE="${TMP_DIR}/battery_info"
PREV_STATUS="${TMP_DIR}/battery_status"

POW_SUP_DIR="/sys/class/power_supply"

battery_buttons () {
    CUR_FILE="${XDG_CONFIG_HOME}/lemonbar/modules/battery.sh"

    case "$1" in
        "1")
            # Update the battery info file
            STATUS=$(cat ${POW_SUP_DIR}/BAT0/status | tr -d '\n')
            CAP=$(cat ${POW_SUP_DIR}/BAT0/capacity | tr -d '\n')
            printf "%s " "${STATUS} ${CAP}%" > $MORE_BAT_INFO_FILE

            # Update the bar
            run_battery > $FIFO

            # Set a timeout to clear the extra information
            { sleep 3; rm -f $MORE_BAT_INFO_FILE; run_battery > ${FIFO}; } &
            ;;
    esac
}

setup_battery () {
    run_battery
}

run_battery () {
    CUR_FILE="${XDG_CONFIG_HOME}/lemonbar/modules/battery.sh"

    # For now just look at BAT0 for information. Should I make this look for any?
    if [ -d ${POW_SUP_DIR}/BAT0 ]
    then
        STATUS=$(cat ${POW_SUP_DIR}/BAT0/status)
        CAPACITY=$(cat ${POW_SUP_DIR}/BAT0/capacity)

        # Check for any previous state
        OLDSTATUS=$(cat $PREV_STATUS 2> /dev/null)
        if [ ! -z "$OLDSTATUS" ]
        then
            if [ "$OLDSTATUS" != "$STATUS" ]
            then
                # Run the button if the state changed.
                printf "%s\n" "$STATUS" > $PREV_STATUS
                battery_buttons 1
                return
            fi
        else
            # If there was no old status, then print the current status to the file
            printf "%s\n" "$STATUS" > $PREV_STATUS
        fi

        case "$STATUS" in
            "Full") STATUS_SYMBOL="" ;;
            "Charging") STATUS_SYMBOL="⚡" ;;
            "Unknown") STATUS_SYMBOL="?" ;;
            *)
                if [ $CAPACITY -lt 10 ]; then STATUS_SYMBOL=""
                elif [ $CAPACITY -lt 20 ]; then STATUS_SYMBOL=""
                elif [ $CAPACITY -lt 50 ]; then STATUS_SYMBOL=""
                elif [ $CAPACITY -lt 75 ]; then STATUS_SYMBOL=""
                elif [ $CAPACITY -le 100 ]; then STATUS_SYMBOL=""
                else STATUS_SYMBOL="?"; fi

                ;;
        esac

        MORE_INFO_PART="%{A}"
        [ -f "$MORE_BAT_INFO_FILE" ] && MORE_INFO_PART=" $(cat $MORE_BAT_INFO_FILE 2> /dev/null) %{A}"
        printf "${MOD_NAME}%%{A1:. ${CUR_FILE}; battery_buttons 1:}${STATUS_SYMBOL}%s\n" "$MORE_INFO_PART"

        # TODO: Don't send if it has already sent a notification within a certain time period
        [ $CAPACITY -lt 10 -a "$STATUS" != "Charging" ] && \
            notify-send -t 0 --urgency=critical \
            "Low Battery" "Plug your computer in."
    fi
}
