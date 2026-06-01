{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    configFile = "~/dotfiles/oh-my-posh.yaml";
    package = pkgs.unstable.oh-my-posh;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    sessionVariables = {
      EDITOR = "nvim";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initContent = ''
      # load session variables
      [[ -f ~/.profile ]] && . ~/.profile

      # direnv
      eval "$(direnv hook zsh)"

      # Shell integrations
      if [ -n "''${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      eval "$(keychain --eval --quiet)"
     
      if [[ -z $CLAUDECODE ]]; then
        eval "$(zoxide init --cmd cd zsh)"
      fi

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

      # emacs
      if [ -d ~/.config/emacs/bin ]; then
          echo "Adding emacs config bin path"
          export PATH=$PATH:~/.config/emacs/bin
      fi

      # add windows scoop directory (if it exists) to path
      if [ -d "/mnt/c/Users/NathanHuesken/scoop/shims" ]; then
        echo "Adding windows scoop directory"
        export PATH="/mnt/c/Users/NathanHuesken/scoop/shims:$PATH"
      fi


      # run dirgit.sh
      PATH=$PATH:${pkgs.bash} ~/dotfiles/dirgit.sh ~/projects/private
      PATH=$PATH:${pkgs.bash} ~/dotfiles/dirgit.sh ~/projects/work
    '';
  };
}
