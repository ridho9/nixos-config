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
    pavucontrol
    pipewire
    wireplumber
  ];

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };

  services.mako = {
    enable = true;
    settings.default-timeout = 2000;
  };

  programs.fuzzel = {
    enable = true;
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
