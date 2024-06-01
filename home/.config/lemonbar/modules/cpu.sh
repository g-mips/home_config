#!/bin/sh

MOD_NAME="cpu"

INTERVAL_MODULES="$INTERVAL_MODULES ${MOD_NAME}:5"
MODULES_ORDER="$MODULES_ORDER 3.1:${MOD_NAME}"

TMP_DIR="/tmp/statusbar"
mkdir -p ${TMP_DIR} > /dev/null 2>&1

MORE_CPU_INFO_FILE=${TMP_DIR}/show_cpu_percentage
OLD_CPU_INFO_FILE=${TMP_DIR}/oldcpuinfo

cpu_buttons () {
    case "$1" in
        "1")
            touch $MORE_CPU_INFO_FILE
            run_cpu > /tmp/lemon_fifo
            { sleep 8; rm -f $MORE_CPU_INFO_FILE; run_cpu > /tmp/lemon_fifo; } &
            ;;
        "2")
            alacritty --class "Alacritty,float" --command top -o "%CPU" &
            ;;
    esac
}

run_cpu () {
    CUR_FILE="${XDG_CONFIG_HOME}/lemonbar/modules/cpu.sh"

    # Gather old info (either is the first time or saved in the oldcpuinfo file
    PREV_TOTAL=0
    PREV_IDLE=0

    [ -f $OLD_CPU_INFO_FILE ] && read PREV_TOTAL PREV_IDLE < $OLD_CPU_INFO_FILE

    # Read in all the times from the first line which represents all cores
    read CPU TIME1 TIME2 TIME3 IDLE TIME4 TIME5 TIME6 TIME7 TIME8 TIME9 < /proc/stat

    # Calculate the total time including idle time
    TOTAL=$(( TIME1 + TIME2 + TIME3 + IDLE + TIME4 + TIME5 + TIME6 + TIME7 + TIME8 + TIME9 ))

    # Difference between current idle and previous idle
    DIFF_IDLE=$((IDLE - PREV_IDLE))

    # Difference between current total and previous total
    DIFF_TOTAL=$((TOTAL - PREV_TOTAL))
    CPU_USAGE1=$(( (1000 * (DIFF_TOTAL - DIFF_IDLE) / (DIFF_TOTAL + 5) ) ))
    CPU_USAGE=0
    [ $CPU_USAGE1 -ne 0 ] && CPU_USAGE=$(( CPU_USAGE1 / 10 ))

    # TODO Send high CPU usage notifications

    # Append zeros for printing that does make the status bar jump
    [ ${#CPU_USAGE} -eq 1 ] && CPU_USAGE=00${CPU_USAGE}
    [ ${#CPU_USAGE} -eq 2 ] && CPU_USAGE=0${CPU_USAGE}

    # The following unicode characters are just regular unicode. Nothing special.
    STRING=""
    if [ $CPU_USAGE -eq 100 ]
    then
        STRING="$STRING█"
    else
        # Display a symbol for a visual picture
        case "$(printf $CPU_USAGE | cut -c2)" in
        "0") STRING="$STRING▁";;
        "1") STRING="$STRING▂";;
        "2") STRING="$STRING▃";;
        "3") STRING="$STRING▄";;
        "4") STRING="$STRING▅";;
        "5") STRING="$STRING▆";;
        "6") STRING="$STRING▇";;
        "7") STRING="$STRING█";;
        "8") STRING="$STRING█";;
        "9") STRING="$STRING█";;
    esac
    fi

    # Display the real usage percentage
    MORE_INFO_PART=
    [ -f "$MORE_CPU_INFO_FILE" ] && MORE_INFO_PART=" ${CPU_USAGE}%%%%"
    printf "${MOD_NAME}%%{A1:. ${CUR_FILE}; cpu_buttons 1:}%%{A2:. ${CUR_FILE}; cpu_buttons 2:}${STRING}${MORE_INFO_PART}%%{A}%%{A}\n"

    # Save the old stuff
    printf "$TOTAL $IDLE\n" > $OLD_CPU_INFO_FILE
}
