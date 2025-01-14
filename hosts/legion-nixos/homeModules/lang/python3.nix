{ pkgs, ... }:
{
  config = {
    home.packages = [
      (pkgs.python313.withPackages (
        ppkgs: with ppkgs; [
          requests
        ]
      ))
      pkgs.poetry
      # pkgs.uv
    ];
  };
}
