

{
config, 
lib, 
pkgs,
... }: {
    home.activation = {
      marksmanConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD rm -rf $HOME/.config/marksman
      $DRY_RUN_CMD ln -s $HOME/dotfiles/marksman $HOME/.config/marksman
      '';
    };
}
