{
  config,
  pkgs,
  ...
}:
let
  # Windows GnuPG, present only on WSL where the C: drive is mounted.
  # Detection has to happen at runtime: with flakes, Nix evaluates in pure
  # mode where `builtins.pathExists` on paths outside the flake is always
  # false, so an eval-time check would never see the Windows binary.
  winGpg1 = "/mnt/c/Program Files (x86)/GnuPG/bin/gpg.exe";
  winGpg2 = "/mnt/c/Program Files/GnuPG/bin/gpg.exe";
  gpgWrapper = pkgs.writeShellScript "gpg-wrapper" ''
    if [ -x "${winGpg1}" ]; then
      exec "${winGpg1}" "$@"
    else
      if [ -x "${winGpg2}" ]; then
        exec "${winGpg2}" "$@"
      else
        exec "${pkgs.gnupg}/bin/gpg" "$@"
      fi
    fi
  '';
in
{
  programs.git = {
    enable = true;
    signing.signByDefault = true;
    signing.key = "A7FB930FB8597407AEAB96236FEB23FCF209BDB0";
    settings = {
      user.name = "Nathan Hüsken";
      user.email = "nathan@huesken.org";
      core.editor = "${pkgs.neovim}/bin/nvim";
      core.excludesfile = "~/.config/git/gitignore";
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
      gpg.program = "${gpgWrapper}";
    };
  };

  home.file.gitignore_global = {
    enable = true;
    target = ".config/git/gitignore";
    text = ".envrc\n.venv";
  };
}
