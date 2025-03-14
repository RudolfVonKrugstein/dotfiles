
{
config, 
lib, 
pkgs,
... }: {
    home.activation = {
      initLazyVim = lib.hm.dag.entryAfter ["installPackages"] ''
      export PATH="$HOME/bin:$PATH"
      if [ ! -d "$HOME/.config/nvim" ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/LazyVim/starter $HOME/.config/nvim
      fi

      # symlink the layzvim.json
      $DRY_RUN_CMD rm -rf $HOME/.config/nvim/lazyvim.json
      $DRY_RUN_CMD cd $HOME/.config/nvim/
      $DRY_RUN_CMD ln -s ../../dotfiles/lazyvim/lazyvim.json $HOME/.config/nvim/lazyvim.json

      # symlink files in config dir
      $DRY_RUN_CMD mkdir -p $HOME/.config/nvim/lua/config
      $DRY_RUN_CMD cd $HOME/.config/nvim/lua/config
      for config_file in ../../../../dotfiles/lazyvim/lua/config/*.lua; do
        export target_config_file="$HOME/.config/nvim/lua/config/$(basename $config_file)"
        $DRY_RUN_CMD rm -rf "$target_config_file"
        echo "$config_file -> $target_config_file"
        $DRY_RUN_CMD ln -s "$config_file" "$target_config_file"
      done

      # symlink files in plugin dir
      $DRY_RUN_CMD mkdir -p $HOME/.config/nvim/lua/plugins
      $DRY_RUN_CMD cd $HOME/.config/nvim/lua/plugins
      for plugin_file in ../../../../dotfiles/lazyvim/lua/plugins/*.lua; do
        export target_plugin_file="$HOME/.config/nvim/lua/plugins/$(basename $plugin_file)"
        $DRY_RUN_CMD rm -rf "$target_plugin_file"
        echo "$plugin_file -> $target_plugin_file"
        $DRY_RUN_CMD ln -s "$plugin_file" "$target_plugin_file"
      done

      # symlink spell dir
      $DRY_RUN_CMD rm -rf $HOME/.config/nvim/spell
      $DRY_RUN_CMD cd $HOME/.config/nvim
      $DRY_RUN_CMD ln -s ../../dotfiles/lazyvim/spell $HOME/.config/nvim/spell

      # symlink ftplugin dir
      $DRY_RUN_CMD rm -rf $HOME/.config/nvim/ftplugin
      $DRY_RUN_CMD cd $HOME/.config/nvim
      $DRY_RUN_CMD ln -s ../../dotfiles/lazyvim/ftplugin $HOME/.config/nvim/ftplugin
      '';
    };
}
