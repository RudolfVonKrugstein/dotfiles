{ config, lib, pkgs, ... }:
let
  unstable = import <nixpkgs-unstable> { config = { allowUnfree = true; }; };
in {
  home = {
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # basics
    git
    # font
    jetbrains-mono
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
    # nix
    nil
    # helm
    helm-ls
    # shell
    zoxide
    zsh
    unstable.oh-my-posh
    atuin
    fzf
    # programming languages
    clang
    unstable.gleam
    ocaml
    cargo
    rustc
    nodejs
    # elixir/erlang
    elixir
    erlang
    rebar3
    # python
    python3
    python3.pkgs.pip
    ruff
    poetry
    uv
    # pkgs.basedpyright
    # other language servers
    lua-language-server
    stylua
    spectral-language-server
    # pandoc
    quarto
    pandoc
    marksman
    plantuml-headless
    d2
    nodePackages.mermaid-cli
    # latex
    texlive.combined.scheme-medium
    # lua
    lua
    luarocks
    luaPackages.lpeg
    luaPackages.busted
    # ocaml
    unstable.opam
    gnumake
    patch
    # golang
    unstable.go
    unstable.gotools
    unstable.gopls
    # keybaord configuration
    qmk
    # podman
    podman-tui
    # fonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
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

      # init luarocks
      eval "$(luarocks path --bin)"

      # add cargo binaries to path
      export PATH="$PATH:$HOME/.cargo/bin"
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
    export PATH="$HOME/bin:$PATH"
    if [ ! -d "$HOME/.config/nvim" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/LazyVim/starter $HOME/.config/nvim
    fi

    # symlink the layzvim.json
    $DRY_RUN_CMD rm -rf $HOME/.config/nvim/lazyvim.json
    $DRY_RUN_CMD ln -s $HOME/dotfiles/lazyvim/lazyvim.json $HOME/.config/nvim/lazyvim.json

    # symlink files in config dir
    for config_file in $HOME/dotfiles/lazyvim/lua/config/*.lua; do
      $DRY_RUN_CMD mkdir -p $HOME/.config/nvim/config
      export target_config_file="$HOME/.config/nvim/lua/config/$(basename $config_file)"
      $DRY_RUN_CMD rm -rf "$target_config_file"
      echo "$config_file -> $target_config_file"
      $DRY_RUN_CMD ln -s "$config_file" "$target_config_file"
    done

    # symlink files in plugin dir
    for plugin_file in $HOME/dotfiles/lazyvim/lua/plugins/*.lua; do
      $DRY_RUN_CMD mkdir -p $HOME/.config/nvim/plugins
      export target_plugin_file="$HOME/.config/nvim/lua/plugins/$(basename $plugin_file)"
      $DRY_RUN_CMD rm -rf "$target_plugin_file"
      echo "$plugin_file -> $target_plugin_file"
      $DRY_RUN_CMD ln -s "$plugin_file" "$target_plugin_file"
    done
    '';
    zellijConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD rm -rf $HOME/.config/zellij
    $DRY_RUN_CMD ln -s $HOME/dotfiles/zellij $HOME/.config/zellij
    '';
    marksmanConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD rm -rf $HOME/.config/marksman
    $DRY_RUN_CMD ln -s $HOME/dotfiles/marksman $HOME/.config/marksman
    '';
  };
}
