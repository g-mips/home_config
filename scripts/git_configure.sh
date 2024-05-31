#!/bin/sh
set -e

GIT_SENSITIVE_CONF=${XDG_CONFIG_HOME}/git/config_sensitive.conf

mkdir -p $(dirname $GIT_SENSITIVE_CONF) > /dev/null 2>&1
touch $GIT_SENSITIVE_CONF

INCLUDE_USER_VALUES='y'
[ -f "$GIT_SENSITIVE_CONF" ] && read -N 1 -p "$(printf "\t")Reconfigure git user values? (y|n) " INCLUDE_USER_VALUES \
    || read -N 1 -ep "$(printf "\t")Include git user values options? (y|n) " INCLUDE_USER_VALUES

printf "\n"

if printf "%s" $INCLUDE_USER_VALUES | grep -iqF y
then
    printf "\t******** GIT CONFIGURATION ********\n"
    printf "\t'user' configuration\n"

    read -p "$(printf "\t")Please enter 'email' value: " EMAIL
    read -p "$(printf "\t")Please enter 'name' value: " NAME

    printf "\tWriting 'user' configuration to 'configuration'\n"
    printf "\tEMAIL -- $EMAIL\n"
    printf "\tNAME -- $NAME\n"

    cat > $GIT_SENSITIVE_CONF << EOF
[user]
	email = $EMAIL
	name = $NAME
EOF
fi
