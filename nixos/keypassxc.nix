{ pkgs, lib, ... }:
{
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  programs.ydotool.enable = true;
  users.users.nathan.extraGroups = [ "ydotool"];
  # enable this by hand
  # home-manager.users.nathan.programs.keepassxc = {
  #   autostart = true;
  #   enable = true;
  #   settings = {
  #     # For available settings, see https://github.com/keepassxreboot/keepassxc/blob/develop/src/core/Config.cpp
  #     FdoSecrets.Enabled = true; # Enable Secret Service Integration
  #   };
  # };
  #
  # home-manager.users.nathan.xdg.autostart.enable = true; # Enable creation of XDG autostart entries.
}
