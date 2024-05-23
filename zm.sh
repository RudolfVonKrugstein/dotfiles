#!/bin/env bash

set -e

while true; do
        # open fzf
        choice=$( (zellij list-sessions -s; zoxide query -l) | fzf \
                --no-sort --border-label ' sesh ' --prompt '⚡  ' \
		--header '  ^a all ^t sessions ^x zoxide ^f find' \
		--bind 'tab:down,btab:up' \
                --bind 'ctrl-a:change-prompt(⚡  )+reload((zellij list-sessions -s; zoxide query -l))' \
		--bind 'ctrl-t:change-prompt(🪟  )+reload(zellij list-sessions -s)' \
		--bind 'ctrl-x:change-prompt(📁  )+reload(zoxide query -l)' \
		--bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)'
        )

        # check weather there is already a session with exact that name
        if zellij list-sessions -s | grep -x "$choice"; then
                echo "Attching to existing sessions"
                zellij a "$choice"
        else
                echo "Getting session name from directory"
                # find the session name by referencing the git root
                pushd "$choice"

                git_root=$(git rev-parse --show-toplevel)
                above_git_root=$(dirname "${git_root}")

                session_name=${choice#"$above_git_root"}
                session_name=${session_name#/}
                session_name=${session_name//[\/]/>}

                # name of the session
                echo "Looking for session names $session_name"

                # check again for existing session
                if zellij list-sessions -s | grep -x "$session_name"; then
                        zellij a "$session_name"
                else
                        echo "Creating new session for $choice"


                        zellij -s "$session_name"
                fi

                popd
        fi
done
