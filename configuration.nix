{ config, lib, pkgs, inputs, ... }:

{
  networking.hostName = "wsl-nixos";
  wsl.enable = true;
  wsl.defaultUser = "rid9";

  system.stateVersion = "24.05";
  security.sudo.wheelNeedsPassword = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  environment.systemPackages = with pkgs; [
    neovim  
    vim
    wget
    git
  ];

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };
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
    extraSpecialArgs = {inherit inputs;};
    users = {
      rid9 = import ./home.nix;
    };
  };
}
