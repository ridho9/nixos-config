{ pkgs, ... }:
{
  users.users.rid9 = {
    isNormalUser = true;
    home = "/home/rid9";
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$AzOsDEZH9zFSF0AT$g9pxQMibYSOm390jTMiTzYhxT50yM8AsjDAbCfmqkwKT4VdddZ8xTu.3dC44yOsiCt24dniIBNJDZaKfOIGws1";
    shell = pkgs.fish;
  };

  home-manager.users.rid9 = import ./../homeModules/default.nix;
}
