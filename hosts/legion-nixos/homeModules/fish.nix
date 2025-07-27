{ pkgs, lib, ... }:
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
        fish_add_path "/home/rid9/.bun/bin"
      '';
      shellAbbrs = {
        gst = "git status";
        gc = "git commit";
        ga = "git add";
        gco = "git checkout";
      };
      shellAliases = {
        cd = "z";
        ls = "eza";
        zed = "zeditor";
      };
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
      settings = (builtins.fromTOML (builtins.readFile ./dotfiles/starship.toml));
    };
    # xdg.configFile."starship.toml".source = lib.mkDefault ./dotfiles/starship.toml;
  };
}
