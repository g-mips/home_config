# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Setup Editors
export ALTERNATE_EDITOR='/usr/bin/emacs'
export EDITOR='/usr/bin/vim'
export VISUAL='/usr/bin/vim'

# Setup browser
export BROWSER='/usr/bin/qutebrowser'

# Setup pager
export PAGER='/usr/bin/less'

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Turn off CTRL-S and CTRL-Q. They are annoying and unneeded.
stty -ixon

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [ -f ~/.config/bash/.bash_aliases ]; then
	. ~/.config/bash/.bash_aliases
fi

if [ -f ~/.config/bash/.bash_prompt ]; then
	. ~/.config/bash/.bash_prompt
fi

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

SSH_ENV="$HOME/.ssh/environment"
function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi

# Enable vim editing
bind -m emacs '"\ee": vi-editing-mode'
bind -m vi '"\ee": emacs-editing-mode'

cgd() {
    cd $(git worktree list | grep "\[$1\]" | cut -d' ' -f1)
}
