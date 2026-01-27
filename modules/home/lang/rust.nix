{ pkgs, ... }:
{
  config = {
    home.packages = [
      pkgs.rustc
      pkgs.cargo
      pkgs.rust-analyzer
      pkgs.clippy
      pkgs.rustfmt
    ];
  };
}
