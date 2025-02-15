{
config, 
lib, 
pkgs,
... }: {
    home.activation = {
      zellijConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD rm -rf $HOME/.config/zellij
      $DRY_RUN_CMD cd $HOME/.config/
      $DRY_RUN_CMD ln -s ../dotfiles/zellij $HOME/.config/zellij

      $DRY_RUN_CMD mkdir -p $HOME/.config/zellij/plugins
      $DRY_RUN_CMD ${pkgs.wget}/bin/wget https://github.com/laperlej/zellij-sessionizer/releases/latest/download/zellij-sessionizer.wasm -O ~/.config/zellij/plugins/zellij-sessionizer.wasm
      $DRY_RUN_CMD ${pkgs.wget}/bin/wget https://github.com/strech/zbuffers/releases/latest/download/zbuffers.wasm -O ~/.config/zellij/plugins/zbuffers.wasm
      '';
    };
}
