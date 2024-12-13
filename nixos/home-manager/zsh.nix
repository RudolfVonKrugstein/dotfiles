{
config, 
lib, 
pkgs,
... }: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      initExtra = ''
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
        export PATH="$PATH:$HOME/.cargo/bin"
      '';
    };
}
