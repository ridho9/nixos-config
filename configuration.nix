{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
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

  users.users.rid9 = {
    isNormalUser = true;
    home = "/home/rid9";
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$AzOsDEZH9zFSF0AT$g9pxQMibYSOm390jTMiTzYhxT50yM8AsjDAbCfmqkwKT4VdddZ8xTu.3dC44yOsiCt24dniIBNJDZaKfOIGws1";
    shell = pkgs.fish;
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      rid9 = import ./home.nix;
    };
  };
}
