{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }@inputs: 
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.wsl-nixos = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {inherit inputs system;};
      modules = [
        nixos-wsl.nixosModules.default
        ./configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}