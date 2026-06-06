{ pkgs, ... }:
let
  minimumReleaseAgeDays = 3;
in
{
  config = {
    home.packages = [
      (pkgs.python313.withPackages (
        ppkgs: with ppkgs; [
          requests
          # reportlab
        ]
      ))
      pkgs.poetry
      pkgs.uv
    ];

    home.file.".config/uv/uv.toml".text = ''
      exclude-newer = "${toString minimumReleaseAgeDays} days"
    '';
  };
}
