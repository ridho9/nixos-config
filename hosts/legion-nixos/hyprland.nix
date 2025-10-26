{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  config = lib.mkIf config.mySystem.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
  };
}
