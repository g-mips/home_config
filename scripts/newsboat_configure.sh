#!/bin/sh
set -e

TTRSS_NEWSBOAT_CONF_FILE=${XDG_CONFIG_HOME}/newsboat/config.d/ttrss.conf

INCLUDE_TTRSS_OPTIONS='y'
[ -f "$TTRSS_NEWSBOAT_CONF_FILE" ] && read -N 1 -p "$(printf "\t")Reconfigure newsboat TTRSS? (y|n) " INCLUDE_TTRSS_OPTIONS \
    || read -N 1 -ep "$(printf "\t")Include TTRSS options? (y|n) " INCLUDE_TTRSS_OPTIONS

mkdir -p $(dirname $TTRSS_NEWSBOAT_CONF_FILE) > /dev/null 2>&1

printf "\n"

if printf "%s" $INCLUDE_TTRSS_OPTIONS | grep -iqF y
then
    read -ep "$(printf "\t")Enter password database location " PASS_DB
    read -ep "$(printf "\t")Enter password database TTRSS entry " PASS_DB_TTRSS_ENTRY
    read -ep "$(printf "\t")Enter newsboat TTRSS url " NEWSBOAT_URL
    read -ep "$(printf "\t")Enter TTRSS login username " TTRSS_LOGIN

    cat > $TTRSS_NEWSBOAT_CONF_FILE <<- EOF
# TTRSS setup
urls-source "ttrss"
ttrss-url "$NEWSBOAT_URL"
ttrss-login "$TTRSS_LOGIN"
ttrss-passwordeval "keepassxc-cli show -q -a password $PASS_DB $PASS_DB_TTRSS_ENTRY | tr -d '\n'"
ttrss-flag-star s
EOF
fi
