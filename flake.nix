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
        system = system;
        specialArgs = {
          inherit inputs system;
        };
        modules = [
          inputs.nixos-wsl.nixosModules.default
          {
            networking.hostName = "wsl-nixos";
            wsl.enable = true;
            wsl.defaultUser = "rid9";
            wsl.docker-desktop.enable = true;
            security.sudo.wheelNeedsPassword = true;
            programs.nix-ld = {
              enable = true;
              package = nixpkgs.legacyPackages."${system}".nix-ld-rs;
            };
          }
          ./configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}
