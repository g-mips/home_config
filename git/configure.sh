#!/bin/sh
CONFIG_FILE=$HOME/.cache/git/init_config

printf "******** GIT CONFIGURATION ********\n"
printf "'user' configuration\n"

read -p "Please enter 'email' value: " EMAIL
read -p "Please enter 'name' value: " NAME

printf "Writing 'user' configuration to 'configuration'\n"
printf "EMAIL -- $EMAIL\n"
printf "NAME -- $NAME\n"

cat > $CONFIG_FILE << EOF
	email = $EMAIL
	name = $NAME
EOF
