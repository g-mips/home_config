#!/bin/sh

MOD_NAME="updates"

INTERVAL_MODULES="$INTERVAL_MODULES ${MOD_NAME}:120"
MODULES_ORDER="$MODULES_ORDER 2.2:${MOD_NAME}"

TMP_DIR="/tmp/update_status"
mkdir -p ${TMP_DIR} > /dev/null 2>&1
chmod 777 $TMP_DIR > /dev/null 2>&1

MORE_UPDATES_INFO_FILE="${TMP_DIR}/updates_info"
MORE_UPDATES_INFO_FILE_TMP="${TMP_DIR}/updates_info_tmp"

updates_buttons () {
    case "$1" in
        "1")
            [ ! -f "$MORE_UPDATES_INFO_FILE_TMP" ] && INFO=$(yay -Qu | wc -l) && \
                printf "%s" "$INFO" > $MORE_UPDATES_INFO_FILE_TMP
            cp $MORE_UPDATES_INFO_FILE_TMP $MORE_UPDATES_INFO_FILE

            # Update the bar
            run_updates > ${FIFO}

            # Set a timeout to clear the extra information
            { sleep 3; rm -f $MORE_UPDATES_INFO_FILE; run_updates > ${FIFO}; } &
            ;;
        "2")
            ANSWER=$(printf "1\n2\n" | dmenu -i -p "(1) Install downloaded packages or (2) Download packages")
            [ "$ANSWER" = "1" ] && notify-send --urgency normal \
                "Repository Update" "About to update. Requires password" && \
                alacritty --class "Alacritty,float" --command \
                $HOME/.local/bin/statusbar/run-update.sh &
            [ "$ANSWER" = "2" ] && notify-send "Forcing package download" && \
                alacritty --class "Alacritty,float" --command \
                    $HOME/.local/bin/cronjobs/repoupdate.sh &
            ;;
        "3")
            notify-send "******** Packages that need upgrades ********" \
                "\n$($HOME/.local/bin/statusbar/list-upgradeable-packages.sh)"
            ;;
    esac
}

watch_for_updates () {
    while true
    do
        inotifywait -e close_write ${TMP_DIR}/repoupdate-state > /dev/null 2>&1
        run_updates
    done
}

setup_updates () {
    touch ${TMP_DIR}/repoupdate-state > /dev/null 2>&1
    watch_for_updates &
    printf "$! " >> ${XDG_RUNTIME_DIR}/lemonbar/lemon.pids
    run_updates
}

run_updates () {
    # Update the updates file
    # TODO: Make this not dependent on yay. Maybe put it in another script
    # that looks for the correct package manager?
    #{ INFO=$(yay -Qu | wc -l); printf "%s" "$INFO" > $MORE_UPDATES_INFO_FILE_TMP; } &

    # Get the more information part
    MORE_INFO_PART=
    [ -f "$MORE_UPDATES_INFO_FILE" ] &&  MORE_INFO_PART=" $(cat $MORE_UPDATES_INFO_FILE 3> /dev/null)"

    # Print the stuff
    SYMBOL="\uf466"
    [ -s ${TMP_DIR}/repoupdate-state ] && read SYMBOL < ${TMP_DIR}/repoupdate-state
    printf "${MOD_NAME}%%{A1:. ~/.config/lemonbar/modules/updates.sh; updates_buttons 1:}%%{A2:. ~/.config/lemonbar/modules/updates.sh; updates_buttons 2:}%%{A3:. ~/.config/lemonbar/modules/updates.sh; updates_buttons 3:}${SYMBOL}${MORE_INFO_PART}%%{A}%%{A}%%{A}\n"
}
