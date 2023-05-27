#!/bin/bash
dest_dir=$({ zoxide query -l; } | sed 's#.git/##' | \
  fzf --prompt "zoxide: " \
  --bind 'ctrl-x:change-prompt(zoxide: )+reload(zoxide query -l)' \
  --bind 'ctrl-d:change-prompt(directory: )+reload(fd . ~ -t d)' \
  --bind 'tab:up' \
  --bind 'shift-tab:down' \
  --header 'CTRL-X: zoxide | CTRL-D: directory')

session_name=$(echo "$dest_dir" | grep -Eo '\/[^\/]+\/?$' | cut -d '/' -f 2)
echo "OK, session $session_name for $dest_dir"

# goto directory
cd "$dest_dir"

# rename the tab
zellij action rename-tab "$session_name"

