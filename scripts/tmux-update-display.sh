#!/usr/bin/env bash

# The problem:
# When you `ssh -X` into a machine and attach to an existing tmux session, the session
# contains the old $DISPLAY env variable. In order the x-server/client to work properly,
# you have to update $DISPLAY after connection. For example, the old $DISPLAY=:0 and
# you need to change to DISPLAY=localhost:10.0 for the ssh session to
# perform x-forwarding properly.

# The solution:
# When attaching to tmux session, update $DISPLAY for each tmux pane in that session
# This is performed by using tmux send-keys to the shell.
# This script handles updating $DISPLAY within vim also

NEW_DISPLAY=$(tmux show-env | sed -n 's/^DISPLAY=//p')

# check if lljbash/zsh-renew-tmux-env installed
if [[ ! -z $(type zsh 2>/dev/null) ]]; then
    HAS_RENEW=$(zsh -ci 'type renew_tmux_env | grep function')
else
    HAS_RENEW=
fi

tmux set-option -wg monitor-activity off
tmux set-option -wg monitor-bell off
tmux list-panes -s -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}" | \
while read pane_process
do
    IFS=' ' read -ra pane_process <<< "$pane_process"
    if [[ "${pane_process[1]}" == "bash" ]]; then
        tmux send-keys -t ${pane_process[0]} ^E ^U "export DISPLAY=$NEW_DISPLAY" Enter ^Y ^E
    elif [[ "${pane_process[1]}" == "zsh" ]]; then
        if [[ ! -z $HAS_RENEW ]]; then
            tmux send-keys -t ${pane_process[0]} Escape ^T
        else
            tmux send-keys -t ${pane_process[0]} ^E ^U "export DISPLAY=$NEW_DISPLAY" Enter ^Y ^E
        fi
    elif [[ "${pane_process[1]}" =~ '^n?vim?$' ]]; then
        tmux send-keys -t ${pane_process[0]} Escape Escape Escape
        tmux send-keys -t ${pane_process[0]} ":let \$DISPLAY = \"$NEW_DISPLAY\"" Enter
        tmux send-keys -t ${pane_process[0]} ":execute exists(':xrestore') ? 'xrestore' : ''" Enter ^L
    fi
done
sleep 30
tmux set-option -wg monitor-activity on
tmux set-option -wg monitor-bell on
