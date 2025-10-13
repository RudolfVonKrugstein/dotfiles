{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.activation = {
    zellijConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH=$PATH:${lib.makeBinPath [ pkgs.gcc ]}

      $DRY_RUN_CMD rm -rf $HOME/.config/zellij
      $DRY_RUN_CMD cd $HOME/.config/
      $DRY_RUN_CMD ln -s ../dotfiles/zellij $HOME/.config/zellij

      $DRY_RUN_CMD mkdir -p $HOME/.config/zellij/plugins
      $DRY_RUN_CMD ${pkgs.wget}/bin/wget https://github.com/laperlej/zellij-sessionizer/releases/latest/download/zellij-sessionizer.wasm -O ~/.config/zellij/plugins/zellij-sessionizer.wasm
      $DRY_RUN_CMD ${pkgs.wget}/bin/wget https://github.com/strech/zbuffers/releases/latest/download/zbuffers.wasm -O ~/.config/zellij/plugins/zbuffers.wasm
      $DRY_RUN_CMD ${pkgs.wget}/bin/wget https://github.com/mostafaqanbaryan/zellij-switch/releases/latest/download/zellij-switch.wasm -O ~/.config/zellij/plugins/zellij-switch.wasm

      $DRY_RUN_CMD mkdir -p $HOME/.local/bin
      $DRY_RUN_CMD rm -rf $HOME/.local/bin/z
      $DRY_RUN_CMD ln -s $HOME/dotfiles/zellij/z $HOME/.local/bin/z

      $DRY_RUN_CMD ${pkgs.cargo}/bin/cargo install zellij-runner
    '';
  };
}
