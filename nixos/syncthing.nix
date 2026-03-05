{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "nathan";
    configDir = "/home/nathan/.config/syncthing";
    overrideDevices = false;     # overrides any devices added or deleted through the WebUI
    overrideFolders = false;     # overrides any folders added or deleted through the WebUI
    settings = {
      folders = {
        "Password" = {
          path = "/home/nathan/password";
        };
        "Buchhaltung" = {
          path = "/home/nathan/buchhaltung";
        };
      };
    };
  };
}
