{
config, 
lib, 
pkgs,
... }: let
  unstable = import <nixpkgs-unstable> { config = { allowUnfree = true; }; };
in {
  # optional installs
  options = {
    installBundles = {
      quarto=lib.mkOption{default=true;};
      pandoc=lib.mkOption{default=true;};
      asciidoc=lib.mkOption{default=true;};
      latex=lib.mkOption{default=true;};
      rust=lib.mkOption{default=true;};
      golang=lib.mkOption{default=true;};
      aws=lib.mkOption{default=true;};
      kube=lib.mkOption{default=true;};
      ocaml=lib.mkOption{default=true;};
      elixir=lib.mkOption{default=true;};
      gleam=lib.mkOption{default=true;};
      qmk=lib.mkOption{default=true;};
    };
  };

  config = {
    home = {
      stateVersion = "24.05";
    };

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      # basics
      git
      jq
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
      marksman
      # spelling
      hunspell
      hunspellDicts.en_US
      hunspellDicts.de_DE
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      aspellDicts.de
      # nix
      nil
      # shell
      zoxide
      unstable.nushell
      unstable.carapace
      zsh
      unstable.oh-my-posh
      fzf
      # programming languages
      gnumake
      patch
      clang
      nodejs
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
      # lua
      lua
      luarocks
      luaPackages.lpeg
      luaPackages.busted
      # podman
      podman-tui
      # gitlab/github clis
      unstable.glab
      unstable.gh
      # fonts
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ] ++ (lib.optionals (config.installBundles.quarto) [
      quarto
    ])
    ++ (lib.optionals (config.installBundles.pandoc || config.installBundles.quarto) [
       pandoc
    ])
    ++ (lib.optionals config.installBundles.asciidoc [
       asciidoc-full-with-plugins
    ])
    ++ (lib.optionals config.installBundles.latex [
      # latex
      texlive.combined.scheme-medium
    ])
    ++ (lib.optionals (config.installBundles.pandoc || config.installBundles.pandoc || config.installBundles.quarto) [
      marksman
      plantuml-headless
      d2
      gnuplot
      graphviz
      nodePackages.mermaid-cli
    ])
    ++ (lib.optionals config.installBundles.golang [
      # golang
      unstable.go
      unstable.gotools
      unstable.gopls
    ])
    ++ (lib.optionals config.installBundles.rust [
      cargo
      rustc
    ])
    ++ (lib.optionals config.installBundles.ocaml [
      unstable.opam
      ocaml
    ])
    ++ (lib.optionals config.installBundles.gleam [
      unstable.gleam
    ])
    ++ (lib.optionals (config.installBundles.elixir|| config.installBundles.gleam) [
      # elixir/erlang
      elixir
      erlang
      rebar3
    ])
    ++ (lib.optionals config.installBundles.qmk [
        qmk
    ])
    ++ (lib.optionals config.installBundles.kube [
        # helm
      helm-ls
      kubectl
      k9s
    ])
    ++ (lib.optionals config.installBundles.aws [
      awscli2
      aws-gate
      sops
    ]);
    
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

      # symlink spell dir
      $DRY_RUN_CMD rm -rf $HOME/.config/nvim/spell
      $DRY_RUN_CMD ln -s $HOME/dotfiles/lazyvim/spell/ $HOME/.config/nvim/spell
      '';
      zellijConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD rm -rf $HOME/.config/zellij
      $DRY_RUN_CMD ln -s $HOME/dotfiles/zellij $HOME/.config/zellij
      '';
      marksmanConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD rm -rf $HOME/.config/marksman
      $DRY_RUN_CMD ln -s $HOME/dotfiles/marksman $HOME/.config/marksman
      '';
      nushellConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD rm -rf $HOME/.config/nushell
      $DRY_RUN_CMD ln -s $HOME/dotfiles/nushell $HOME/.config/nushell
      '';
    };
  };
}
