{config,lib,pkgs, ...}:
{
  services.ollama = {
    enable = false;
    acceleration = "cuda";
  };
}
