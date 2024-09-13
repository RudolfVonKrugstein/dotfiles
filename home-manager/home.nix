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
    # shell
    zsh
    fzf
    # fun tools
    htop
    fortune
    cowsay
  ];

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
}
