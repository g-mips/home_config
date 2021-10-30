#!/bin/sh
ROOT=$(pwd)
[ -z "$XDG_CACHE_HOME" ] && CACHE_DIR=$HOME/.cache || CACHE_DIR=$XDG_CACHE_HOME
BASH_CONFIG_FILE=$CACHE_DIR/bash/bashrc.default
INPUT_CONFIG_FILE=$CACHE_DIR/bash/inputrc.default
BASH_PROFILE_FILE=$CACHE_DIR/bash/profile.default

mkdir -p $CACHE_DIR/bash &> /dev/null

echo "******** BASH CONFIGURATION ********"

echo "\$include ${ROOT}/.inputrc" > $INPUT_CONFIG_FILE

cat > $BASH_CONFIG_FILE <<- EOF
# If not running interactively, don't do anything
case \$- in
    *i*) ;;
      *) return;;
esac

if [ -f $ROOT/.bashrc ]
then
    . $ROOT/.bashrc
fi
EOF

cat > $BASH_PROFILE_FILE <<- EOF
if [ -f $ROOT/.profile ]
then
    . $ROOT/.profile
fi
EOF

read -N 1 -p "Do you want to include the bash aliases file (y|n)? " ALIASES

if echo $ALIASES | grep -iqF y
then
    cat >> $BASH_CONFIG_FILE <<- EOF

if [ -f $ROOT/.bash_aliases ]
then
    . $ROOT/.bash_aliases
fi
EOF
fi

read -N 1 -p $'\nDo you want to include the bash prompt file (y|n)? ' PROMPT

if echo $PROMPT | grep -iqF y
then
    cat >> $BASH_CONFIG_FILE <<- EOF

if [ -f $ROOT/.bash_prompt ]
then
    . $ROOT/.bash_prompt
fi
EOF
fi

read -N 1 -p $'\nDo you want to include the game boy development env file (y|n)? ' GB_DEV

if echo $GB_DEV | grep -iqF y
then
    cat >> $BASH_PROFILE_FILE <<- EOF

if [ -f $ROOT/.bash_gb_dev ]
then
    . $ROOT/.bash_gb_dev
fi
EOF
fi

read -N 1 -p $'\nDo you want to include the ssh agent file (y|n)? ' SSH_AGENT_FILE

if echo $SSH_AGENT_FILE | grep -iqF y
then
    cat >> $BASH_CONFIG_FILE <<- EOF

if [ -f $ROOT/.bash_ssh_agent ]
then
    . $ROOT/.bash_ssh_agent
fi
EOF
fi

echo ""
