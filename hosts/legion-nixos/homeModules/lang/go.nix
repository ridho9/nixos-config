{ pkgs, ... }:
{
  config = {
    home.packages = [
      pkgs.go
      pkgs.gopls
    ];

    programs.go = {
      enable = true;
    };
  };
}
