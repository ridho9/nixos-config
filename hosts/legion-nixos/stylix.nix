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
  stylix.targets.grub.enable = false;

  home-manager.users.rid9 = {
    stylix.targets.fish.enable = false;
    stylix.targets.waybar.enable = false;
    stylix.targets.alacritty.enable = false;
  };
}
