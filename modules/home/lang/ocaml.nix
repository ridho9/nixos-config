{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      ocaml
      dune_3
    ];
  };
}
