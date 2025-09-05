{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.activation = {
    uvPackages = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.uv}/bin/uv tool install zuban
    '';
  };
}
