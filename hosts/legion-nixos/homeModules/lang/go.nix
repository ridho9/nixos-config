{ pkgs, config, ... }:
{
  config = {
    home.packages = [
      pkgs.go
      pkgs.gopls
      pkgs.wgo
      pkgs.delve
      pkgs.go-tools
      pkgs.impl
    ];

    programs.go = {
      enable = true;
      env.GOBIN = "${config.home.homeDirectory}/.local/bin.go";
    };

    home.sessionPath = [ "${config.home.homeDirectory}/.local/bin.go" ];
  };
}
