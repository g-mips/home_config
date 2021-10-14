# If not running interactively, don't do anything
# Included in this file as well just in case
case $- in
    *i*) ;;
      *) return;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Turn off CTRL-S and CTRL-Q. They are annoying and unneeded (in most cases).
stty -ixon

shopt -s histappend   # append to the history file, don't overwrite it.
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s globstar     # The pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.
shopt -s autocd       # Typing in the just a directory will run cd on that directory.
shopt -s sourcepath   # Uses PATH to find the file that is being sourced.

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Are we in a WSL environment?
if [ ! -z "$WSLENV" ]
then
    if [ $(grep -oE 'gcc version ([0-9]+)' /proc/version | awk '{print $3}') -gt 5 ]
    then
        export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
        export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}');
    else
        export DISPLAY=:0
    fi

    xrdb ~/.Xresources
fi

mkdir -p $XDG_CACHE_HOME/tmux &> /dev/null
[ -z "$TMUX" ] && echo $DISPLAY > $XDG_CACHE_HOME/tmux/display_var
[ ! -z "$TMUX" ] && export DISPLAY=$(cat $XDG_CACHE_HOME/tmux/display_var)
