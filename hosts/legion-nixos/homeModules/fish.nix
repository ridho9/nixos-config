{ pkgs, ... }:
{
  config = {
    home.packages = [
      pkgs.eza
      pkgs.bat
    ];

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      shellAbbrs = {
        gst = "git status";
        gc = "git commit";
        ga = "git add";
        gco = "git add";
      };
      shellAliases = {
        cd = "z";
        ls = "eza";
      };
    };

    programs.direnv = {
      enable = true;
    };

    programs.zoxide = {
      enable = true;
    };

    programs.starship = {
      enable = true;
    };
    xdg.configFile."starship.toml".source = ./dotfiles/starship.toml;
  };
}
