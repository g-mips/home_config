#
# POSIX profile setup
#

# Add in local bins
# Default PATH
#PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games
export PATH=${HOME}/bin:${HOME}/.local/bin:${HOME}/.local/games:${PATH}

# Setup Editors
export EDITOR='/usr/bin/vim'
export VISUAL='/usr/bin/gvim'
export ALTERNATE_EDITOR='/usr/bin/vi'

# Setup browser
export BROWSER='/usr/bin/firefox:/usr/bin/qutebrowser'

# Setup pager
export PAGER='/usr/bin/less'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Setup TERM for tmux/screen
export TERM=xterm-256color

# Where the SSH environment is found
export SSH_ENV="$HOME/.ssh/environment"

export TERMINAL="/usr/local/bin/st-custom"
