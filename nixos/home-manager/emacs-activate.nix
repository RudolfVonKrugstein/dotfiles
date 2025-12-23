{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.activation = {
    initLazyEmacs = lib.hm.dag.entryAfter [ "installPackages" ] ''
      if [ -d "$HOME/.config/emacs/bin" ]; then
        $DRY_RUN_CMD export PATH="$PATH:$HOME/.config/emacs/bin"
      fi
    '';
  };
}
