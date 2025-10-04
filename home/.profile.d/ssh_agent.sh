#!/bin/sh
pid_check () {
    case $SSH_AGENT_PID in
        # This PID is not a number
        ''|*[!0-9]*)
            START_AGENT=1
            ;;
        *)
            START_AGENT=0
            # If this check fails, that means there is no ssh-agent process running under the current user and with
            # the current PID value.
            ps -e -o user,pid,comm | grep $USER | grep " ${SSH_AGENT_PID} " | grep ssh-agent > /dev/null || START_AGENT=1
            ;;
    esac
}

enviornment_check () {
    local HOSTNAME_CMD=
    command -v hostname > /dev/null 2>&1 && HOSTNAME_CMD="hostname"
    [ -z "$HOSTNAME_CMD" ] && command -v hostnamectl > /dev/null 2>&1 && HOSTNAME_CMD="hostnamectl hostname"

    # First let's check to see if our SSH environment file exists. Side note:
    # We are saving the environment with the hostname appended on because
    # we could be saving the file into a shared place across machines (like
    # a NFS share). This way we don't clobber other machines SSH agent
    # environments.
    #
    # If the file does exist, let's recheck the SSH_AUTH_SOCK and then do our
    # PID check. If the file doesn't exist or the socket or PID check fails for
    # some reason, then we will need to just start the agent.
    if [ -f "${SSH_ENV}_$($HOSTNAME_CMD)" ]
    then
        source "${SSH_ENV}_$($HOSTNAME_CMD)" > /dev/null

        # We might still not have a valid socket at this point.
        if [ ! -S "$SSH_AUTH_SOCK" ]
        then
            START_AGENT=1
        # This could still have a valid socket but a bad PID.
        # Let's make sure the PID is still valid.
        elif [ ! -z "$SSH_AGENT_PID" ]
        then
            pid_check
        # If we get here, the enviornment file probably has something wrong with it.
        # Best to just restart the agent at this point.
        else
            START_AGENT=1
        fi
    else
        START_AGENT=1
    fi
}

start_agent () {
    local HOSTNAME_CMD=
    command -v hostname > /dev/null 2>&1 && HOSTNAME_CMD="hostname"
    [ -z "$HOSTNAME_CMD" ] && command -v hostnamectl > /dev/null 2>&1 && HOSTNAME_CMD="hostnamectl hostname"

    START_AGENT=$1
    if [ "$START_AGENT" != "1" ]
    then
        # Let's check to see if SSH_AUTH_SOCK has a socket loaded in already.
        # We do this before loading in our enviornment because an SSH session
        # could have already forwarded the keys or the desktop enviornment might
        # be taking care of things for us.
        if [ ! -S "$SSH_AUTH_SOCK" ]
        then
            # If we get here, that means no valid socket is defined in SSH_AUTH_SOCK.
            # Let's check our environment first and make sure there isn't an ssh-agent
            # already running with the environment loaded in.
            enviornment_check
        # Now let's see if the SSH_AGENT_PID variable is not empty.
        elif [ ! -z "$SSH_AGENT_PID" ]
        then
            # If we get here, that means a socket is defined in SSH_AUTH_SOCK and
            # there is a PID defined in SSH_AGENT_PID. So now we need to examine
            # the PID and see if a valid ssh-agent is running from it.
            pid_check
        # If we have a valid socket but no PID, we need to see if we are not in
        # an SSH session.
        elif [ -z "${SSH_CONNECTION}" ]
        then
            # If we get here, that means a socket is defined in SSH_AUTH_SOCK but
            # there is no PID defined in SSH_AGENT_PID and we are not in an SSH
            # session. Most likely we just need to source our SSH environment.
            enviornment_check
        # We are in an SSH session at this point with a valid SSH_AUTH_SOCK.
        else
            # If we get here this means: we have a socket defined in SSH_AUTH_SOCK,
            # no PID defined in SSH_AGENT_PID and we are in a SSH session that is
            # defined in SSH_CONNECTION. It's safe to assume that the keys were
            # forwarded at this point.
            #
            # Theoretically, the socket in SSH_AUTH_SOCK could be a bad socket (aka
            # one that isn't being used or one that has the wrong agent listening
            # on it). But if its set at this point in time, it's probably good.
            START_AGENT=0
        fi
    fi

    if [ "$START_AGENT" = "1" ]
    then
        # First let's gather any PIDs that are ssh-agent programs running under the current user. Then kill them.
        SSH_AGENT_PIDS="$(ps -e -o pid,user,comm | grep ssh-agent | grep $USER | tr -s ' ' | cut -d' ' -f2)"
        [ ! -z "$SSH_AGENT_PIDS" ] && kill -9 $SSH_AGENT_PIDS

        # Now let's start up a new ssh-agent and save off the environment
        /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}_$($HOSTNAME_CMD)"
        chmod 600 "${SSH_ENV}_$($HOSTNAME_CMD)"

        # Load in our new settings
        . "${SSH_ENV}_$($HOSTNAME_CMD)" > /dev/null
    fi
}

start_agent 0
