

{
config, 
lib, 
pkgs,
... }: {
    home.activation = {
      configs = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN mkdir -p $HOME/.config

      $DRY_RUN_CMD rm -rf $HOME/.config/marksman
      $DRY_RUN_CMD cd $HOME/.config/
      $DRY_RUN_CMD ln -s ../dotfiles/marksman $HOME/.config/marksman

      $DRY_RUN_CMD rm -rf $HOME/.config/panache
      $DRY_RUN_CMD cd $HOME/.config/
      $DRY_RUN_CMD ln -s ../dotfiles/panache $HOME/.config/panache
      '';
    };
}
