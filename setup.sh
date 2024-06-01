#!/bin/sh

DBG_PRINT=0
DRY_RUN=""
SKIP_SCRIPTS=0

ANSI_CODE_START="\033["
FOREGROUND_CODE="${ANSI_CODE_START}38;5;"
RED="${FOREGROUND_CODE}196m"
GREEN="${FOREGROUND_CODE}46m"
BLUE="${FOREGROUND_CODE}33m"
RESET="${ANSI_CODE_START}0m"

usage () {
    printf "Usage: $0 [-hnsd]\n"
    printf "  -h -- Run this help menu.\n"
    printf "  -n -- Dry run.\n"
    printf "  -s -- Skip running the scripts directory.\n"
    printf "  -d -- Print out the debug print statements.\n"
}

while getopts "dnsh" o; do
    case "${o}" in
        d)
            DBG_PRINT=1
            ;;
        n)
            DRY_RUN="echo -e \\tWould run: "
            ;;
        s)
            SKIP_SCRIPTS=1
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

CWD=$(pwd)

do_print () {
    [ $DBG_PRINT -eq 1 ] && printf "\t${RED}DEBUG:${RESET} $1"
}

make_hard_link () {
    SOURCE_FILE=$1
    TARGET_FILE=$2

    printf "\tHardlinking ${SOURCE_FILE} to ${TARGET_FILE}\n"
    $DRY_RUN ln ${SOURCE_FILE} ${TARGET_FILE}
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
    HL_FILE="${HOME}/$FILE_TO_CHECK"
    CACHE_FILE="${XDG_CACHE_HOME}/home_config/$FILE_TO_CHECK"
    MAKE_HL=0

    if [ -f "${HL_FILE}" ]
    then
        inode_check ${HL_FILE} ${FILE_TO_CHECK}

        if [ $? -ne 0 ]
        then
            printf "\tINodes for ${HL_FILE} and ${FILE_TO_CHECK} are not the same. Updating...\n"
            do_print "Storing ${HL_FILE} in ${CACHE_FILE}...\n"
            $DRY_RUN mkdir -p $(dirname ${CACHE_FILE})

            # Move the file to get rid of in the config directory.
            $DRY_RUN mv ${HL_FILE} ${CACHE_FILE}.current

            # Copy the file to change its inode
            $DRY_RUN cp ${CACHE_FILE}.current ${CACHE_FILE}

            # Remove the "current" file in cache as it is unneeded.
            $DRY_RUN rm ${CACHE_FILE}.current

            MAKE_HL=1
        fi
    else
        $DRY_RUN mkdir -p $(dirname ${HL_FILE})
        MAKE_HL=1
    fi

    [ $MAKE_HL -eq 1 ] && make_hard_link $FILE_TO_CHECK $HL_FILE || true
}

loop_directory () {
    local BASE_DIR=$1
    local FILES=$(ls -1A $BASE_DIR)

    printf "${BLUE}Configuring:${RESET} ${HOME}/${BASE_DIR}\n"

    for FILE in $FILES
    do
        TARGET="${BASE_DIR}/${FILE}"
        if [ -f "${TARGET}" ]
        then
            do_print "${TARGET} is a file...\n"
            hard_link_check ${TARGET}
        elif [ -d "${TARGET}" ]
        then
            do_print "${TARGET} is a directory. Diving deeper...\n"
            loop_directory ${TARGET}
        else
            printf "\t${TARGET} is a not supported file type...\n"
        fi
    done
}

# Evaluate all the scripts first
[ $SKIP_SCRIPTS -eq 0 ] && \
    { printf "${GREEN}***** Running scripts *****${RESET}\n" && \
      for script in $(find ./scripts -type f -name "*.sh")
      do
          printf "${BLUE}Running:${RESET} ${script}\n"
          $script
      done; printf "\n"; } || true

# Go into the home directory begin the hard link checking
printf "${GREEN}***** Setting up user files *****${RESET}\n" && cd home && loop_directory .; cd ..
