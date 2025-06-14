
{
config, 
lib, 
pkgs,
... }: {
    home.activation = {
      initDirenv = lib.hm.dag.entryAfter ["installPackages"] ''
      export PATH="$HOME/bin:$PATH"

      # create the directory
      $DRY_RUN_CMD mkdir -p ~/.config/direnv/

      # symlink the direnvrc
      $DRY_RUN_CMD rm ~/.config/direnv/direnvrc
      $DRY_RUN_CMD ln -s ../../dotfiles/direnvrc ~/.config/direnv/
      '';
    };
}
