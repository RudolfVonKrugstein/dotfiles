{
  description = "WSL NixOS Flake config";

  inputs = {
    # NixOS official package source, using the nixos-25.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
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
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # agenix
    agenix = {
      url = "github:ryantm/agenix";
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
      agenix,
      nur,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      # Please replace nixos with your hostname
      nixosConfigurations.SamZwo = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        system = "x86_64-linux";
        modules = [
          { nix.registry.nixpkgs.flake = nixpkgs; }
          { nixpkgs.overlays = [ nur.overlays.default ]; }
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
