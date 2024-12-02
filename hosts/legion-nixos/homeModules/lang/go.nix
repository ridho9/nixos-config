{ pkgs, ... }:
{
  config = {
    home.packages = [
      pkgs.go
      pkgs.gopls
      pkgs.wgo
    ];

    programs.go = {
      enable = true;
    };
  };
}
