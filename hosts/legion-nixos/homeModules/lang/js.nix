{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      nodejs
      yarn
    ];

    programs.bun.enable = true;
  };
}
