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
      system = final.system;
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
