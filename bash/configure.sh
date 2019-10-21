#!/bin/sh
ROOT=$(pwd)
BASH_CONFIG_FILE=${ROOT}/.bashrc.default
INPUT_CONFIG_FILE=${ROOT}/.inputrc.default
BASH_PROFILE_FILE=${ROOT}/.profile.default

touch $BASH_PROFILE_FILE

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

read -p "Do you want to include the bash aliases file (y|n)? " ALIASES

if [ "$ALIASES" = "y" ] || [ "$ALIASES" = "Y" ]
then
    cat >> $BASH_CONFIG_FILE <<- EOF

if [ -f $ROOT/.bash_aliases ]
then
    . $ROOT/.bash_aliases
fi
EOF
fi

read -p "Do you want to include the bash prompt file (y|n)? " PROMPT

if [ "$PROMPT" = "y" ] || [ "$PROMPT" = "Y" ]
then
    cat >> $BASH_CONFIG_FILE <<- EOF

if [ -f $ROOT/.bash_prompt ]
then
    . $ROOT/.bash_prompt
fi
EOF
fi

read -p "Do you want to include the game boy development env file (y|n)? " GB_DEV

if [ "$GB_DEV" = "y" ] || [ "$GB_DEV" = "Y" ]
then
    cat $ROOT/.bash_gb_dev > $BASH_PROFILE_FILE
fi
