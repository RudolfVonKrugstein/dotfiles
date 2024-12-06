

{
config, 
lib, 
pkgs,
... }: {
    home.activation = {
      lazygitConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD rm -rf $HOME/.config/lazygit
      $DRY_RUN_CMD cd $HOME/.config/
      $DRY_RUN_CMD ln -s ../dotfiles/lazygit $HOME/.config/lazygit
      '';
    };
}
