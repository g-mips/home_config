# Dependencies
# tput
# test
# hostname
# whoami
# mkdir
# dirname
# cat
# grep
# sed
# printf
# read
# alias
# git
# timeout
# set
# basename
# cut
# bind

# Determine if we support color
NUM_COLORS=$(tput colors 2> /dev/null)
[ $? -eq 0 -a $NUM_COLORS -gt 2 ] && COLOR_PROMPT=yes

# Make sure we have HOSTNAME and USER set
[ -z "$HOSTNAME" ] && HOSTNAME=$(hostname -s)
[ -z "$USER" ] && USER=$(whoami)

# Setup cache file (TODO: Change location [used by ZSH as well])
CACHE_FILE=$XDG_CACHE_HOME/bash/prompt_config
[ ! -d $XDG_CACHE_HOME/bash ] && mkdir -p $(dirname $CACHE_FILE) > /dev/null 2>&1
[ ! -f $CACHE_FILE ] && cat >> $CACHE_FILE << EOF
SHOW_GIT_INFO="no"
ML_PROMPT="no"
R_ALIGNED="no"
EXIT_CODE_SETTING="no"
SIMPLE_PROMPT="no"
SHOW_FULL_PATH="no"
EOF
. $CACHE_FILE

# Variables to set to activate different prompts:
# SHOW_GIT_INFO="yes"      -- show git information on prompt
# ML_PROMPT="yes"          -- multiline prompt
# R_ALIGNED="yes"          -- have right aligned information as well
# EXIT_CODE_SETTING="yes"  -- have the last exit code in the prompt
# SIMPLE_PROMPT="path|yes" -- display prompt in a simple matter
# SHOW_FULL_PATH="yes"     -- display full path in prompt

toggle_git_info () {
    OLD_SHOW_GIT_INFO=$SHOW_GIT_INFO
    [ "$SHOW_GIT_INFO" = "yes" ] && SHOW_GIT_INFO="no" || \
        SHOW_GIT_INFO="yes"
    (grep SHOW_GIT_INFO $CACHE_FILE > /dev/null 2>&1 &&
        sed -i "s/SHOW_GIT_INFO=\"$OLD_SHOW_GIT_INFO\"/SHOW_GIT_INFO=\"$SHOW_GIT_INFO\"/" \
        $CACHE_FILE) || \
        printf "SHOW_GIT_INFO=\"$SHOW_GIT_INFO\"" >> $CACHE_FILE
}
alias cp-tgi=toggle_git_info

toggle_multiline_prompt () {
    OLD_ML_PROMPT=$ML_PROMPT
    [ "$ML_PROMPT" = "yes" ] && ML_PROMPT="no" || \
        ML_PROMPT="yes"
    (grep ML_PROMPT $CACHE_FILE > /dev/null 2>&1 &&
        sed -i "s/ML_PROMPT=\"$OLD_ML_PROMPT\"/ML_PROMPT=\"$ML_PROMPT\"/" \
        $CACHE_FILE) || \
        printf "ML_PROMPT=\"$ML_PROMPT\"" >> $CACHE_FILE
}
alias cp-tmp=toggle_multiline_prompt

toggle_right_aligned () {
    OLD_R_ALIGNED=$R_ALIGNED
    [ "$R_ALIGNED" = "yes" ] && R_ALIGNED="no" || \
        R_ALIGNED="yes"
    (grep R_ALIGNED $CACHE_FILE > /dev/null 2>&1 &&
        sed -i "s/R_ALIGNED=\"$OLD_R_ALIGNED\"/R_ALIGNED=\"$R_ALIGNED\"/" \
        $CACHE_FILE) || \
        printf "R_ALIGNED=\"$R_ALIGNED\"" >> $CACHE_FILE

    [ -z "$ZSH_VERSION" ] && [ "$R_ALIGNED" = "yes" ] && [ "$SIMPLE_PROMPT" != "no" -o "$ML_PROMPT" != "yes" ] && \
        printf "WARNING: Using right aligned with a single line prompt gives some odd behavior. " && \
        printf "If you start to write into the the right side, it will be overwritten. If you " && \
        printf "backspace, the right side will disappear. The mode can't be properly shown in " && \
        printf "the prompt.\n"

    # Make sure the function exists with a zero
    true
}
alias cp-tra=toggle_right_aligned

toggle_exit_code () {
    OLD_EXIT_CODE_SETTING=$EXIT_CODE_SETTING
    [ "$EXIT_CODE_SETTING" = "yes" ] && EXIT_CODE_SETTING="no" || \
        EXIT_CODE_SETTING="yes"
    (grep EXIT_CODE_SETTING $CACHE_FILE > /dev/null 2>&1 && \
        sed -i "s/EXIT_CODE_SETTING=\"$OLD_EXIT_CODE_SETTING\"/EXIT_CODE_SETTING=\"$EXIT_CODE_SETTING\"/" \
        $CACHE_FILE) || \
        printf "EXIT_CODE_SETTING=\"$EXIT_CODE_SETTING\"" >> $CACHE_FILE
}
alias cp-tec=toggle_exit_code

toggle_simple_prompt () {
    OLD_SIMPLE_PROMPT=$SIMPLE_PROMPT
    if [ "$SIMPLE_PROMPT" = "yes" ]
    then
        SIMPLE_PROMPT="path"
    elif [ "$SIMPLE_PROMPT" = "path" ]
    then
        SIMPLE_PROMPT="no"
    else
        SIMPLE_PROMPT="yes"
    fi
    (grep SIMPLE_PROMPT $CACHE_FILE > /dev/null 2>&1 && \
        sed -i "s/SIMPLE_PROMPT=\"$OLD_SIMPLE_PROMPT\"/SIMPLE_PROMPT=\"$SIMPLE_PROMPT\"/" \
        $CACHE_FILE) || \
        printf "SIMPLE_PROMPT=\"$SIMPLE_PROMPT\"" >> $CACHE_FILE
}
alias cp-tsp=toggle_simple_prompt

toggle_full_path () {
    OLD_SHOW_FULL_PATH=$SHOW_FULL_PATH
    [ "$SHOW_FULL_PATH" = "yes" ] && SHOW_FULL_PATH="no" || \
        SHOW_FULL_PATH="yes"
    (grep SHOW_FULL_PATH $CACHE_FILE > /dev/null 2>&1 && \
        sed -i "s/SHOW_FULL_PATH=\"$OLD_SHOW_FULL_PATH\"/SHOW_FULL_PATH=\"$SHOW_FULL_PATH\"/" \
        $CACHE_FILE) || \
        printf "SHOW_FULL_PATH=\"$SHOW_FULL_PATH\"" >> $CACHE_FILE
}
alias cp-tfp=toggle_full_path

customize_prompt () {
    printf "Which part do you want to customize:"
    printf "\n\t1) git info\n\t2) multiline\n\t3) right aligned\n\t4) exit code string"
    printf "\n\t5) simple prompt\n\t6) toggle_full_path\n"
    read option

    case "$option" in
        1)
            toggle_git_info
            ;;
        2)
            toggle_multiline_prompt
            ;;
        3)
            toggle_right_aligned
            ;;
        4)
            toggle_exit_code
            ;;
        5)
            toggle_simple_prompt
            ;;
        6)
            toggle_full_path
            ;;
        *)
            printf "Not a valid option"
            return 1
            ;;
    esac
}
alias cp-i=customize_prompt

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

dir_is_git_repo () {
    git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

get_length_of_non_color_parts () {
    LEN=$#
    : $((STR_LEN=0))
    : $((i=0))
    while [ "$((i != LEN))" -ne 0 ]
    do
        [ "$((i % 2))" = "0" ] && LEN_TO_ADD=${#1} && \
            : $((STR_LEN = STR_LEN + LEN_TO_ADD))
        : $((i = i + 1))
        shift
    done
    printf $STR_LEN
}

# Bash only function
if [ ! -z "$BASH" ]
then
    calculate_compensation () {
        # assumes RPROMPT and PS1R_COMPENSATION both exist
        PS1R_LEN=${#RPROMPT}
        : $((i=0))
        while [ "$((i != PS1R_LEN))" -ne 0 ]
        do
            [ "${RPROMPT:$i:1}" = "\\" ] && START_COUNT=1

            # Add in the time (8 characters for the time, - 6 because
            # 2 characters represent the time (\t)
            [ $START_COUNT -eq 1 ] && [ "${RPROMPT:$(($i+1)):1}" = "t" ] && \
                PS1R_COMPENSATION=$(( $PS1R_COMPENSATION - 6 )) && \
                i=$(( $i + 1 )) && START_COUNT=0

            # Add color codes
            [ $START_COUNT -eq 1 ] && \
                PS1R_COMPENSATION=$(( $PS1R_COMPENSATION + 1 )) && \
                [ "${RPROMPT:$i:1}" = "]" ] && START_COUNT=0
            : $((i=i+1))
        done
    }
fi

setup_git_info () {
    if [ "$SHOW_GIT_INFO" = "yes" ]
    then
        local GIT_STATUS=
        local IS_GIT_REPO=$(dir_is_git_repo; printf $?)
        [ $IS_GIT_REPO -eq 0 ] && [ -n "$(timeout 2 git status -uno --short 2> /dev/null)" ] && \
            GIT_STATUS="*"
        [ $IS_GIT_REPO -eq 0 ] && set -- " (" "$GREEN" \
            "$(timeout 2 git branch | grep "\*" | rev | cut -d' ' -f1 | rev | \
            cut -d')' -f1)" "$FG_RESET" ")" "$RED" " $GIT_STATUS" "$FG_RESET"
        GIT_INFO_LEN=$(get_length_of_non_color_parts "$@")
        printf "%s%s%s" "$GIT_INFO_LEN" "-" "$@"
    fi
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

multiline_prompt () {
    # ------ The different parts of PS1 ------

    # Setup shell level
    [ ! -z "$SHLVL" ] && set -- " (" "$GREEN" "$SHLVL" "$FG_RESET" ") " || \
        set -- "  "

    # Save shell level length for later
    SHLVL_INFO_LEN=$(get_length_of_non_color_parts "$@")

    # Setup left side of first line of prompt and
    # potential right side of first line
    set -- "$@" "$GREEN" " ┌─" "$FG_RESET" "[" "$PURPLE" "$USER" "$FG_RESET" \
        "@" "$YELLOW" "$HOSTNAME" "$FG_RESET" "]" "$FG_RESET" "[" "$CYAN" \
        "$([ "$SHOW_FULL_PATH" = "yes" ] && \
        printf $(printf $PWD | sed -e "s|$HOME|~|") || \
        printf $(basename $PWD))" "$FG_RESET" "]"
    RPROMPT="${FG_RESET}[$GREEN$TIME_COMMAND$FULL_RESET]"
    [ "$R_ALIGNED" != "yes" ] && set -- "$@" "$GREEN" "─" "$RPROMPT" && RPROMPT=
    [ "$EXIT_CODE_SETTING" = "yes" ] && set -- "$@" "$FG_RESET" "[$PROMPT_EXIT_CODE]" "$FG_RESET"

    # Get the length of the left side of PS1 except for the GIT_INFO_LEN
    local PS1L_LEN=$COLUMNS
    if [ "$R_ALIGNED" = "yes" ]
    then
        PS1L_LEN=$(get_length_of_non_color_parts "$@")
    fi

    # Now setup the potential git info and add in the length
    local FULL_GIT_INFO=$(setup_git_info)
    local GIT_INFO_LEN=$(printf "%s" "$FULL_GIT_INFO" | cut -d'-' -f1)
    local GIT_INFO=$(printf "%s" "$FULL_GIT_INFO" | cut -d'-' -f2-)
    set -- "$@" "$GIT_INFO"
    local PS1L="$(printf "%s" "$@")"
    : $((PS1L_LEN=PS1L_LEN + GIT_INFO_LEN))

    # Setup the second line
    [ ! -z "$BASH" ] && local PS1_PRMPT="" || local PS1_PRMPT=" "
    : $((i=0))
    while [ "$((i != SHLVL_INFO_LEN))" -ne 0 ]
    do
        PS1_PRMPT=" "$PS1_PRMPT
        : $((i = i + 1))
    done
    PS1_PRMPT=$PS1_PRMPT"$GREEN└─$FG_RESET$EXIT_COLOR■$FULL_RESET "

    # Put it all together for non Bash prompt
    PS1="$(printf "%s\n%s" "$PS1L" "$PS1_PRMPT")"
    if [ ! -z "$BASH" ]
    then
        # Add in the amount to account for escaped sequences
        local START_COUNT=0
        local PS1R_COMPENSATION=0
        [ "$R_ALIGNED" = "yes" ] && calculate_compensation

        bind "set show-mode-in-prompt On"

        # Put it all together now for Bash prompt
        PS1="`printf "%s%$((${COLUMNS}-${PS1L_LEN}+${PS1R_COMPENSATION}))s\n%s" "$PS1L" "$RPROMPT" "$PS1_PRMPT"`"
    fi
}

singleline_prompt () {
    [ -z "$SHLVL" ] && local SINGLE_SHLVL_INFO= || local SINGLE_SHLVL_INFO="[$GREEN$SHLVL$FULL_RESET]─"
    [ "$R_ALIGNED" = "yes" ] && local DATE_INFO= || local DATE_INFO="[$GREEN$TIME_COMMAND$FULL_RESET]─"

    local GIT_INFO=
    local GIT_STATUS=

    local FULL_GIT_INFO=$(setup_git_info)
    local GIT_INFO_LEN=$(printf "%s" "$FULL_GIT_INFO" | cut -d'-' -f1)
    local GIT_INFO=$(printf "%s" "$FULL_GIT_INFO" | cut -d'-' -f2-)

    # Setup PS1
    [ "$EXIT_CODE_SETTING" = "yes" ] && \
        PROMPT_EXIT_CODE_STR=-[$PROMPT_EXIT_CODE] || PROMPT_EXIT_CODE_STR=
    PS1=" $SINGLE_SHLVL_INFO${DATE_INFO}[$PURPLE$USER_COMMAND$FULL_RESET@$YELLOW$HOSTNAME_COMMAND$FULL_RESET]─[$CYAN$(\
        [ "$SHOW_FULL_PATH" = "yes" ] && \
        printf "%s" "$FULL_PATH_COMMAND" || \
        printf "%s" "$BASENAME_COMMAND")$FULL_RESET]$PROMPT_EXIT_CODE_STR$GREEN-$EXIT_COLOR■$FULL_RESET$GIT_INFO "

    if [ "$R_ALIGNED" = "yes" ]
    then
        # ZSH just needs RPROMPT set
        RPROMPT="[$PURPLE$TIME_COMMAND$FULL_RESET]"
        if [ ! -z "$BASH" ]
        then
            local PS1R_COMPENSATION=0
            local START_COUNT=0

            calculate_compensation

            bind "set show-mode-in-prompt Off"

            # Bash will need PS1 set to include the right aligned portion
            PS1="$(printf "%$((${COLUMNS}+${PS1R_COMPENSATION}))s\r%s" "$RPROMPT" " $PS1")"
        fi
    else
        RPROMPT=
        [ ! -z "$BASH" ] && bind "set show-mode-in-prompt On"
    fi
}

simple_prompt () {
    # Setup the PS1 var
    [ "$SIMPLE_PROMPT" = "yes" ] && PS1=" $EXIT_COLOR\$$FULL_RESET "
    [ "$SIMPLE_PROMPT" = "path" ] && PS1=" $CYAN$([ "$SHOW_FULL_PATH" = "yes" ] && \
        printf "%s" "$FULL_PATH_COMMAND" || printf "%s" "$BASENAME_COMMAND")$FULL_RESET $EXIT_COLOR\$$FULL_RESET "

    if [ "$R_ALIGNED" = "yes" ]
    then
        # For ZSH
        RPROMPT="[$PURPLE$TIME_COMMAND$FULL_RESET]"
        if [ ! -z "$BASH" ]
        then
            local PS1R_COMPENSATION=0
            local START_COUNT=0

            calculate_compensation

            bind "set show-mode-in-prompt Off"

            # Bash needs to include the RPROMPT in PS1
            PS1="$(printf "%$((${COLUMNS}+${PS1R_COMPENSATION}))s\r%s" "$RPROMPT" " $PS1")"
        fi
    else
        RPROMPT=
        [ ! -z "$BASH" ] && bind "set show-mode-in-prompt On"
    fi
}

# TODO(Grant): git rev-parse --verify --quiet refs/stash >/dev/null
prompt () {
    # This has to be first. I need to get the exit code of the last command ran
    PROMPT_EXIT_CODE="$?"
    local EXIT_COLOR=$GREEN

    if [ $PROMPT_EXIT_CODE != 0 ]
    then
        EXIT_COLOR=$RED
    fi

    # Simple prompt takes priority over all
    if [ "$SIMPLE_PROMPT" != "no" ]
    then
        simple_prompt
    elif [ "$ML_PROMPT" = "yes" ]
    then
        multiline_prompt
    else
        singleline_prompt
    fi
}

# Setup the prompt based on the shell we are using
[ -z "$BASH" -a -z "$ZSH_VERSION" ] && \
    PS1="$(printf "$PURPLE$USER$FULL_RESET@$YELLOW$HOSTNAME$FULL_RESET $ ")"
[ ! -z "$BASH" ] && PROMPT_COMMAND='prompt'
[ ! -z "$ZSH_VERSION" ] && precmd () { prompt; }
