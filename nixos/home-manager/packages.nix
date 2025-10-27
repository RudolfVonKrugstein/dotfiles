{
  config,
  lib,
  pkgs,
  ...
}:
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
    };
  };

  config = {

    home.packages =
      with pkgs;
      [
        # basics
        git
        jq
        keychain
        # disk tools
        ncdu
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
        # helix
        helix
        # neovim and tools around that
        unstable.lazygit
        zellij
        yazi
        unstable.neovim
        tree-sitter
        ripgrep
        fd
        marksman
        markdownlint-cli2
        taplo
        yaml-language-server
        yamlfmt
        lsp-ai
        vscode-langservers-extracted
        nur.repos.charmbracelet.crush
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
        python313
        python313.pkgs.pip
        virtualenv
        unstable.ruff
        unstable.mypy
        basedpyright
        uv
        unstable.poetry
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
        # gitlab/github clis
        unstable.glab
        unstable.gh
        # ansible
        ansible
        ansible-language-server
        ansible-lint
        # other usefull tools
        gitleaks
        # put into own condition?
        # agenix.packages.x86_64-linux.default
        # fonts
        unstable.nerd-fonts.fira-code
        unstable.nerd-fonts.droid-sans-mono
      ]
      ++ (lib.optionals (config.installBundles.quarto) [
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
          ]
        ))
      ])
      ++ (lib.optionals config.installBundles.astro [
        astro-language-server
      ])
      ++ (lib.optionals
        (config.installBundles.pandoc || config.installBundles.pandoc || config.installBundles.quarto)
        [
          marksman
          plantuml-headless
          d2
          gnuplot
          graphviz
          nodePackages.mermaid-cli
          manim
        ]
      )
      ++ (lib.optionals config.installBundles.golang [
        # golang
        unstable.go
        unstable.gotools
        unstable.gopls
        unstable.goreleaser
        unstable.revive
        unstable.golangci-lint
        unstable.golangci-lint-langserver
        unstable.delve
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
        beam.packages.erlang_27.elixir
        beam.packages.erlang_27.erlang
        beam.packages.erlang_27.rebar3
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
        awscli2
        aws-gate
        sops
      ])
      ++ (lib.optionals config.installBundles.ai [
        unstable.aider-chat
        unstable.goose-cli
        claude-code
      ]);
  };
}
