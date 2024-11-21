{ pkgs, ... }:
let
  catppuccin-fish = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "cc8e4d8fffbdaab07b3979131030b234596f18da";
    sha256 = "udiU2TOh0lYL7K7ylbt+BGlSDgCjMpy75vQ98C1kFcc=";
  };
in
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
      catppuccin.enable = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.zoxide = {
      enable = true;
    };

    programs.starship = {
      enable = true;
    };
    xdg.configFile."starship.toml".source = ./dotfiles/starship.toml;

    # xdg.configFile."fish/themes/Catppuccin Mocha.theme".source = "${catppuccin-fish}/themes/Catppuccin Mocha.theme";
  };
}
