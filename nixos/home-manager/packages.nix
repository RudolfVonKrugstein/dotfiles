{
  config,
  lib,
  pkgs,
  agenix,
  ...
}:
let
  # Chromium for Playwright. Not `browsers-chromium`: that one lacks
  # chromium-headless-shell, which headless `launch()` uses by default.
  # From unstable, so it matches the unstable python playwright package.
  playwrightBrowsers = pkgs.unstable.playwright-driver.selectBrowsers {
    withFirefox = false;
    withWebkit = false;
  };
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
      typst = lib.mkOption { default = true; };
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
      jev = lib.mkOption { default = true; };
      webdev = lib.mkOption { default = true; };
      gnome = lib.mkOption { default = false; };
      kde = lib.mkOption { default = false; };
      audio = lib.mkOption { default = true; };
      agenix = lib.mkOption { default = false; };
      vscode = lib.mkOption { default = false; };
      playwright = lib.mkOption { default = true; };
      ledger = lib.mkOption { default = true; };
      wsl = lib.mkOption { default = false; };
    };
  };

  config = {

    # jevgrep ignores environment variables and only reads its own saved
    # credentials. Save the shared TypeSafe key there, again whenever the key
    # file is newer than the credentials (so a rotated key is picked up, but
    # a provider chosen by hand with `jg auth` is otherwise left alone).
    home.activation.jevgrepAuth = lib.mkIf config.installBundles.jev (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        keyFile="$HOME/.config/typesafe/key"
        credFile="''${XDG_CONFIG_HOME:-$HOME/.config}/jevgrep/credentials.json"
        if [ -s "$keyFile" ] && { [ ! -e "$credFile" ] || [ "$keyFile" -nt "$credFile" ]; }; then
          $DRY_RUN_CMD ${pkgs.jevgrep}/bin/jg auth --provider typesafe --stdin \
            < <(${pkgs.coreutils}/bin/tr -d '[:space:]' < "$keyFile") >/dev/null
          echo "jevgrep: saved TypeSafe key from $keyFile"
        fi
      ''
    );

    home.sessionVariables = lib.mkIf config.installBundles.playwright {
      PLAYWRIGHT_BROWSERS_PATH = "${playwrightBrowsers}";
      # the host-dependency check looks in FHS paths and fails on NixOS
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    };

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
        git-filter-repo
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
        panache
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
        shfmt
        shellharden
        bash-language-server
        # python
        (unstable.python3.withPackages (ppkgs: [
          ppkgs.ansible
          ppkgs.requests
          ppkgs.pip
          ppkgs.python-dateutil
          ppkgs.beautifulsoup4
          ppkgs.openai
          ppkgs.ipython
        ]
        # must come from the same nixpkgs as the browsers below (versions must match)
        ++ lib.optionals config.installBundles.playwright [
          ppkgs.playwright
        ]))
        virtualenv
        unstable.ruff
        unstable.mypy
        basedpyright
        uv
        poetry
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
        minisign
        librsvg
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
            framed
            fvextra
            upquote
            xurl
            tcolorbox
            newunicodechar
            tikzfill
            opensans
            pdfcol
          ]
        ))
      ])
      ++ (lib.optionals config.installBundles.typst [
        typst
        typstyle
        typst-live
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
          gnuplot
          graphviz
          mermaid-cli
          unstable.manim
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
        unstable.gofumpt
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
        rustfmt
        clippy
        rust-analyzer
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
        browser-sync
        tailwindcss
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
        s5cmd
        s3cmd
      ])
      ++ (lib.optionals config.installBundles.ai [
        aider-chat
        claude-code
        codex
        gemini-cli
        unstable.opencode
        lsof
      ])
      ++ (lib.optionals config.installBundles.jev [
        jevr # reads the key file itself (wrapper)
        jevgrep # `jg`; authenticated by home.activation.jevgrepAuth
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
        libreoffice
      ])
      ++ (lib.optionals config.installBundles.audio [
        sox
        pulseaudio
        pamix
        openai-whisper
        whisper-cpp
        audacity
        ffmpeg
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
      ])
      ++ (lib.optionals config.installBundles.playwright [
        # unstable, to match the python playwright package above
        unstable.playwright
        playwrightBrowsers
        imagemagick
        oxipng
      ])
      ++ (lib.optionals config.installBundles.ledger [
        ledger
        hledger
      ])
      ++ (lib.optionals config.installBundles.wsl [
        win32yank
      ]);
  };
}
