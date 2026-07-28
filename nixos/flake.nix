{
  description = "Leomin's Modular NixOS Flake Configuration";

  inputs = {
    # NixOS official package repository (Using unstable/latest version)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager repository
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # This hostname must match your networking.hostName inside network.nix
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          /etc/nixos/hardware-configuration.nix 
          ./modules/default.nix
        ];
      };
    };
  };
}
