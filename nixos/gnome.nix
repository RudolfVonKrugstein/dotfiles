{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  services.desktopManager.gnome.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.enableRedistributableFirmware = true;

  # firefox
  programs.firefox.enable = true;
  # thunderbird
  programs.thunderbird.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  environment.systemPackages = with pkgs; [
    mesa-demos
    networkmanagerapplet
    wl-clipboard
  ];
  services.flatpak.enable = true;

  # enable scanners
  hardware.sane.enable = true;

  # enable fingerprintscanner
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # fix, see: https://discourse.nixos.org/t/virtualbox-under-gnome/74450/2
  environment.extraInit = ''
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  '';
}
