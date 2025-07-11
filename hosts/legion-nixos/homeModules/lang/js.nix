{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      nodejs
      yarn
      deno
      pnpm

      nodePackages."@nestjs/cli"
      turbo
    ];

    programs.bun.enable = true;

    home.sessionVariables.PNPM_HOME = "$HOME/.pnpm";
  };
}
