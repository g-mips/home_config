#!/bin/sh

DBG_PRINT=$([ "$1" = "-d" ] && printf "1" || printf "0")

CWD=$(pwd)

do_print () {
    [ $DBG_PRINT -eq 1 ] && printf "$1"
}

make_hard_link () {
    SOURCE_FILE=$1
    TARGET_FILE=$2

    printf "Hardlinking ${SOURCE_FILE} to ${TARGET_FILE}..\n"
    ln ${SOURCE_FILE} ${TARGET_FILE}
}

inode_check () {
    TARGET_FILE=$1
    SOURCE_FILE=$2

    INODE_MATCH=0

    if [ $(ls -id ${TARGET_FILE} | cut -d' ' -f1) -ne $(ls -id ${SOURCE_FILE} | cut -d' ' -f1) ]
    then
        INODE_MATCH=1
    fi

    return $INODE_MATCH
}

hard_link_check () {
    FILE_TO_CHECK=$1
    HL_FILE="${HARD_LINK_DIR}/$FILE_TO_CHECK"
    CACHE_FILE="${XDG_CACHE_HOME}/${CACHE_NAME}/$FILE_TO_CHECK"
    MAKE_HL=0

    if [ -f "${HL_FILE}" ]
    then
        inode_check ${HL_FILE} ${FILE_TO_CHECK}

        if [ $? -ne 0 ]
        then
            printf "INodes for ${HL_FILE} and ${FILE_TO_CHECK} are not the same. Updating...\n"
            printf "Storing ${HL_FILE} in ${CACHE_FILE}...\n"
            mkdir -p $(dirname ${CACHE_FILE})

            # Move the file to get rid of in the config directory.
            mv ${HL_FILE} ${CACHE_FILE}.current

            # Copy the file to change its inode
            cp ${CACHE_FILE}.current ${CACHE_FILE}

            # Remove the "current" file in cache as it is unneeded.
            rm ${CACHE_FILE}.current

            MAKE_HL=1
        fi
    else
        mkdir -p $(dirname ${HL_FILE})
        MAKE_HL=1
    fi

    [ $MAKE_HL -eq 1 ] && make_hard_link $FILE_TO_CHECK $HL_FILE
}

loop_directory () {
    local BASE_DIR=$1
    local IS_REC=$2

    local FILES=$(ls -1A $BASE_DIR)

    for FILE in $FILES
    do
        if [ -f "${BASE_DIR}/${FILE}" ]
        then
            do_print "${BASE_DIR}/${FILE} is a file...\n"

            hard_link_check ${BASE_DIR}/${FILE}
        elif [ -d "${BASE_DIR}/${FILE}" ]
        then
            if [ $IS_REC -eq 1 ]
            then
                do_print "${BASE_DIR}/${FILE} is a directory. Diving deeper...\n"
                loop_directory ${BASE_DIR}/${FILE}
            fi
        else
            printf "${BASE_DIR}/${FILE} is a not supported file type...\n"
        fi
    done
}

for script in $(find ./scripts -type f -name "*.sh")
do
    $script
done

# XDG_CONFIG_HOME
printf "Configuring ${XDG_CONFIG_HOME}\n"
HARD_LINK_DIR=${XDG_CONFIG_HOME}
CACHE_NAME=config
cd config
loop_directory . 1
cd ..

# ~/.local
printf "Configuring ~/.local\n"
HARD_LINK_DIR=~/.local
CACHE_NAME=local
cd local
loop_directory . 1
cd ..

# ~/
printf "Configuring ~/\n"
HARD_LINK_DIR=~/
CACHE_NAME=home
cd home
loop_directory . 0
cd ..
