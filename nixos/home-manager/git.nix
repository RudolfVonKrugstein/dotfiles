{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    signing.signByDefault = true;
    signing.key = "A7FB930FB8597407AEAB96236FEB23FCF209BDB0";
    settings = {
      user.name = "Nathan Hüsken";
      user.email = "nathan@huesken.org";
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
