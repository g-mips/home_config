#
# POSIX profile setup
#

# Safely guarantee an XDG_RUNTIME_DIR exists on ANY Linux environment
if [ -z "$XDG_RUNTIME_DIR" ]; then
    # 1. Check if the OS created the systemd standard path, but just forgot to export it
    if [ -d "/run/user/$(id -u)" ] && [ -w "/run/user/$(id -u)" ]; then
        export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    else
        # 2. If no systemd, build a secure, local fallback in /tmp
        export XDG_RUNTIME_DIR="/tmp/run-user-$(id -u)"
        if [ ! -d "$XDG_RUNTIME_DIR" ]; then
            mkdir -p -m 0700 "$XDG_RUNTIME_DIR"
        fi
    fi
fi

# Add in local bins
# Default PATH
#PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games
export PATH=${HOME}/.local/sbin:${HOME}/.local/bin:${HOME}/.local/games:${PATH}

# Setup Editors
export EDITOR='gvim -v'
export VISUAL='gvim -v'
export ALTERNATE_EDITOR='vim'

# Setup browser
BROWSER="$(command -v zen-browser)"
[ -z "$BROWSER" ] && BROWSER="$(command -v firefox)"
export BROWSER

# Setup pager
export PAGER='/usr/bin/less'

# Setup terminal
export TERMINAL="/usr/bin/alacritty"

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Where the SSH environment is found
export SSH_ENV="$XDG_RUNTIME_DIR/ssh_agent.env"

# Setup default prompt (Changes if using prompt.sh file)
export PS1='\$ '

# XDG Base Directory
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
#[ -z "${XDG_RUNTIME_DIR}" ] && export XDG_RUNTIME_DIR="/run/user/$(id -u)"

TMP_XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

# If the system's $XAUTHORITY file exists and is different from ours...
if [ -f "$XAUTHORITY" ] && [ "$XAUTHORITY" != "$TMP_XAUTHORITY" ]
then
    rm -f $TMP_XAUTHORITY
    ln -sf "$XAUTHORITY" "$TMP_XAUTHORITY"
fi

# ~/ Cleanup
export XAUTHORITY="$TMP_XAUTHORITY"
unset TMP_XAUTHORITY
export LESSHISTFILE="-"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc.conf"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PYTHONHISTFILE="$XDG_DATA_HOME/python/history"
export XCURSOR_PATH="$XDG_DATA_HOME/icons:/usr/share/icons"
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
export PASSWORD_STORE_DIR="$XDG_CONFIG_HOME/password-store"
export QT_QPA_PLATFORMTHEME="qt5ct"

# Load scripts from ~/.profile.d
if test -d ~/.profile.d/; then
    for script in ~/.profile.d/*.sh; do
        test -r "$script" && . "$script"
    done
    unset script
fi
