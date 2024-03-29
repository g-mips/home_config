start_agent () {
    # Check to see if this is a multi user environment
    if [ $(/usr/bin/ls -1 /home/ | sed '/lost+found/d' | wc -l) -eq 1 ]
    then
        printf "Initialising new SSH agent...\n"
        /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
        printf "Succeeded\n"
        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null
        /usr/bin/ssh-add;
    fi
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]
then
     . "${SSH_ENV}" > /dev/null
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent > /dev/null || {
         killall -9 ssh-agent > /dev/null 2>&1
         start_agent;
     }
else
     start_agent;
fi
