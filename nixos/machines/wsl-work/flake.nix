{
  description = "WSL at Work NixOS Flake config for home-manager";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # NixOS unstable channel
    # nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # NUR
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      nur,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
    in
    {
      homeConfigurations = {
        nathan = home-manager.lib.homeManagerConfiguration {
          # specialArgs = { inherit inputs outputs; };
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            { nix.registry.nixpkgs.flake = nixpkgs; }
            { nixpkgs.overlays = [ nur.overlays.default ]; }
            # Import the previous configuration.nix we used,
            # so the old configuration file still takes effect
            ./home.nix
          ];
        };
      };
    };
}
