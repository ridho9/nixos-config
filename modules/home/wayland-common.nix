{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    libnotify
    grim
    slurp
    wl-clipboard
    wl-clip-persist
    pavucontrol
    pipewire
    wireplumber
  ];

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 10000;
      ignore-timeout = true;
      "urgency=critical" = {
        default-timeout = 30000;
      };
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        width = 60;
        lines = 20;
        terminal = "${lib.getExe config.programs.ghostty.package}";
        fields = "filename,name,generic,keywords";
      };
    };
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      indicator = true;
      clock = true;
    };
  };
}
