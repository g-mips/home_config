#!/bin/sh
ROOT=$(pwd)
CONFIG_FILE=${ROOT}/configuration

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
