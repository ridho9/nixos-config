{ pkgs, ... }:
{
  config = {
    home.packages = [
      (pkgs.python3.withPackages (ppkgs: with ppkgs; [ ]))
      pkgs.poetry
    ];
  };
}
