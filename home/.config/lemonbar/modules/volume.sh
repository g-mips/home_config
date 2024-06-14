#!/bin/sh

MOD_NAME="volume"

MODULES_ORDER="$MODULES_ORDER ${MOD_NAME}"
SINGLE_RUN_MODULES="$SINGLE_RUN_MODULES ${MOD_NAME}"

volume_buttons () {
    case "$1" in
        "1")
            printf "VOLUME\n" > ${FIFO}
            ;;
        "2")
            ;;
        "3")
            ;;
        "4")
            pamixer --allow-boost -i 2; printf "VOLUME\n" > ${FIFO}
            ;;
        "5")
            pamixer --allow-boost -d 2; printf "VOLUME\n" > ${FIFO}
            ;;
    esac
}

setup_volume () {
    run_volume $@
}

run_volume () {
    if [ "$1" != "SIMPLE" ]
    then
        if [ ! -z "$PREV_PID" ]
        then
            kill $PREV_PID > /dev/null 2>&1
            PREV_PID=
        fi
    fi

    VOL=$(pamixer --get-volume)

    # These are font awesome glyphs
    volume_INFO=$(($(pamixer --get-mute) && printf "\uf6a9") || \
        ([ $VOL -eq 0 ] && printf "\uf026") || \
        ([ $VOL -lt 40 ] && printf "\uf027") || \
        ([ $VOL -lt 70 ] && printf "\uf028") || \
        (printf "\uf028"))

    volume_INFO="%{A1:. ~/.config/lemonbar/modules/volume.sh; volume_buttons 1:}%{A4:. ~/.config/lemonbar/modules/volume.sh; volume_buttons 4:}%{A5:. ~/.config/lemonbar/modules/volume.sh; volume_buttons 5:}${volume_INFO}"
    if [ "$1" != "SIMPLE" ]
    then
        volume_INFO="${volume_INFO} $(printf "$VOL%%")%"

        { sleep 2; printf "volume SIMPLE\n" > ${FIFO}; PREV_PID= ; } &
        PREV_PID=$!
    fi

    volume_INFO="${volume_INFO}%{A}%{A}%{A}"
}
