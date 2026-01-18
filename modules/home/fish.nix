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
      functions = {
        cursor = ''
          set -l user_data_dir ""
          set -l target_path ""

          if test (count $argv) -gt 0
            set target_path (realpath -m -- $argv[1] 2>/dev/null; or echo $argv[1])
          else
            set target_path (pwd)
          end

          if string match -q "$HOME/Work/crediflow*" -- $target_path
            set user_data_dir "$HOME/.config/cursor-crediflow"
          else if string match -q "$HOME/Work/cata*" -- $target_path
            set user_data_dir "$HOME/.config/cursor-cata"
          end

          if test -n "$user_data_dir"
            echo "Using cursor with: $user_data_dir"
            command cursor --user-data-dir="$user_data_dir" $argv
          else
            command cursor $argv
          end
        '';
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
  };
}
