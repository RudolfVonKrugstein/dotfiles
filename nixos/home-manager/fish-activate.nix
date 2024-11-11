

{
config, 
lib, 
pkgs,
... }: {
    home.activation = {
      fishConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD rm -rf $HOME/.config/fish
      $DRY_RUN_CMD ln -s $HOME/dotfiles/fish $HOME/.config/fish
      '';
    };
}
