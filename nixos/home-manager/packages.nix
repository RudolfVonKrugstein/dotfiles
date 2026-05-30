{
  config,
  lib,
  pkgs,
  agenix,
  ...
}:
let
  gotoolsWithoutModernizeAndPlay = pkgs.symlinkJoin {
    name = "gotools-without-modernize";
    paths = [ pkgs.unstable.gotools ];
    postBuild = ''
      rm -f "$out/bin/modernize"
      rm -f "$out/bin/play"
    '';
  };
in
{
  # optional installs
  options = {
    installBundles = {
      quarto = lib.mkOption { default = true; };
      pandoc = lib.mkOption { default = true; };
      asciidoc = lib.mkOption { default = true; };
      latex = lib.mkOption { default = true; };
      astro = lib.mkOption { default = true; };
      rust = lib.mkOption { default = true; };
      golang = lib.mkOption { default = true; };
      nim = lib.mkOption { default = true; };
      aws = lib.mkOption { default = true; };
      kube = lib.mkOption { default = true; };
      ocaml = lib.mkOption { default = true; };
      elixir = lib.mkOption { default = true; };
      gleam = lib.mkOption { default = true; };
      zig = lib.mkOption { default = true; };
      qmk = lib.mkOption { default = true; };
      ai = lib.mkOption { default = true; };
      webdev = lib.mkOption { default = true; };
      gnome = lib.mkOption { default = false; };
      kde = lib.mkOption { default = false; };
      audio = lib.mkOption { default = true; };
      agenix = lib.mkOption { default = false; };
      vscode = lib.mkOption { default = false; };
    };
  };

  config = {

    home.packages =
      with pkgs;
      [
        # basics
        jq
        keychain
        sops
        # disk tools
        ncdu
        dua
        # nixos
        nix-index
        nix-du
        graphviz
        # font
        jetbrains-mono
        # fun tools
        htop
        fortune
        cowsay
        tree
        entr
        # helix
        helix
        # git
        git
        jujutsu
        unstable.lazygit
        # neovim and tools around that
        unstable.neovim
        unstable.tree-sitter
        # neovim-nightly-overlay.packages.${pkgs.system}.default
        # neovim-nightly-overlay.packages.${pkgs.system}.tree-sitter
        zellij
        yazi
        superfile
        ripgrep
        ast-grep
        fd
        marksman
        mdformat
        markdownlint-cli2
        taplo
        yaml-language-server
        yamlfmt
        lsp-ai
        vscode-langservers-extracted
        # html lsp
        superhtml
        prettier
        # emacs
        emacs
        # spelling
        harper
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
        nixfmt-rfc-style
        # build
        cmake
        pkg-config
        # shell
        zoxide
        unstable.nushell
        fish
        unstable.carapace
        zsh
        unstable.oh-my-posh
        fzf
        go-task
        just
        inotify-tools
        tailspin
        hexyl
        # programming languages
        gnumake
        patch
        clang
        nodejs
        direnv
        nix-direnv
        # bash programming
        shellspec
        shellcheck
        # python
        (python3.withPackages (ppkgs: [
          ppkgs.ansible
          ppkgs.requests
          ppkgs.pip
          ppkgs.python-dateutil
        ]))
        virtualenv
        unstable.ruff
        unstable.mypy
        basedpyright
        uv
        poetry
        pipx
        unstable.pyrefly
        unstable.ty
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
        podman
        podman-tui
        podman-compose
        lazydocker
        # gitlab/github clis
        unstable.glab
        unstable.gh
        # ansible
        ansible
        ansible-lint
        # other usefull tools
        gitleaks
        # put into own condition?
        # fonts
        unstable.nerd-fonts.fira-code
        unstable.nerd-fonts.droid-sans-mono
        # database tools
        harlequin
        # dev tools
        toxiproxy
      ]
      ++ (lib.optionals (config.installBundles.quarto) [
        quarto
        svgo
        xmlstarlet
      ])
      ++ (lib.optionals (config.installBundles.pandoc || config.installBundles.quarto) [
        pandocBinary
      ])
      ++ (lib.optionals config.installBundles.asciidoc [
        asciidoc-full-with-plugins
      ])
      ++ (lib.optionals config.installBundles.latex [
        # latex
        (texlive.withPackages (
          ps: with ps; [
            scheme-medium
            moderncv
            hyphenat
            paralist
            datetime2
            enumitem
            texpresso
            zathura
            latexrun
            environ
            datetime
            fmtcount
            wallpaper
            numprint
          ]
        ))
      ])
      ++ (lib.optionals config.installBundles.astro [
        astro-language-server
      ])
      ++ (lib.optionals
        (
          config.installBundles.pandoc
          || config.installBundles.pandoc
          || config.installBundles.quarto
          || config.iunstallBundles.asciidoc
        )
        [
          marksman
          plantuml-headless
          d2
          gnuplot
          graphviz
          nodePackages.mermaid-cli
          manim
          # needed for manim
          pkg-config
          pango
          cairo
          gobject-introspection
        ]
      )
      ++ (lib.optionals config.installBundles.golang [
        # golang
        unstable.go
        unstable.gopls
        unstable.goreleaser
        unstable.revive
        unstable.golangci-lint
        unstable.golangci-lint-langserver
        unstable.delve
        gotoolsWithoutModernizeAndPlay
      ])
      ++ (lib.optionals config.installBundles.nim [
        nim
        nimble
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
      ++ (lib.optionals (config.installBundles.elixir || config.installBundles.gleam) [
        # elixir/erlang
        beam.packages.erlang_28.elixir
        beam.packages.erlang_28.erlang
        beam.packages.erlang_28.rebar3
      ])
      ++ (lib.optionals (config.installBundles.zig) [
        zig
        zls
      ])
      ++ (lib.optionals (config.installBundles.webdev) [
        # webdev
        nodePackages.browser-sync
        nodePackages.tailwindcss
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
        unstable.awscli2
        aws-gate
        sops
      ])
      ++ (lib.optionals config.installBundles.ai [
        aider-chat
        claude-code
        gemini-cli
        unstable.opencode
        lsof
        unstable.llama-cpp
      ])
      ++ (lib.optionals (config.installBundles.gnome || config.installBundles.kde) [
        kitty
        keepassxc
        brave
        google-chrome
        masterpdfeditor
        evince
        kdePackages.okular
        libsecret
        gobject-introspection
        wofi
        zenity
        cairo
        gimp
        inkscape
      ])
      ++ (lib.optionals config.installBundles.audio [
        sox
        pulseaudio
        pamix
      ])
      ++ (lib.optionals config.installBundles.gnome [
        gnome-tweaks
        dconf-editor
      ])
      ++ (lib.optionals config.installBundles.agenix [
        agenix.packages.x86_64-linux.default
      ])
      ++ (lib.optionals config.installBundles.vscode [
        vscode
      ]);
  };
}
