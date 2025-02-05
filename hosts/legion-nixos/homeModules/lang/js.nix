{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      nodejs
      yarn
      deno
    ];

    programs.bun.enable = true;

  };
}
