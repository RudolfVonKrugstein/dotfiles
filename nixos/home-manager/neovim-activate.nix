
{
config, 
lib, 
pkgs,
... }: {
    home.activation = {
      initLazyVim = lib.hm.dag.entryAfter ["installPackages"] ''
      export PATH="$HOME/bin:$PATH"
      if [ -d "$HOME/.config/nvim" ]; then
        $DRY_RUN_CMD rm -rf $HOME/.config/nvim
      fi

      # symlink nvim
      $DRY_RUN_CMD cd $HOME/.config
      $DRY_RUN_CMD ln -s $HOME/dotfiles/nvim $HOME/.config/nvim
      '';
    };
}
