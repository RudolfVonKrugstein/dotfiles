{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = import ./system-packages-list.nix { pkgs = pkgs; };
}
