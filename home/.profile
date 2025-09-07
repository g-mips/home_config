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
export PS1='\$ '

# XDG Base Directory
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
[ -z "${XDG_RUNTIME_DIR}" ] && export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# ~/ Cleanup
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export LESSHISTFILE="-"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc.conf"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PYTHONHISTFILE="$XDG_DATA_HOME/python/history"
export XCURSOR_PATH="$XDG_DATA_HOME/icons"
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite/sqlite_history"
export WINEPREFIX="$XDG_CONFIG_HOME/wine/default"
export CARGO_HOME="$XDG_CONFIG_HOME/cargo"
export RUSTUP_HOME="$XDG_CONFIG_HOME/rustup"
export GRADLE_USER_HOME="$XDG_CONFIG_HOME/gradle"
export GOPATH="$XDG_DATA_HOME/go"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm/npm"
export _SILENT_JAVA_OPTIONS="-Djava.util.prefs.userRoot=\"${XDG_CONFIG_HOME}\"/java"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/config"
export W3M_DIR="$XDG_DATA_HOME/w3m"
export RANDFILE="$XDG_DATA_HOME/openssl/.rnd"
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export ESD_AUTH_FILE="$XDG_CONFIG_HOME/esound/auth"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR/tmux"

# Are we in a WSL environment?
if [ ! -z "$WSLENV" ]
then
    uname -a | grep -q WSL2
    if [ $? -eq 0 ]
    then
        #export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
        export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}');

        # IP addresses for currently running Linux and Windows systems
        LINUX_IP=$(ip addr | awk '/inet / && !/127.0.0.1/ {split($2,a,"/"); print a[1]}')
        WINDOWS_IP=$(ip route | awk '/^default/ {print $3}')

        # IP addresses in current windows defender firewall rule
        # netsh outputs line of "^(Local|Remote)IP:\s+IPADDR/32$" so get second field of
        # 'IPADDR/32' and split it on '/' then just print IPADDR
        FIREWALL_WINDOWS_IP=$(netsh.exe advfirewall firewall show rule name=X11-Forwarding | awk '/^LocalIP/ {split($2,a,"/");print a[1]}')
        FIREWALL_LINUX_IP=$(netsh.exe advfirewall firewall show rule name=X11-Forwarding | awk '/^RemoteIP/ {split($2,a,"/");print a[1]}')

        # Update firewall rule if firewall rules IPs don't match actual ones
        if [ "$FIREWALL_LINUX_IP" != "$LINUX_IP" ] || [ "$WINDOWS_IP" != "$FIREWALL_WINDOWS_IP" ]; then
                powershell.exe -Command "Start-Process netsh.exe -ArgumentList \"advfirewall firewall set rule name=X11-Forwarding new localip=$WINDOWS_IP remoteip=$LINUX_IP \" -Verb RunAs"
        fi

        # Appropriately set DISPLAY to Windows X11 server
        DISPLAY="$WINDOWS_IP:0"

        # Tell X11 programs to render on Windows, not linux, side
        # docs: https://docs.mesa3d.org/envvars.html
        LIBGL_ALWAYS_INDIRECT=1

        export DISPLAY LIBGL_ALWAYS_INDIRECT
    else
        export DISPLAY=:0
    fi

    xrdb ~/.config/xwindowsystem/Xresources
fi
