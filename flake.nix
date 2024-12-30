{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";
    catppuccin.url = "github:catppuccin/nix";
    hyprland-qtutils.url = "github:hyprwm/hyprland-qtutils";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.wsl-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/wsl-nixos/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      nixosConfigurations.legion-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system;
        };
        modules = [
          ./hosts/legion-nixos/configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.nixos-hardware.nixosModules.lenovo-legion-15ach6h
          inputs.stylix.nixosModules.stylix
          inputs.catppuccin.nixosModules.catppuccin
        ];
      };
    };
}
