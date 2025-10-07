{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initContent = ''
      # load session variables
      [[ -f ~/.profile ]] && . ~/.profile

      # direnv
      eval "$(direnv hook zsh)"

      # oh my posh
      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ~/dotfiles/oh-my-posh.yaml)"
      # Shell integrations
      if [ -n "''${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      eval "$(keychain --eval --quiet)"

      eval "$(zoxide init --cmd cd zsh)"

      # init luarocks
      eval "$(luarocks path --bin)"

      # add cargo binaries to path
      if [ -d "$HOME/.cargo/bin" ]; then
        echo "Adding cargo/rust path"
        export PATH="$PATH:$HOME/.cargo/bin"
      fi

      # add go binaries to path
      if [ -d "$HOME/go/bin" ]; then
        echo "Adding go path"
        export PATH="$PATH:$HOME/go/bin"
      fi

      # add ~/.local/bin binaries to path
      if [ -d "$HOME/.local/bin" ]; then
        echo "Adding local bin path"
        export PATH="$HOME/.local/bin:$PATH"
      fi

      # run dirgit.sh
      ~/dotfiles/dirgit.sh ~/projects/private
      ~/dotfiles/dirgit.sh ~/projects/work
    '';
  };
}
