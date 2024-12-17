{ pkgs, ... }:
{
  config = {
    home.packages = [
      (pkgs.python3.withPackages (
        ppkgs: with ppkgs; [
          ppkgs.requests
        ]
      ))
      pkgs.poetry
      # pkgs.uv
    ];
  };
}
