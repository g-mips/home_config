#!/bin/sh

MOD_NAME="temperature"

INTERVAL_MODULES="$INTERVAL_MODULES ${MOD_NAME}:15"
MODULES_ORDER="$MODULES_ORDER 3.4:${MOD_NAME}"

TMP_DIR="/tmp/statusbar"
mkdir -p ${TMP_DIR} > /dev/null 2>&1

MORE_TEMP_INFO_FILE="${TMP_DIR}/show_temp"

temperature_buttons () {
    case "$1" in
        "1")
            touch $MORE_TEMP_INFO_FILE
            run_temperature > ${FIFO}
            { sleep 8; rm -f $MORE_TEMP_INFO_FILE; run_temperature > ${FIFO}; } &
            ;;
    esac
}

setup_temperature () {
    run_temperature
}

run_temperature () {
    CUR_FILE="${XDG_CONFIG_HOME}/lemonbar/modules/temp.sh"

    THERMAL_ZONES=$(ls -d -1 /sys/class/thermal/thermal_zone*)
    GREATEST_TEMP=0
    for ZONE in $THERMAL_ZONES
    do
        [ $(cat ${ZONE}/temp) -gt $GREATEST_TEMP ] && GREATEST_TEMP=$(cat ${ZONE}/temp)
    done

    TEMP=$(printf "scale=2; $GREATEST_TEMP / 1000.0\n" | bc -l | tr '\n' ' ')
    INT_TEMP=$(printf "$TEMP" | cut -d'.' -f1)

    SYMBOL="\uf2cb"
    if [ $INT_TEMP -lt 40 ]; then SYMBOL="\uf2cb";
    elif [ $INT_TEMP -lt 50 ]; then SYMBOL="\uf2ca";
    elif [ $INT_TEMP -lt 60 ]; then SYMBOL="\uf2c9";
    elif [ $INT_TEMP -lt 70 ]; then SYMBOL="\uf2c8";
    else SYMBOL="\uf2c7"; fi

    MORE_INFO_PART=
    [ -f "$MORE_TEMP_INFO_FILE" ] && MORE_INFO_PART=" ${TEMP}℃"
    printf "${MOD_NAME}%%{A1:. ${CUR_FILE}; temperature_buttons 1:}${SYMBOL}${MORE_INFO_PART}%%{A}\n"

    [ $INT_TEMP -gt 78 ] && \
        notify-send -t 0 --urgency=critical \
            "Overtemperature" "WARNING: You are beginning to overheat: $TEMP℃"
}
