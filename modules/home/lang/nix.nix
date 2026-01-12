{ pkgs, ... }:
{
  config = {
    home.packages = [
      pkgs.nixfmt
      pkgs.nil
      pkgs.nixd
    ];
  };
}
