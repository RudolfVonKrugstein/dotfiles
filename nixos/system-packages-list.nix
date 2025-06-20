{pkgs,unstable}: with pkgs; [
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
    file
    gawk
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
    mosh
    nettools
    curl
    wget
    git
    openssl
    xdg-utils
]
