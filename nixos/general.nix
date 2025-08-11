{config,lib,pkgs, ...}:
{
  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Set your time zone
  time.timeZone = "Europe/Berlin";

}
