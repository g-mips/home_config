# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || \
        eval "$(dircolors -b)"
        alias lsc='ls --color=always'
        alias ls='ls --color=auto'
        alias dirc='dir --color=always'
        alias dir='dir --color=auto'
        alias vdirc='vdir --color=always'
        alias vdir='vdir --color=auto'

        alias grepc='grep --color=always'
        alias grep='grep --color=auto'
        alias fgrepc='fgrep --color=always'
        alias fgrep='fgrep --color=auto'
        alias egrepc='egrep --color=always'
        alias egrep='egrep --color=auto'

        alias ip='ip -c'
fi

# some more ls aliases
alias ll='ls -lF --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

# Default programs
alias edi=$EDITOR
alias vis=$VISUAL
alias aed=$ALTERNATE_EDITOR
alias bro=${BROWSER##*:}
alias pag=$PAGER

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i \
    "$([ $? = 0 ] && echo terminal || echo error)" \
    "$(history|tail -n1|sed -e \
    '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# tmux developers are terrible and won't implement XDG
# Alias the tmux command to use the conf file found here
alias tmux='tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf'

# newsboat doesn't support including other files. So this is my method.
alias newsboat='newsboat -C <(cat ${XDG_CONFIG_HOME}/newsboat/config ${XDG_CONFIG_HOME}/newsboat/config.d/*)'

alias dosbox='dosbox -conf "${XDG_CONFIG_HOME}/dosbox/dosbox.conf'

# Jump into the default session of the terminal multiplexer
alias sess='tmux -2 attach || tmux -2'

if command -v vim > /dev/null 2>&1
then
    vim --version | grep -q "+xterm_clipboard"
    [ $? -ne 0 ] && which gvim > /dev/null 2>&1 && alias vim='gvim -v' || true
fi

alias vsess='vim -S ~/.cache/vim/session.vim'
