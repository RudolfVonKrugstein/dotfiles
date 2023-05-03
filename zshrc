ZSH_THEME="gnzh"
source <(antibody init)

plugins=(
  git
  tmux
  zoxide
)
antibody bundle ohmyzsh/ohmyzsh
antibody bundle djui/alias-tips
antibody bundle zsh-users/zsh-history-substring-search

bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# alias git=/usr/local/bin/g

# add ssh keys
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
fi
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# export SSH_KEYS="
# /home/nathan/Tresors/wintercloud-developer-confidential/aws/keypairs/wintercloud-test-general.pem
# /home/nathan/Tresors/wintercloud-developer-confidential/aws/keypairs/wintercloud-test-heartbleed-general.pem"
# SSH_ADD_OUTPUT=`ssh-add -L`
#
# for key in "$SSH_KEYS"; do
# 	if ! echo $SSH_ADD_OUTPUT | grep -q $key; then
# 		ssh-add $key
# 	fi
# done

export EDITOR=vim

# Update path variable
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.poetry/bin:$PATH"

# flutter
export PATH="$HOME/development/flutter/bin:$PATH"
export PATH="$HOME/development/Android/Sdk/platform-tools:$PATH"

# java
export JAVA_HOME=$(java -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' | awk '{print $3}')

# rust
[ -f ~/.cargo/env ] && source $HOME/.cargo/env

# go
[ -d ~/go/bin ] && export PATH=$PATH:$HOME/go/bin

# enable startship
eval "$(starship init zsh)"

# configure zoxide
eval "$(zoxide init zsh)"
alias ll="exa -l -g --icons --git"
alias llt="exa -1 --icons --tree --git-ignore"

# aliases
alias ll="exa -l -g --icons --git"
alias llt="exa -1 --icons --tree --git-ignore"

# spawn tmux
ZSH_TMUX_AUTOSTART=true

# load github tokens
if [ -f ~/.gitlab_token ]; then
    export GITLAB_TOKEN=$(cat ~/.gitlab_token)
fi
if [ -f ~/.gitlab_wc_token ]; then
    export GITLAB_WC_TOKEN=$(cat ~/.gitlab_wc_token)
fi
if [ -f ~/.github_token ]; then
    export GITHUB_TOKEN=$(cat ~/.github_token)
fi

export GIT_WORKSPACE="~/projects"

# tmux session manager
# ~/.tmux/plugins
export PATH=$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
# ~/.config/tmux/plugins
export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH

# fzf
if [ -d ~/.fzf/bin ]; then
  export PATH=$PATH:~/.fzf/bin
fi
