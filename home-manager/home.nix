{ config, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  home = {
    username = "nathan";
    homeDirectory = "/home/nathan";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # font
    jetbrains-mono
    # shell
    zsh
    fzf
    # fun tools
    htop
    fortune
    cowsay
    # neovim and tools around that
    unstable.lazygit
    zellij
    yazi
    unstable.neovim
    ripgrep
    fd
    # shell
    zoxide
    zsh
    unstable.oh-my-posh
    atuin
    fzf
    # programming languages
    clang
    unstable.gleam
    elixir
    erlang
    ocaml
    cargo
    rustc
    nodejs
    # python
    python3
    ruff
    # pkgs.basedpyright
    # other language servers
    lua-language-server
    stylua
    spectral-language-server
    # pandoc
    unstable.pandoc
    plantuml
    d2
    nodePackages.mermaid-cli
    lua
    # ocaml
    opam
    gnumake
    patch
  ];
  
  fonts.fontconfig.enable = true;

  programs.git = {
    enable = true;
    userName = "Nathan Hüsken";
    userEmail = "nathan@huesken";
    signing.signByDefault = true;
    signing.key = "A7FB930FB8597407AEAB96236FEB23FCF209BDB0";
    aliases = {
      unstage = "reset HEAD --";
      pr = "pull --rebase";
      co = "checkout";
      ci = "commit";
      c = "commit";
      b = "branch";
      p = "push";
      d = "diff";
      a = "add";
      s = "status";
      f = "fetch";
      br = "branch";
      rf = "reflog";
    };
    extraConfig = {
      core.editor = "${pkgs.neovim}/bin/nvim";
    };
  };

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
      eval "$(zoxide init --cmd cd zsh)"
    '';
  };

  programs.gpg = {
    enable = true;
    publicKeys = []; # see https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys
    settings = {
      default-key = "A7FB930FB8597407AEAB96236FEB23FCF209BDB0";
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 36000;
    maxCacheTtl = 36000;
    defaultCacheTtlSsh = 36000;
    maxCacheTtlSsh = 36000;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry;
  };  

  # neovim/LazyVim activation script
  home.activation = {
    initLazyVim = lib.hm.dag.entryAfter ["installPackages"] ''
    export PATH="${config.home.path}/bin:$PATH"
    if [ ! -d ~/.config/nvim ]; then
      $DRY_RUN_CMD git clone https://github.com/LazyVim/starter ~/.config/nvim
    fi

    # symlink the layzvim.json
    $DRY_RUN_CMD rm -rf ~/.config/nvim/lazyvim.json
    $DRY_RUN_CMD ln -s ~/dotfiles/lazyvim/lazyvim.json ~/.config/nvim/lazyvim.json

    # symlink files in config dir
    for config_file in ~/dotfiles/lazyvim/lua/config/*.lua; do
      export target_config_file="$HOME/.config/nvim/lua/config/$(basename $config_file)"
      $DRY_RUN_CMD rm -rf "$target_config_file"
      $DRY_RUN_CMD ln -s "$config_file" "$target_config_file"
    done

    # symlink files in plugin dir
    for plugin_file in ~/dotfiles/lazyvim/lua/plugins/*.lua; do
      export target_plugin_file="$HOME/.config/nvim/lua/plugins/$(basename $plugin_file)"
      $DRY_RUN_CMD rm -rf "$target_plugin_file"
      $DRY_RUN_CMD ln -s "$plugin_file" "$target_plugin_file"
    done
    '';
    zellijConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD rm -rf ~/.config/zellij
    $DRY_RUN_CMD ln -s dotfiles/zellij ~/.config/zellij
    '';
  };
}
