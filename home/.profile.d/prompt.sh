###############################################################################
# prompt.sh
#
# This controls how my prompt looks and behaves. I tried to give it as much
# customization as I could think of. As I like to change things often.
#
# TODO:
# - Check if local in variables works in ZSH
# - Do more testing in general with ZSH
#
# NOTES:
# - Remember to use local for variables in functions. Or else you will see
#   them outside in your environment.
# - Probably need to do more unsets at the end as well for the same reason.
#
# Dependencies (TODO: May not want keep this up-to-date. May not worth it.)
# - tput
# - test
# - hostname
# - whoami
# - mkdir
# - dirname
# - cat
# - grep
# - sed
# - printf
# - read
# - alias
# - git
# - timeout
# - set
# - basename
# - cut
# - bind
###############################################################################

HOSTNAME_CMD=
command -v hostname > /dev/null 2>&1 && HOSTNAME_CMD="hostname -s"
[ -z "$HOSTNAME_CMD" ] && command -v hostnamectl > /dev/null 2>&1 && HOSTNAME_CMD="hostnamectl hostname"

# Determine if we support color
if command -v tput > /dev/null 2>&1
then
    NUM_COLORS=$(tput colors 2> /dev/null)
    [ $? -eq 0 -a $NUM_COLORS -gt 2 ] && COLOR_PROMPT=yes
    unset NUM_COLORS
else
    case "$TERM" in
        *color*)
            COLOR_PROMPT=yes
            ;;
        *)
            [ "$COLORTERM" = "truecolor" -o "$COLORTERM" = "yes" ] && COLOR_PROMPT=yes
            ;;
    esac
fi

# Make sure we have HOSTNAME and USER set
[ -z "$HOSTNAME" ] && HOSTNAME=$(${HOSTNAME_CMD})
[ -z "$USER" ] && USER=$(whoami)

# Setup cache file (TODO: Change location [used by ZSH as well])
CACHE_FILE=$XDG_CACHE_HOME/bash/prompt_config
[ ! -d $XDG_CACHE_HOME/bash ] && mkdir -p $(dirname $CACHE_FILE) > /dev/null 2>&1
touch $CACHE_FILE

cprompt () {
    # Options available to change for the prompt
    local OPTS_AVAIL="$(cat << EOF
multiline
git_info
path_included
full_path
exit_code
date
user
hostname
ssh_hostname
level_shell
brackets
EOF
)"

    # Create the optstring for getopts to use
    local OPTSTRING=""
    local LINE
    while IFS= read -r LINE; do
        OPTSTRING+="${LINE:0:1}"
    done <<< "$OPTS_AVAIL"

    __cprompt_usage () {
        local HELP_SPACES=4
        printf "Usage: %s [-H%s]\n" "$0" "${OPTSTRING}"
        printf "%*s-H : Display help\n" ${HELP_SPACES} ''

        local opt
        for opt in $(printf "$OPTSTRING\n" | sed 's/\(.\)/\1 /g')
        do
            local OPT_SUFFIX=$(printf "$OPTS_AVAIL" | sed -n "/^${opt}/p" -)
            printf "%*s-%s : Toggle %s\n" ${HELP_SPACES} '' "$opt" "$OPT_SUFFIX"
        done
    }

    __change_value () {
        local opt=__PROMPT__$1
        local state=$2
        if [ -z "$state" ]
        then
            if grep -q "^${opt}=" "$CACHE_FILE"
            then
                printf "Changing $1 to 0\n"
                sed -i "/^${opt}=.*/d" "$CACHE_FILE"
            else
                printf "Changing $1 to 1\n"
                echo "${opt}=1" >> "$CACHE_FILE"
            fi
        elif [ ${state:-0} -eq 1 ]
        then
            if grep -q "^${opt}=" "$CACHE_FILE"
            then
                sed -i "s/^${opt}=.*/${opt}=1/" "$CACHE_FILE"
            else
                echo "${opt}=1" >> "$CACHE_FILE"
            fi
        else
            sed -i "/^${opt}=.*/d" "$CACHE_FILE"
        fi
    }

    # Loop through the arguments
    local CHANGED_ONE=0
    local opt
    OPTIND=1
    while getopts "H$OPTSTRING" opt; do
        case $opt in
            H)
                __cprompt_usage
                return 0
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                __cprompt_usage
                return 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                __cprompt_usage
                return 1
                ;;
            *)
                local OPT_SUFFIX=$(printf "$OPTS_AVAIL" | sed -n "/^${opt}/p" -)
                __change_value $OPT_SUFFIX
                CHANGED_ONE=1
                ;;
        esac
    done

    # If we are just toggling values ourselves, don't do the interactive version
    [ $CHANGED_ONE -eq 1 ] && return

    # Start off with each options state being 0.
    for opt in $(printf "$OPTS_AVAIL"); do eval "local ${opt}_state=0"; done

    printf "How do you want your prompt to look?\n"
    printf "%s\n" "$OPTS_AVAIL" | sed 's/^\(.\)/[\1]/'

    read OPTIONS

    # Change the state of each option given to 1.
    for opt in $(printf "$OPTIONS\n" | sed 's/\(.\)/\1 /g')
    do
        local OPT_SUFFIX=$(printf "$OPTS_AVAIL" | sed -n "/^${opt}/p" -)
        eval "local ${OPT_SUFFIX}_state=1"
    done

    # Change the values of all the options
    for opt in $(printf "$OPTS_AVAIL")
    do
        local STATENAME=${opt}_state
        printf "${opt}=${!STATENAME}\n"
        __change_value ${opt} ${!STATENAME}
    done

    # Get rid of any functions or variables we don't want out in the wild
    unset __change_value
    unset __cprompt_usage
}

# For Bash:
# Color codes are \033[<code>m
# The brackets (\[ and \]) are for using color codes in a prompt.
# They tell bash that they are non-printing characters. They make
# the prompt not do weird things.
#
# ZSH does not use color codes. Instead it has its own syntax
if [ "$COLOR_PROMPT" = "yes" ]
then
    [ ! -z "$BASH" ] && BASH_BEG_NON_PRINT="\[" && BASH_END_NON_PRINT="\]"
    [ -z "$BASH" ] && BASH_BEG_NON_PRINT= && BASH_END_NON_PRINT=

    # TODO: Research if the ZSH versions can be different
    [ -z "$ZSH_VERSION" ] && FULL_RESET="$BASH_BEG_NON_PRINT\033[0m$BASH_END_NON_PRINT" || FULL_RESET="%f"
    [ -z "$ZSH_VERSION" ] && FG_RESET="$BASH_BEG_NON_PRINT\033[39m$BASH_END_NON_PRINT" || FG_RESET="%f"

    [ -z "$ZSH_VERSION" ] && PURPLE="$BASH_BEG_NON_PRINT\033[35m$BASH_END_NON_PRINT" || PURPLE="%F{#D699B6}"
    [ -z "$ZSH_VERSION" ] && GREEN="$BASH_BEG_NON_PRINT\033[32m$BASH_END_NON_PRINT" || GREEN="%F{green}"
    [ -z "$ZSH_VERSION" ] && RED="$BASH_BEG_NON_PRINT\033[31m$BASH_END_NON_PRINT" || RED="%F{red}"
    [ -z "$ZSH_VERSION" ] && YELLOW="$BASH_BEG_NON_PRINT\033[33m$BASH_END_NON_PRINT" || YELLOW="%F{yellow}"
    [ -z "$ZSH_VERSION" ] && CYAN="$BASH_BEG_NON_PRINT\033[36m$BASH_END_NON_PRINT" || CYAN="%F{cyan}"

    # TODO: Research if there are background color commands for ZSH
    GREEN_BG="$BASH_BEG_NON_PRINT\033[0;42;30m$BASH_END_NON_PRINT"
    FULL_BG="$BASH_BEG_NON_PRINT\033[48;5;11m$BASH_END_NON_PRINT"
fi
unset COLOR_PROMPT

dir_is_git_repo () {
    git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

[ ! -z "$BASH" ] && FULL_PATH_COMMAND='\w'
[ ! -z "$ZSH_VERSION" ] && FULL_PATH_COMMAND='%0~'

[ ! -z "$BASH" ] && BASENAME_COMMAND='\W'
[ ! -z "$ZSH_VERSION" ] && BASENAME_COMMAND='%1~'

[ ! -z "$BASH" ] && USER_COMMAND="\u"
[ ! -z "$ZSH_VERSION" ] && USER_COMMAND="%n"

[ ! -z "$BASH" ] && TIME_COMMAND="\t"
[ ! -z "$ZSH_VERSION" ] && TIME_COMMAND="%D{%T}"

[ ! -z "$BASH" ] && HOSTNAME_COMMAND="\h"
[ ! -z "$ZSH_VERSION" ] && HOSTNAME_COMMAND="%m"

# TODO(Grant): git rev-parse --verify --quiet refs/stash >/dev/null
prompt () {
    # This has to be first. I need to get the exit code of the last command ran
    local PROMPT_EXIT_CODE="$?"
    local EXIT_COLOR=$GREEN

    if [ $PROMPT_EXIT_CODE != 0 ]
    then
        EXIT_COLOR=$RED
    fi

    . $CACHE_FILE
    . ~/.profile.d/ud.sh

    __add_to_prompt () {
        __TRUE_PROMPT__+="${OPENING_BRACKET}${1}${CLOSING_BRACKET}"
    }

    __create_prompt () {
        local __TRUE_PROMPT__=" "

        # Brackets
        local OPENING_BRACKET=
        local CLOSING_BRACKET=" "
        local MULTILINE_BEG=" "
        local MULTILINE_END=" ${EXIT_COLOR}\$${FULL_RESET} "
        if [ "$__PROMPT__brackets" = "1" ]
        then
            OPENING_BRACKET="["
            CLOSING_BRACKET="]─"
            local EXTRA_SPACE="$([ -z "$(bind -v | tr '[:upper:]' '[:lower:]' | \
                grep "show-mode-in-prompt on")" ] && printf " ")"

            if [ -n "$BASH_VERSION" -a -z "$EXTRA_SPACE" ]
            then
                local MAJ_VERSION=$(echo $BASH_VERSION | cut -d'.' -f1)
                local MIN_VERSION=$(echo $BASH_VERSION | cut -d'.' -f2)
                [ $MAJ_VERSION -ge 4 -a $MIN_VERSION -ge 3 ] && \
                    EXTRA_SPACE="" || EXTRA_SPACE=" "
            fi

            MULTILINE_BEG="${GREEN} ┌─${FG_RESET}"
            MULTILINE_END="${GREEN}${EXTRA_SPACE}└─${FG_RESET}${EXIT_COLOR}■${FULL_RESET} "
        fi

        # Beginning multiline check
        if [ "$__PROMPT__multiline" = "1" ]
        then
            __TRUE_PROMPT__="$MULTILINE_BEG"
        fi

        # Shell Level
        if [ "$__PROMPT__level_shell" = "1" ]
        then
            [ -n "$SHLVL" ] && __add_to_prompt "${GREEN}${SHLVL}${FULL_RESET}"
        fi

        # Date
        if [ "$__PROMPT__date" = "1" ]
        then
            #[ "$R_ALIGNED" = "yes" ] && local DATE_INFO= || local DATE_INFO="[$GREEN$TIME_COMMAND$FULL_RESET]─"
            __add_to_prompt "${GREEN}${TIME_COMMAND}${FULL_RESET}"
        fi

        # User
        if [ "$__PROMPT__user" = "1" ]
        then
            __TRUE_PROMPT__+="${OPENING_BRACKET}${YELLOW}${USER_COMMAND}${FULL_RESET}"
            [ "$__PROMPT__hostname" = "1" ] && \
                __TRUE_PROMPT__+="@" || \
                __TRUE_PROMPT__+="${CLOSING_BRACKET}"
        fi

        # Hostname
        if [ "$__PROMPT__hostname" = "1" ]
        then
            [ "$__PROMPT__user" != "1" ] && \
                __TRUE_PROMPT__+="${OPENING_BRACKET}"
            __TRUE_PROMPT__+="${PURPLE}${HOSTNAME_COMMAND}${FULL_RESET}${CLOSING_BRACKET}"
        elif [ "$__PROMPT__ssh_hostname" = "1" ]
        then
            [ -n "$SSH_CONNECTION" ] && __add_to_prompt "${PURPLE}${HOSTNAME_COMMAND}${FULL_RESET}"
        fi

        # CWD
        if [ "$__PROMPT__path_included" = "1" ]
        then
            local PATH_COMMAND="${BASENAME_COMMAND}"
            if [ "$__PROMPT__full_path" = "1" ]
            then
                PATH_COMMAND="${FULL_PATH_COMMAND}"
            fi
            __add_to_prompt "${CYAN}${PATH_COMMAND}${FULL_RESET}"
        fi

        # Exit code
        if [ "$__PROMPT__exit_code" = "1" ]
        then
            [ $PROMPT_EXIT_CODE -ne 0 ] && __add_to_prompt "${RED}${PROMPT_EXIT_CODE}${FULL_RESET}"
        fi

        # Before dealing with potential git information, let's replace
        # the last character with a space. It could be a space or it could
        # be part of the brackets option.
        __TRUE_PROMPT__="${__TRUE_PROMPT__%?} "

        # Git
        if [ "$__PROMPT__git_info" = "1" ]
        then
            if dir_is_git_repo
            then
                __TRUE_PROMPT__+="(${GREEN}$( \
                    timeout 2 git rev-parse --abbrev-ref HEAD)${FG_RESET}) "
                [ -n "$(timeout 2 git status -uno --short 2> /dev/null)" ] && \
                    __TRUE_PROMPT__+="${RED}*${FG_RESET} "
            fi
        fi

        # End multiline check
        if [ "$__PROMPT__multiline" = "1" ]
        then
            PS1="$(printf "%s\n%s" "$__TRUE_PROMPT__" "$MULTILINE_END")"
        else
            PS1="$__TRUE_PROMPT__$EXIT_COLOR\$$FULL_RESET "
        fi
    }

    __create_prompt

    unset $(cat $CACHE_FILE | cut -d'=' -f1)
    unset __create_prompt
    unset __add_to_prompt

    PS1="${EXTRA_PREV_PS1}${PS1}"
}

# Setup the prompt based on the shell we are using
[ -z "$BASH" -a -z "$ZSH_VERSION" ] && \
    PS1="$(printf "$PURPLE$USER$FULL_RESET@$YELLOW$HOSTNAME$FULL_RESET $ ")"
[ ! -z "$BASH" ] && PROMPT_COMMAND="${PROMPT_COMMAND}$([ -n "$PROMPT_COMMAND" -a "${PROMPT_COMMAND: -1:1}" != ";" ] && printf ";")prompt;"
[ ! -z "$ZSH_VERSION" ] && precmd () { prompt; }

unset NUM_COLORS
unset COLOR_PROMPT
unset HOSTNAME_CMD

# Return true
true
