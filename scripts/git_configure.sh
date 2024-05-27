#!/bin/sh
set -e

GIT_SENSITIVE_CONF=${XDG_CONFIG_HOME}/git/config_sensitive.conf

mkdir -p $(dirname $GIT_SENSITIVE_CONF) > /dev/null 2>&1
touch $GIT_SENSITIVE_CONF

INCLUDE_USER_VALUES='y'
[ -f "$GIT_SENSITIVE_CONF" ] && read -N 1 -p "Reconfigure git user values? (y|n) " INCLUDE_USER_VALUES \
    || read -N 1 -ep "Include git user values options? (y|n) " INCLUDE_USER_VALUES

printf "\n"

if printf "%s" $INCLUDE_USER_VALUES | grep -iqF y
then
    printf "******** GIT CONFIGURATION ********\n"
    printf "'user' configuration\n"

    read -p "Please enter 'email' value: " EMAIL
    read -p "Please enter 'name' value: " NAME

    printf "Writing 'user' configuration to 'configuration'\n"
    printf "EMAIL -- $EMAIL\n"
    printf "NAME -- $NAME\n"

    cat > $GIT_SENSITIVE_CONF << EOF
[user]
	email = $EMAIL
	name = $NAME
EOF
fi
