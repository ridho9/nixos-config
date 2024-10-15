{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./fish.nix

    ./lang/python3.nix
    ./lang/nix.nix
    ./lang/go.nix
  ];

  home.username = "rid9";
  home.homeDirectory = "/home/rid9";

  home.stateVersion = "24.05";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.fastfetch
    pkgs.gh
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file =
    {
    };

  home.sessionVariables =
    {
    };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "ridho9";
    userEmail = "p.ridho9@gmail.com";
  };
}
