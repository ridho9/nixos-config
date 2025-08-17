{
  config,
  pkgs,
  lib,
  input,
  ...
}:

{
  imports = [
    ./homeModules/fish.nix
    ./homeModules/hyprland.nix

    ./homeModules/lang/python3.nix
    ./homeModules/lang/nix.nix
    ./homeModules/lang/go.nix
    ./homeModules/lang/js.nix
    ./homeModules/lang/ocaml.nix
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

  home.sessionPath = [ "$HOME/.local/bin" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # betterbird
    # thunderbird
    vscode-fhs
    firefox-devedition
    brave
    discord

    fastfetch
    gh

    wayland-scanner
    mpv
    httpie
    slack
    devenv
    postgresql
    valkey

    hyperfine
    caddy
    google-cloud-sdk
    postman

    qbittorrent-enhanced

    scrcpy

    # racket
    kdePackages.okular

    beekeeper-studio

    prismlauncher

    supabase-cli
    php
    dbeaver-bin
    git-filter-repo
    # trippy

    adw-gtk3
    adwaita-icon-theme

    winetricks
    wineWowPackages.waylandFull
    xarchiver

    protonplus
    code-cursor-fhs

    zed-editor-fhs

    dbus
    temporal-cli
    zellij
  ];

  services.gnome-keyring.enable = true;
  # services.blueman-applet.enable = true;

  xdg.autostart.enable = true;

  programs.git = {
    enable = true;
    userName = "ridho9";
    userEmail = "p.ridho9@gmail.com";
    lfs.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-wlr
    ];
    # config.common.default = "*";
    xdgOpenUsePortal = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "FiraCode Nerd Font";
      env.TERM = "xterm-256color";
      window.decorations = "none";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # programs.wezterm = {
  #   enable = true;
  # };

  # programs.rio = {
  #   enable = true;
  # };
}
