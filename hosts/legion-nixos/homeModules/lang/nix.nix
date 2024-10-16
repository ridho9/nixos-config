{ pkgs, ... }:
{
  config = {
    home.packages = [
      pkgs.nixfmt-rfc-style
      pkgs.nil
    ];
  };
}
