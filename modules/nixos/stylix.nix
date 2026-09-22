{ config, pkgs, ... }:
{

  stylix.enable = true;
  stylix.image = ./../../wallpaper.png;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.polarity = "dark";
  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font";
    };
    sizes.applications = 10;
  };

  stylix.targets.fish.enable = false;
  stylix.targets.grub.enable = false;

  home-manager.users.rid9 = {
    stylix.targets.fish.enable = false;
    stylix.targets.waybar.enable = false;
    stylix.targets.alacritty.enable = false;
    stylix.targets.ghostty.enable = false;
    stylix.targets.rofi.enable = true;

    # Same reasoning as the system-level block below: only these two ports are
    # wanted here, stylix themes the rest.
    catppuccin = {
      autoEnable = false;
      fish.enable = true;
      alacritty.enable = true;
    };
  };

  # Pin autoEnable to today's behaviour. Upstream is moving to a model where
  # catppuccin.enable acts as a global toggle that themes every supported port
  # automatically; we deliberately enable only a few (fish, alacritty, grub)
  # and let stylix handle the rest, so opt out of the blanket enrolment.
  catppuccin = {
    autoEnable = false;
    grub.enable = true;
  };
}
