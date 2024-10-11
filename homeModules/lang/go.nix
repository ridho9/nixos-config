{ pkgs, ... }:
{
  config = {
    home.packages =
      [
      ];

    programs.go = {
      enable = true;
    };
  };
}
