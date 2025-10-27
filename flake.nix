{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

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
          inputs.home-manager.nixosModules.default
          inputs.nixos-hardware.nixosModules.lenovo-legion-15ach6h
          inputs.stylix.nixosModules.stylix
          inputs.catppuccin.nixosModules.catppuccin
          ./hosts/legion-nixos/configuration.nix
        ];
      };
    };
}
