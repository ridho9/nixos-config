{ pkgs, ... }:
{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    swww
    swayidle
  ];

  home-manager.users.rid9 = {
    xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
  };
}
