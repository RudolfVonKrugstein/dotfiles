
{
config, 
lib, 
pkgs,
... }: {
    programs.git = {
      enable = true;
      userName = "Nathan Hüsken";
      userEmail = "nathan@huesken";
      signing.signByDefault = true;
      signing.key = "A7FB930FB8597407AEAB96236FEB23FCF209BDB0";
      aliases = {
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
      extraConfig = {
        core.editor = "${pkgs.neovim}/bin/nvim";
      };
    };
}
