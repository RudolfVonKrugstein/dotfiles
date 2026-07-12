{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.gpg = {
    enable = true;
    publicKeys = [ ]; # see https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys
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
    # On GNOME hosts the desktop's gcr-ssh-agent is the ssh-agent; let it win.
    # Everywhere else (e.g. WSL) gpg-agent provides the ssh-agent.
    enableSshSupport = !config.installBundles.gnome;
    pinentry.package = pkgs.pinentry-gtk2;

  };
}
