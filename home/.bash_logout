#
# ~/.bash_logout
#
if command -v timeout > /dev/null 2>&1 && command -v tput > /dev/null 2>&1
then
    timeout 1 tput reset
fi
