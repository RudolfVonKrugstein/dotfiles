#!/bin/bash

# Use current directory or first argument
ROOT="${1:-$(pwd)}"

# Find all Git repositories and check for dirty state
find "$ROOT" -type d -name ".git" 2>/dev/null | while read -r gitdir; do
    repo="$(dirname "$gitdir")"
    cd "$repo" || continue
    if [[ -n $(git status --porcelain) ]]; then
        echo "$repo is dirty"
    fi
    if [[ -n $(git log --branches --not --remotes) ]]; then
        echo "$repo has unpushed changes"
    fi
done
