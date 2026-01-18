{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  overlay-unstable = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

in
{
  nixpkgs = {
    overlays = [ overlay-unstable ];
    config = {
      allowUnfree = true;
    };
  };
}
