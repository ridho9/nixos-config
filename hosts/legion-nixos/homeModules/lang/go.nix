{ pkgs, ... }:
{
  config = {
    home.packages = [
      pkgs.go
      pkgs.gopls
      pkgs.wgo
    ];

    programs.go = {
      enable = true;
      goBin = ".local/bin.go";
    };

    home.sessionPath = [ "$HOME/.local/bin.go" ];
  };
}
