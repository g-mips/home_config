#
# POSIX profile setup
#

# Add in local bins
# Default PATH
#PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games
export PATH=${HOME}/.local/sbin:${HOME}/.local/bin:${HOME}/.local/games:${PATH}

# Setup Editors
export EDITOR='/usr/bin/vim'
export VISUAL='/usr/bin/vim'
export ALTERNATE_EDITOR='/usr/bin/vi'

# Setup browser
export BROWSER='/usr/bin/librewolf:/usr/bin/firefox'

# Setup pager
export PAGER='/usr/bin/less'

# Setup terminal
export TERMINAL="/usr/bin/alacritty"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Where the SSH environment is found
export SSH_ENV="$HOME/.ssh/environment"

# Setup default prompt (Changes if using prompt.sh file)
export PS1="\$ "

# XDG Base Directory
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# ~/ Cleanup
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export LESSHISTFILE="-"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc.conf"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export XCURSOR_PATH="$XDG_DATA_HOME/icons"
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite/sqlite_history"
export WINEPREFIX="$XDG_CONFIG_HOME/wine/default"
export CARGO_HOME="$XDG_CONFIG_HOME/cargo"
export RUSTUP_HOME="$XDG_CONFIG_HOME/rustup"
export GRADLE_USER_HOME="$XDG_CONFIG_HOME/gradle"
export GOPATH="$XDG_DATA_HOME/go"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

if [ ! -z "$WSLENV" ]
then
    if [ $(grep -oE 'gcc version ([0-9]+)' /proc/version | awk '{print $3}') -gt 5 ]
    then
        export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
        export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}');
    else
        export DISPLAY=:0
    fi

    xrdb ~/.config/xwindowsystem/.Xresources
fi

# Turn off CTRL-S and CTRL-Q. They are annoying and unneeded (in most cases).
stty -ixon

# Source in the extra files
. ssh_agent.sh
