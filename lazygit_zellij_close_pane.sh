#!/bin/bash
if [  -d "$HOME/go/bin" ]; then
        export PATH="$PATH:$HOME/go/bin"
fi
if [  -d "$HOME/.cargo/bin" ]; then
        export PATH="$PATH:$HOME/.cargo/bin"
fi
lazygit
zellij action close-pane
