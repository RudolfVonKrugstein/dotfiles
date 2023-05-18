#!/bin/bash
set -e

# test if we are in zellij session ...


dest_dir=$({ zellij action query-tab-names; zoxide query -l; } | sed 's#.git/##' | \
  fzf --prompt "zellij tabs: " \
  --bind 'ctrl-x:change-prompt(zoxide: )+reload(zoxide query -l)' \
  --bind 'ctrl-d:change-prompt(directory: )+reload(fd . ~ -t d)' \
  --bind 'tab:up' \
  --bind 'shift-tab:down' \
  --header 'CTRL-X: zoxide | CTRL-D: directory')

# test if we have selected a tab name!
if zellij action query-tab-names | grep "$dest_dir"; then
  # just switch to the tab
  zellij action go-to-tab-name "$dest_dir"
  exit 0
fi

session_name=$(echo "$dest_dir" | grep -Eo '\/[^\/]+\/?$' | cut -d '/' -f 2)
echo "OK, session $session_name for $dest_dir"

# search for the new-tab
if zellij action query-tab-names | grep "$session_name"; then
  # the tab already exists!
  zellij action go-to-tab-name "$session_name"
else
  # open a new tab
  zoxide add "$dest_dir"
  zellij action new-tab --cwd "$dest_dir" --name "$session_name" --layout default
fi
