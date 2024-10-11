{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./../../nixosModules/default.nix
  ];

  config = {
    networking.hostName = "wsl-nixos";
    wsl.enable = true;
    wsl.defaultUser = "rid9";
    wsl.docker-desktop.enable = true;
    security.sudo.wheelNeedsPassword = true;
    programs.nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
  };
}
