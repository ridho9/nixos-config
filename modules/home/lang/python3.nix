{ pkgs, ... }:
{
  config = {
    home.packages = [
      (pkgs.python313.withPackages (
        ppkgs: with ppkgs; [
          requests
          reportlab
        ]
      ))
      pkgs.poetry
      pkgs.uv
    ];
  };
}
