{ config, lib, pkgs, ... }:
let
    pkgsUnstable = import <nixpkgs-unstable> {};
    sshdTmpDirectory = "${config.user.home}/sshd-tmp";
    sshdDirectory = "${config.user.home}/sshd";
    pathToPubKey = "";
    port = 8022;
in
{
  build.activation.sshd = ''
    $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${config.user.home}/.ssh"
    if [[ ! -z "${pathToPubKey}" ]]; then
      $DRY_RUN_CMD cat ${pathToPubKey} > "${config.user.home}/.ssh/authorized_keys"
    fi

    if [[ ! -d "${sshdDirectory}" ]]; then
      $DRY_RUN_CMD rm $VERBOSE_ARG --recursive --force "${sshdTmpDirectory}"
      $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${sshdTmpDirectory}"

      $VERBOSE_ECHO "Generating host keys..."
      $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t rsa -b 4096 -f "${sshdTmpDirectory}/ssh_host_rsa_key" -N ""

      $VERBOSE_ECHO "Writing sshd_config..."
      $DRY_RUN_CMD echo -e "HostKey ${sshdDirectory}/ssh_host_rsa_key\nPort ${toString port}\n" > "${sshdTmpDirectory}/sshd_config"

      $DRY_RUN_CMD mv $VERBOSE_ARG "${sshdTmpDirectory}" "${sshdDirectory}"
    fi
  '';

  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    vim # or some other editor, e.g. nano or neovim

    # Some common stuff that people expect to have
    procps
    killall
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    #man
    gnugrep
    gnupg
    pinentry
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
    openssh
    nettools
    curl
    wget
    git
    # neovim and tools around that
    pkgsUnstable.lazygit
    pkgsUnstable.zellij
    pkgsUnstable.yazi
    pkgsUnstable.neovim
    zoxide
    zsh
    jetbrains-mono
    pkgsUnstable.oh-my-posh
    pkgsUnstable.atuin
    pkgsUnstable.fzf
    pkgsUnstable.clang
    pkgsUnstable.gleam
    pkgsUnstable.elixir
    pkgsUnstable.erlang
    pkgsUnstable.ocaml
    cargo
    rustc
    nodejs
    # python
    pkgsUnstable.python3
    pkgsUnstable.ruff
    pkgsUnstable.basedpyright
    # other language servers
    lua-language-server
    spectral-language-server
    # ocaml
    opam
    gnumake
    patch
    (pkgs.writeScriptBin "sshd-start" ''
      #!${pkgs.runtimeShell}

      echo "Starting sshd in non-daemonized way on port ${toString port}"
      ${pkgs.openssh}/bin/sshd -f "${sshdDirectory}/sshd_config" -D
    '')
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  #nix.extraOptions = ''
  #  experimental-features = nix-command flakes
  #'';

  # Set your time zone
  time.timeZone = "Europe/Berlin";

  # After installing home-manager channel like
  #   nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
  #   nix-channel --update
  # you can configure home-manager in here like
  #home-manager = {
  #  useGlobalPkgs = true;
  #
  #  config =
  #    { config, lib, pkgs, ... }:
  #    {
  #      # Read the changelog before changing this value
  #      home.stateVersion = "24.05";
  #
  #      # insert home-manager config
  #    };
  #};
  user.shell = "${pkgs.zsh}/bin/zsh";
  terminal.font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
}

# vim: ft=nix
