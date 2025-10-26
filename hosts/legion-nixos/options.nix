{ lib, ... }:
{
  options.mySystem.hyprland.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Hyprland compositor and related packages";
  };
}
