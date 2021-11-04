#!/bin/sh
CACHE_DIR=$HOME/.cache/config_config/git
CONFIG_FILE=$CACHE_DIR/config_extra

mkdir -p $CACHE_DIR > /dev/null 2>&1

printf "******** GIT CONFIGURATION ********\n"
printf "'user' configuration\n"

read -p "Please enter 'email' value: " EMAIL
read -p "Please enter 'name' value: " NAME

printf "Writing 'user' configuration to 'configuration'\n"
printf "EMAIL -- $EMAIL\n"
printf "NAME -- $NAME\n"

cat > $CONFIG_FILE << EOF

[user]
	email = $EMAIL
	name = $NAME
EOF
