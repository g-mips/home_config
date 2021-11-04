#!/bin/sh
set -e

[ -z "$XDG_CACHE_HOME" ] && CACHE_DIR=$HOME/.cache || CACHE_DIR=$XDG_CACHE_HOME
INIT_CONFIG_FILE="${CACHE_DIR}/config_config/newsboat/config_extra"

mkdir -p $(dirname $INIT_CONFIG_FILE) > /dev/null 2>&1

read -N 1 -p "Include TTRSS options? (y|n) " INCLUDE_TTRSS_OPTIONS

if printf "%s" $INCLUDE_TTRSS_OPTIONS | grep -iqF y
then
    read -p $'\nEnter password database location ' PASS_DB
    read -p "Enter password database TTRSS entry " PASS_DB_TTRSS_ENTRY
    read -p "Enter newsboat TTRSS url " NEWSBOAT_URL
    read -p "Enter TTRSS login username " TTRSS_LOGIN

    cat > $INIT_CONFIG_FILE <<- EOF

# TTRSS setup
urls-source "ttrss"
ttrss-url "$NEWSBOAT_URL"
ttrss-login "$TTRSS_LOGIN"
ttrss-passwordeval "keepassxc-cli show -q -a password $PASS_DB $PASS_DB_TTRSS_ENTRY | tr -d '\n'"
ttrss-flag-star s
EOF
fi
