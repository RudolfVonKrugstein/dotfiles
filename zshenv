if [ -e "$HOME/.cargo/env" ]; then
        . "$HOME/.cargo/env"
fi

if [ -e /home/nathan/.nix-profile/etc/profile.d/nix.sh ]; then . /home/nathan/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
