{ pkgs, ... }:
{
  config = {
    home.packages = [
      pkgs.go
      pkgs.gopls
      pkgs.wgo
      pkgs.delve
    ];

    programs.go = {
      enable = true;
      env.GOBIN = ".local/bin.go";
    };

    home.sessionPath = [ "$HOME/.local/bin.go" ];
  };
}
