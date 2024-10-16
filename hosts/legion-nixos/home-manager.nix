{ config, pkgs, ... }:

{
  imports = [
    ./homeModules/fish.nix
    ./homeModules/lang/nix.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "rid9";
  home.homeDirectory = "/home/rid9";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    #  thunderbird
    vscode-fhs
    firefox-devedition
    floorp
    discord

    fastfetch
    gh

  ];

  programs.git = {
    enable = true;
    userName = "ridho9";
    userEmail = "p.ridho9@gmail.com";
  };

  # programs.wezterm = {
  #   enable = true;
  #   extraConfig = ''
  #     return {
  #       front_end = "WebGpu"
  #     }
  #   '';
  # };

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "FiraCode Nerd Font";
    };
  };
}
