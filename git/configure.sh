#!/bin/bash
CONFIG_FILE=/home/$USER/.config/git/configuration

echo "******** GIT CONFIGURATION ********"
echo "'user' configuration"

read -p "Please enter 'email' value: " EMAIL
read -p "Please enter 'name' value: " NAME

echo "Writing 'user' configuration to 'configuration'"
echo "EMAIL -- $EMAIL"
echo "NAME -- $NAME"

cat > $CONFIG_FILE <<- EOF
EMAIL = $EMAIL
NAME = $NAME
EOF
