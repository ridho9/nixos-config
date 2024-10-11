{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./users.nix
  ];

  system.stateVersion = "24.05";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    neovim
    vim
    wget
    git
  ];

  programs.fish = {
    enable = true;
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
