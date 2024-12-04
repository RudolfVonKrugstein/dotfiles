

{
config, 
lib, 
pkgs,
... }: {
    home.activation = {
      nushellConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD rm -rf $HOME/.config/nushell
      $DRY_RUN_CMD cd $HOME/.config/
      $DRY_RUN_CMD ln -s ../dotfiles/nushell $HOME/.config/nushell
      '';
    };
}
