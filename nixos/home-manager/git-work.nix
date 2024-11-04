
{
config, 
lib, 
pkgs,
... }: {
    programs.git = {
      enable = true;
      userName = "Nathan Hüsken";
      userEmail = "nathan.huesken-extern@deutschebahn.com";
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
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
}
