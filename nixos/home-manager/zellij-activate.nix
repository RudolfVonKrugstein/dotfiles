{
config, 
lib, 
pkgs,
... }: {
    home.activation = {
      zellijConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD rm -rf $HOME/.config/zellij
      $DRY_RUN_CMD ln -s $HOME/dotfiles/zellij $HOME/.config/zellij
      '';
    };
}
