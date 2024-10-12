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
    fish

    nh
    nvd
    nix-output-monitor
  ];

  programs.fish.enable = true;

  programs.nh = {
    enable = true;
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
