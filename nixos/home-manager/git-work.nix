{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Nathan Hüsken";
      user.email = "nathan.huesken-extern@deutschebahn.com";
      core.editor = "${pkgs.neovim}/bin/nvim";
      init.defaultBranch = "main";
      pull.rebase = true;
      alias = {
        unstage = "reset HEAD --";
        pr = "pull --rebase";
        co = "checkout";
        ci = "commit";
        c = "commit";
        b = "branch";
        p = "push";
        d = "diff";
        a = "add";
        s = "status";
        f = "fetch";
        br = "branch";
        rf = "reflog";
      };
    };
  };
}
