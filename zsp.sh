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

# list branches
worktree_branch=$(git branch -a --format "%(refname)" \
  | sed 's|^.*/\(.*\)$|\1|g' \
  | sort \
  | uniq \
  | (echo "no worktree"; echo "new branch"; cat) \
  | fzf --prompt "worktree: " \
    --bind 'tab:up' \
    --bind 'shift-tab:down')

if [[ "$worktree_branch" != "no worktree" ]]; then
  if [[ "$worktree_branch" == "new branch" ]]; then
    read -p "Branch Name: " worktree_branch
    git branch "$worktree_branch"
  fi

  if git worktree list | grep "\[$worktree_branch\]"; then
    worktree_branch_dir=$(git worktree list | grep "\[$worktree_branch\]" | awk '{print $1}')
  else
    worktree_branch_dir=$(echo "$worktree_branch" | tr "/" "_")
    git worktree add "$HOME/worktrees/$session_name/$worktree_branch_dir" 
  fi
  echo "Switching to $worktree_branch_dir"
  cd $worktree_branch_dir
fi

# rename the tab
zellij action rename-tab "$session_name>$worktree_branch"

# list the branches
