{ config, pkgs, ... }:
{

  stylix.enable = true;
  stylix.image = ./../../wallpaper.png;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.polarity = "dark";
  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
      name = "FiraCode Nerd Font";
    };
  };

  stylix.targets.fish.enable = false;
}
