#!/bin/sh

MOD_NAME="internet"

INTERVAL_MODULES="$INTERVAL_MODULES ${MOD_NAME}:1.4"
MODULES_ORDER="$MODULES_ORDER 2.1:${MOD_NAME}"

setup_internet () {
    run_internet
}

run_internet () {
    WIFI=/sys/class/net/w*
    ETHER=/sys/class/net/e*

    OLD_NETWORK_INFO_FILE=/tmp/statusbar/oldnetworkinfofile
    mkdir -p /tmp/statusbar > /dev/null 2>&1

    CUR_NETWORK_DATA=$(cat /proc/net/dev)
    OLD_NETWORK_DATA=$CUR_NETWORK_DATA
    [ -f $OLD_NETWORK_INFO_FILE ] && OLD_NETWORK_DATA=$(cat $OLD_NETWORK_INFO_FILE)
    printf "$CUR_NETWORK_DATA\n" > $OLD_NETWORK_INFO_FILE

    INTERNET_TYPE=
    INTERNET_INFO=

    # Ethernet
    if [ -f ${ETHER}/operstate -a "$(cat ${ETHER}/operstate 2> /dev/null)" = "up" ]
    then
        #RX_TX=$(awk '/enp/ {i++; rx[i]=$2; tx[i]=$10}; END{print rx[2]-rx[1] " " tx[2]-tx[1]}' \
        #    <(printf "$OLD_NETWORK_DATA\n"; printf "$CUR_NETWORK_DATA\n"))
        #RX=$(printf "$RX_TX\n" | cut -d' ' -f1)
        #TX=$(printf "$RX_TX\n" | cut -d' ' -f2)
        #RX_Mb=$(printf "scale=2; ($RX / 131072)\n" | bc -l)
        #TX_Mb=$(printf "scale=2; ($TX / 131072)\n" | bc -l)
        #ETH_SPEEDS="↓ $RX_Mb Mb/s ↑ $TX_Mb Mb/s"
        # TODO determine IP address of highest priority connected ethernet

        INTERNET_INFO="\uf6ff"
        INTERNET_TYPE="wired"
    else
        # Wifi
        # TODO(Verify this is true):
        # NOTE: Being up does NOT mean I have an internet connection.
        # Just means the interface is up
        if [ -f ${WIFI}/operstate -a "$(cat ${WIFI}/operstate 2> /dev/null)" = "up" ]
        then
            #QUAL_LINK=$(head -n3 /proc/net/wireless | tail -n1 | tr -s '[:space:]' | cut -d' ' -f3 | tr -d '.')
            #QUAL_PER=$(( QUAL_LINK * 100 / 70 ))

            #RX_TX=$(awk '/wlp/ {i++; rx[i]=$2; tx[i]=$10}; END{print rx[2]-rx[1] " " tx[2]-tx[1]}' \
            #    <(printf "$OLD_NETWORK_DATA\n"; printf "$CUR_NETWORK_DATA\n"))
            #RX=$(printf "$RX_TX\n" | cut -d' ' -f1)
            #TX=$(printf "$RX_TX\n" | cut -d' ' -f2)
            #RX_Mb=$(printf "scale=2; ($RX / 131072)\n" | bc -l)
            #TX_Mb=$(printf "scale=2; ($TX / 131072)\n" | bc -l)
            #WIFI_SPEEDS="${QUAL_PER}%% ↓ $RX_Mb Mb/s ↑ $TX_Mb Mb/s"

            INTERNET_INFO="\uf1eb"
            INTERNET_TYPE="wireless"
        else
            INTERNET_TYPE="offline"
            INTERNET_INFO="\uf059"
        fi
    fi

    INTERNET_CMDS="%{A1:internet_module.sh 1 $INTERNET_TYPE:}%{A2:internet_module.sh 2 $INTERNET_TYPE:}%{A3:internet_module.sh 3 $INTERNET_TYPE:}"
    printf "${MOD_NAME}%s%s%%{A}%%{A}%%{A}\n" "$INTERNET_CMDS" "$INTERNET_INFO"
}
